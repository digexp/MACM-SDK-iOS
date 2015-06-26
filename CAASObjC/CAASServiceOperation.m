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


#import "CAASServiceOperation.h"
#import "CAASServiceOperationPrivate.h"

@implementation CAASServiceOperation

- (instancetype) initWithService:(CAASService *)service request:(NSURLRequest *)request
{
    self = [super init];
    if (self){
        self.service = service;
        self.request = request;
    }
    
    return self;
    
}

- (void) start
{
    
    if (!self.isCancelled){
        self.isExecuting = YES;
        self.isFinished = NO;
        [self main];
    } else {
        self.isExecuting = NO;
        self.isFinished = YES;
    }
    
}


- (void)setIsExecuting:(BOOL)isExecuting
{
    @synchronized(self){
        [self willChangeValueForKey:@"isExecuting"];
        _isExecuting = isExecuting;
        [self didChangeValueForKey:@"isExecuting"];
        if (isExecuting){
            self.didStart = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:CAASDidStartRequest object:self];
            });
        }
    }
}


- (void)setIsFinished:(BOOL)isFinished
{
    @synchronized(self){
        [self willChangeValueForKey:@"isFinished"];
        _isFinished = isFinished;
        [self didChangeValueForKey:@"isFinished"];
        if (isFinished && self.didStart){
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:CAASDidEndRequest object:self];
            });
        }
    }
}

- (void)cancel
{
    @synchronized(self){
        [super cancel];
        [self.task cancel];
    }
}

- (BOOL) isConcurrent
{
    return YES;
}

// Returns true if the error is a time out
- (BOOL) isTimeout: (NSError *)error
{
    return [error.domain isEqualToString:NSURLErrorDomain] && error.code == NSURLErrorTimedOut;
    
}

- (BOOL) isTaskCancelled: (NSError *)error
{
    return [error.domain isEqualToString:NSURLErrorDomain] && error.code == NSURLErrorCancelled;
    
}




@end
