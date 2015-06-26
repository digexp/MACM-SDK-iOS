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


#import "CAASContentItemRequest.h"
#import "CAASRequestPrivate.h"
#import "CAASService.h"
#import "CAASServicePrivate.h"
#import "CAASContentItemResult.h"
#import "CAASRequestResultPrivate.h"
#import "CAASContentItem.h"
#import "CAASContentItemPrivate.h"
#import "CAASUtils.h"

@interface CAASContentItemRequest()

@property (nonatomic,strong,readwrite) NSString *oid;
@property (nonatomic,strong,readwrite) NSString *contentPath;

@property (nonatomic, copy, readwrite) CAASContentItemCompletionBlock completionBlock;


@end

@implementation CAASContentItemRequest

- (instancetype) initWithOid:(NSString *) oid completionBlock:(CAASContentItemCompletionBlock) completionBlock
{
    self = [super init];
    if (self){
        self.oid = oid;
        self.completionBlock = completionBlock;
    }
    return self;
}

- (instancetype) initWithContentPath:(NSString *) contentPath completionBlock:(CAASContentItemCompletionBlock) completionBlock
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
    
    queryParams[@"ibm.type.information"] = @"true";
    
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
    
    NSMutableDictionary *requestParams = [self queryParams];
    [params addEntriesFromDictionary: requestParams];
    if (self.isGeolocalized)
        [caasService addGeolocationsation:requestParams];
    
    NSURLComponents *URLComponents = [[NSURLComponents alloc] initWithURL:URL resolvingAgainstBaseURL:YES];
    URLComponents.percentEncodedQuery = [CAASUtils buildQueryStringWithParams:params];
    
    CAASContentItemResult *requestResult = [[CAASContentItemResult alloc] initWithRequest:self];
    
    CAASServiceOperation *operation = [caasService performRequest:URLComponents.URL completionHandler:^(NSError * __nullable error, NSInteger httpStatusCode,  NSDictionary * __nullable json) {
        if (error == nil && [CAASUtils isHTTPStatusCodeOK:httpStatusCode] && json != nil){
            CAASContentItem *contentItem = [[CAASContentItem alloc] initWithContentItem:json baseURL:caasService.baseURL];
            requestResult.json = @{@"contentItem":contentItem};
        }
        requestResult.error = error;
        requestResult.httpStatusCode = httpStatusCode;
        
        self.completionBlock(requestResult);
        
    }];
    
    requestResult.operation = operation;
    [caasService.caasQueue addOperation:operation];
    
    return requestResult;
}




@end
