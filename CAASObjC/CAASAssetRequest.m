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


#import "CAASAssetRequest.h"
#import "CAASAssetResult.h"
#import "CAASAssetResultPrivate.h"
#import "CAASRequestPrivate.h"
#import "CAASService.h"
#import "CAASServicePrivate.h"
#import "CAASRequestResultPrivate.h"
#import "CAASUtils.h"

@interface CAASAssetRequest()

@property (nonatomic, copy, readwrite) CAASAssetCompletionBlock completionBlock;

@property (nonatomic,copy,readwrite) NSURL *assetURL;

@end

@implementation CAASAssetRequest

- (instancetype) initWithAssetURL:(NSURL *) assetURL completionBlock:(CAASAssetCompletionBlock) completionBlock
{
    self = [super init];
    if (self){
        self.completionBlock = completionBlock;
        self.assetURL = assetURL;
    }
    
    return self;
}

- (CAASRequestResult *) execute:(CAASService *) caasService
{
    NSURLComponents *URLComponents = [[NSURLComponents alloc] initWithURL:self.assetURL resolvingAgainstBaseURL:YES];
    
    NSArray* queryItems = URLComponents.queryItems;
    NSMutableDictionary *params = [NSMutableDictionary new];
    for (NSURLQueryItem *queryItem in queryItems){
        params[queryItem.name] = queryItem.value;
    }
    
    //[params addEntriesFromDictionary: [CAASUtils queryParamsContext]];
    if (self.isGeolocalized)
        [caasService addGeolocationsation:params];
    URLComponents.percentEncodedQuery = [CAASUtils buildQueryStringWithParams:params];
    
    CAASAssetResult *requestResult = [[CAASAssetResult alloc] initWithRequest:self];
    CAASServiceOperation *operation = [caasService performDownloadRequest:URLComponents.URL completionHandler:^(NSError * __nullable error, NSInteger httpStatusCode, NSData * __nullable data) {
        if (error == nil && httpStatusCode == 200){
            NSString *contentType = requestResult.httpResponse.allHeaderFields[@"Content-Type"];
            if ([contentType hasPrefix:@"image/"])
                requestResult.image = [UIImage imageWithData:data scale:[UIScreen mainScreen].scale];
            else {
                requestResult.data = data;
            }
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
