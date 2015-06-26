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


#import "CAASRequestResult.h"

#import "CAASRequestResultPrivate.h"
#import "CAASServiceOperationPrivate.h"

@implementation CAASRequestResult

- (instancetype) initWithRequest:(CAASRequest *) caasRequest
{
    self = [super init];
    if (self){
        self.caasRequest = caasRequest;
    }
    
    return self;
}

- (void) cancel {
    [self.operation cancel];
}

- (NSURLRequest *) httpRequest {
    return self.operation.request;
}

- (NSHTTPURLResponse *) httpResponse {
    return self.operation.response;
}

@end
