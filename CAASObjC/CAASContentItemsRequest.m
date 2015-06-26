/*
 ********************************************************************
 * Licensed Materials - Property of IBM                             *
 *                                                                  *
 * Copyright IBM Corp. 2015 All rights reserved.                    *
 *                                                                  *
 * US Government Users Restricted Rights - Use, duplication or      *
 * disclosure restricted by GSA ADP Schedule Contract with          *
 * IBM Corp.                                                        *
 *                                                                  *
 * DISCLAIMER OF WARRANTIES. The following [enclosed] code is       *
 * sample code created by IBM Corporation. This sample code is      *
 * not part of any standard or IBM product and is provided to you   *
 * solely for the purpose of assisting you in the development of    *
 * your applications. The code is provided "AS IS", without         *
 * warranty of any kind. IBM shall not be liable for any damages    *
 * arising out of your use of the sample code, even if they have    *
 * been advised of the possibility of such damages.                 *
 ********************************************************************
 */


#import "CAASContentItemsRequest.h"
#import "CAASRequestPrivate.h"
#import "CAASService.h"
#import "CAASServicePrivate.h"
#import "CAASContentItemsResult.h"
#import "CAASRequestResultPrivate.h"
#import "CAASContentItem.h"
#import "CAASContentItemPrivate.h"
#import "CAASUtils.h"


static NSDictionary *workflowStatusMapping = nil;


@interface CAASContentItemsRequest()

@property (nonatomic,strong,readwrite) NSString *oid;

@property (nonatomic,strong,readwrite) NSString *contentPath;

@property (nonatomic, copy, readwrite) CAASContentItemsCompletionBlock completionBlock;

@end

@implementation CAASContentItemsRequest

- (instancetype) initWithOid:(NSString *) oid completionBlock:(CAASContentItemsCompletionBlock) completionBlock
{
    self = [super init];
    if (self){
        self.oid = oid;
        self.completionBlock = completionBlock;
    }
    
    return self;
    
}

- (instancetype) initWithContentPath:(NSString *) contentPath completionBlock:(CAASContentItemsCompletionBlock) completionBlock
{
    self = [super init];
    if (self){
        self.contentPath = contentPath;
        self.completionBlock = completionBlock;
    }
    
    return self;
    
}

- (NSMutableDictionary *) queryParams
{
    NSMutableDictionary *queryParams = [super queryParams];
    
    if (self.pageNumber > 0)
        queryParams[@"ibm.pageNumber"] = @(self.pageNumber).stringValue;
    if (self.pageSize > 0)
        queryParams[@"ibm.pageSize"] = @(self.pageSize).stringValue;
    if (self.sortDescriptors != nil){
        NSMutableArray *sortCriterias = [NSMutableArray new];
        for (NSSortDescriptor *desc in self.sortDescriptors){
            NSString *criteria = desc.key;
            if (desc.ascending)
                criteria = [@"+" stringByAppendingString:criteria];
            else
                criteria = [@"-" stringByAppendingString:criteria];
            
            [sortCriterias addObject:criteria];
        }
        queryParams[@"ibm.sortcriteria"] = [sortCriterias componentsJoinedByString: @","];
    }
    
    NSArray *elementsToFetch = self.elements;
    if (elementsToFetch != nil){
        NSString *elements = [elementsToFetch componentsJoinedByString:@","];
        queryParams[@"ibm.element.keys"] = elements;
    }
    
    NSArray *propertiesToFetch = self.properties;
    if (propertiesToFetch != nil){
        NSString *properties = [propertiesToFetch componentsJoinedByString:@","];
        queryParams[@"ibm.property.keys"] = properties;
    }
    
    if (self.allKeywords){
        NSString *keywords = [self.allKeywords componentsJoinedByString:@","];
        queryParams[@"ibm.filter.keywords.all"] = keywords;
        
    }
    if (self.anyKeywords){
        NSString *keywords = [self.anyKeywords componentsJoinedByString:@","];
        queryParams[@"ibm.filter.keywords.any"] = keywords;
        
    }
    if (self.allCategories){
        NSString *categories = [self.allCategories componentsJoinedByString:@","];
        queryParams[@"ibm.filter.categories.all"] = categories;
        
    }
    if (self.anyCategories){
        NSString *categories = [self.anyCategories componentsJoinedByString:@","];
        queryParams[@"ibm.filter.categories.any"] = categories;
        
    }
    if (self.titleContains){
        queryParams[@"ibm.filter.title.contains"] = self.titleContains;
    }
    
    queryParams[@"ibm.type.information"] = @"true";
    
    if (self.workflowStatus != CAASContentItemWorkflowStatusNone){
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            workflowStatusMapping = @{
                                      @(CAASContentItemWorkflowStatusDraft):@"Draft",
                                      @(CAASContentItemWorkflowStatusDeleted):@"Deleted",
                                      @(CAASContentItemWorkflowStatusPublished):@"Published",
                                      @(CAASContentItemWorkflowStatusExpired):@"Expired"};
        });
        queryParams[@"ibm.filter.workflowstatus"] = workflowStatusMapping[@(self.workflowStatus)];
        
    }

    return queryParams;
}

- (CAASRequestResult *) execute:(CAASService *) caasService
{
    
    NSString *path = [NSString stringWithFormat:kCAASSContent,caasService.contextRoot];
    if (caasService.tenant != nil){
        path = [path stringByAppendingString:[NSString stringWithFormat:@"/%@",caasService.tenant]];
    }
    
    NSString *projectName = self.projectName;
    if (projectName != nil) {
        projectName = [CAASUtils escapePath:projectName];
        path = [path stringByAppendingString:[NSString stringWithFormat:@"/$project/%@",projectName]];
    }
    
    path = [path stringByAppendingString:[NSString stringWithFormat:@"/caas"]];

    NSURL *URL = [NSURL URLWithString:path relativeToURL:caasService.baseURL];
    
    NSString *wcmpath = self.oid != nil ? [NSString stringWithFormat:@"wcm:oid:%@",self.oid] : [NSString stringWithFormat:@"wcm:path:%@",self.contentPath];
    
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    NSDictionary *wcmParams = @{@"urile":wcmpath,@"mime-type":@"application/json",@"current": @"true"};
    
    
    [params addEntriesFromDictionary: wcmParams];
    //[params addEntriesFromDictionary: [CAASUtils queryParamsContext]];
    if (self.isGeolocalized)
        [caasService addGeolocationsation:params];
    
    NSDictionary *requestParams = [self queryParams];
    [params addEntriesFromDictionary: requestParams];
    
    NSURLComponents *URLComponents = [[NSURLComponents alloc] initWithURL:URL resolvingAgainstBaseURL:YES];
    URLComponents.percentEncodedQuery = [CAASUtils buildQueryStringWithParams:params];
    
    CAASContentItemsResult *requestResult = [[CAASContentItemsResult alloc] initWithRequest:self];
    
    CAASServiceOperation *operation = [caasService performRequest:URLComponents.URL completionHandler:^( NSError * __nullable error, NSInteger httpStatusCode,  NSDictionary * __nullable json) {
        if (error == nil && [CAASUtils isHTTPStatusCodeOK:httpStatusCode] && json != nil){
            NSDictionary *contentItems = [self.class buildContentItemsFromJson:json baseURL:caasService.baseURL];
            requestResult.json = contentItems;
        }
        requestResult.error = error;
        requestResult.httpStatusCode = httpStatusCode;
        self.completionBlock(requestResult);
    }];
    
    requestResult.operation = operation;
    [caasService.caasQueue addOperation:operation];
    
    return requestResult;
    
}

+ (NSDictionary *) buildContentItemsFromJson:(NSDictionary *) json baseURL:(NSURL *) baseURL
{
    NSDictionary *listProperties = json[@"listProperties"];
    NSDictionary *allvalues = json[@"values"];
    
    NSMutableArray *contentItems = [NSMutableArray new];
    
    for (NSInteger i = 0; i < allvalues.count; i++){
        CAASContentItem *contentItem = [[CAASContentItem alloc] initWithContentItem:json itemIndex:i baseURL:baseURL];
        [contentItems addObject:contentItem];
    }
    
    return @{@"contentItems":contentItems,@"listProperties":listProperties};
    
}


@end
