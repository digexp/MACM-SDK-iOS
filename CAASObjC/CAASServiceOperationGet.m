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


#import "CAASServiceOperationGet.h"
#import "CAASServiceOperationPrivate.h"
#import "CAASService.h"
#import "CAASServicePrivate.h"
#import "CAASUtils.h"

@implementation CAASServiceOperationGet

- (void) main
{
    [self privateStart:0];
    
}
- (void) privateStart: (NSInteger) nbRetry
{
    NSURLSession *session = self.service.caasSession;
    __weak __typeof(self) weakSelf = self;
    
    @synchronized(self){
        self.task = [session dataTaskWithRequest:self.request
                                                completionHandler:
                                      ^(NSData *data, NSURLResponse *response, NSError *error) {
                                          NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                          weakSelf.response = httpResponse;
                                          weakSelf.error = error;
                                          weakSelf.httpStatusCode = httpResponse.statusCode;
                                          if (error != nil){
                                              if ([weakSelf isTaskCancelled:error]){
                                              } else if (nbRetry < weakSelf.service.maxRetry){
                                                  [weakSelf privateStart:nbRetry+1];
                                                  return;
                                              }
                                          } else {
                                              if (![CAASUtils isHTTPStatusCodeOK:httpResponse.statusCode] && nbRetry < weakSelf.service.maxRetry){
                                                  [weakSelf privateStart:nbRetry+1];
                                                  return;
                                              }
                                              weakSelf.data = data;
                                          }
                                          weakSelf.isExecuting = NO;
                                          weakSelf.isFinished = YES;
                                          
                                      }];
        
        [self.task resume];
    }
        
    
}

@end
