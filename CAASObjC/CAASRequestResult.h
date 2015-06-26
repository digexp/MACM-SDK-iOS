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

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@class CAASRequest;

/**
 A CAASRequestResult represents a futur result of a CAASRequest
 */

@interface CAASRequestResult : NSObject

/// Cancel the CAASRequest associated to this CAASRequestResult
- (void) cancel;

/// The error, if any, that happened when performing the CAASRequest
@property (strong, readonly,nullable) NSError *error;

/// The http status code, if the NSError is nil
@property (assign, readonly) NSInteger httpStatusCode;

/// The caasRequest that is corresponding to this result
@property (strong, readonly) CAASRequest *caasRequest;

/// The url used for the http request
@property (strong, readonly) NSURLRequest *httpRequest;

/// The http response corresponding to the request
@property (strong, readonly,nullable) NSHTTPURLResponse *httpResponse;

@end


NS_ASSUME_NONNULL_END
