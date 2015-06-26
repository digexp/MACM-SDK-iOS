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


#import "CAASSignInOperation.h"
#import "CAASServiceOperationPrivate.h"
#import "CAASService.h"
#import "CAASServicePrivate.h"
#import "CAASUtils.h"

@implementation CAASSignInOperation

- (instancetype) initWithService:(CAASService *)service user:(NSString *)user password:(NSString *)password
{
    
    NSString *path = [NSString stringWithFormat:kCAASSignIn,service.contextRoot];
    if (service.tenant != nil){
        path = [path stringByAppendingString:[NSString stringWithFormat:@"/%@",service.tenant]];
    }
    
    NSURL *URL = [NSURL URLWithString:path relativeToURL:service.baseURL];
    NSURLComponents *URLComponents = [[NSURLComponents alloc] initWithURL:URL resolvingAgainstBaseURL:YES];
    URLComponents.query = @"uri=login:basicauth";

    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URLComponents.URL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:service.signInTimeout];
    request.HTTPMethod = @"POST";
    
    self = [super initWithService:service request:request];
    if (self){
        self.user = user;
        self.password = password;
    }
    
    return self;
}

- (void) main
{
    [self privateStart:0];
    
}
- (void) privateStart: (NSInteger) nbRetry
{
    NSURLSession *session = self.service.caasSession;
    __weak __typeof(self) weakSelf = self;
    [session resetWithCompletionHandler:^{
        weakSelf.service.user = weakSelf.user;
        weakSelf.service.password = weakSelf.password;
        
        @synchronized(self){
            self.task = [session dataTaskWithRequest:self.request
                                   completionHandler:
                         ^(NSData *data, NSURLResponse *response, NSError *error) {
                             NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                             weakSelf.error = error;
                             weakSelf.httpStatusCode = httpResponse.statusCode;
                             if (error != nil){
                                 if ([weakSelf isTaskCancelled:error]){
                                     weakSelf.isExecuting = NO;
                                     weakSelf.isFinished = YES;
                                 } else if (nbRetry < weakSelf.service.maxRetry){
                                     [weakSelf privateStart:nbRetry+1];
                                     return;
                                 }
                                 weakSelf.user = nil;
                                 weakSelf.password = nil;
                                 
                             } else {
                                 BOOL OK = [CAASUtils isHTTPStatusCodeOK:httpResponse.statusCode];
                                 if (!OK && nbRetry < weakSelf.service.maxRetry){
                                     [weakSelf privateStart:nbRetry+1];
                                     return;
                                 } else if (OK) {
                                     [weakSelf.service writeCredential:weakSelf.user password:weakSelf.password];
                                     
                                 } else {
                                     weakSelf.user = nil;
                                     weakSelf.password = nil;
                                 }
                                 
                                 weakSelf.data = data;
                             }
                             weakSelf.isExecuting = NO;
                             weakSelf.isFinished = YES;
                             
                         }];
            
            [self.task resume];
        }
    }];
    
    
    
}


@end
