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

#import "CAASContentItem.h"
#import "CAASRequest.h"
#import "CAASRequestResult.h"

NS_ASSUME_NONNULL_BEGIN


/// CAAS errors

FOUNDATION_EXPORT NSString *const CAASErrorDomain;

FOUNDATION_EXPORT NSString *const CAASDidSignIn;

FOUNDATION_EXPORT NSString *const CAASDidStartRequest;
FOUNDATION_EXPORT NSString *const CAASDidEndRequest;

enum
{
    CAASNotSignedIn = -1
};


typedef void (^CAASSignInCompletionHandler)(NSError * __nullable error,NSInteger httpStatusCode);

/**
 CAASService is the central class to access a MACM server.
*/

@interface CAASService : NSObject

/**
 Initializes a CAASService object with the specified base URL. The context root is the default CAAS context root, that is wps
 
 @param url The base URL for the HTTP client. It is the URL of a Web Content Manager host
 @param contextRoot The CAAS context root
 @param tenant The tenant/service instance name. The base portal is addressed when omitted.
 
 @return The newly-initialized CAASService
 */
- (nullable instancetype)initWithBaseURL:(NSURL *)url contextRoot:(NSString *)contextRoot tenant:( NSString * __nullable )tenant;

/**
 Initializes a CAASService object with the specified base URL. The context root is the default CAAS context root, that is wps
 
 @param url The base URL for the HTTP client. It is the URL of a Web Content Manager host
 @param contextRoot The CAAS context root
 @param tenant The tenant/service instance name. The base portal is addressed when omitted.
 @param username username
 @param password password
 
 @return The newly-initialized CAASService
 */
- (nullable instancetype)initWithBaseURL:(NSURL *)url contextRoot:(NSString *)contextRoot tenant:( NSString * __nullable )tenant username:(NSString *) username password:(NSString *)password;

/**
 Authenticates against a MACM server. If the authentication finished succesfully, the credentials are store in the keychain and can be used later with the silent sign method
 
 @param user user to authenticate
 @param password password of the given user
 @param completionHandler A block object to be executed when the operation finishes. This block has no return value and takes two arguments: an NSError which can be nil and an NSInteger which is the http status code of the HTTP response
 
 @return an NSOperation that executes the authentication
 */
- (NSOperation *) signIn:(NSString *) user password: (NSString *) password completionHandler:(CAASSignInCompletionHandler) completionHandler;

/**
 Remove the credentials from the key chain
 */
- (void) signOut;

/**
 
 @return true when a user has been already signed in successfully once.
 
 */
- (BOOL) isUserAlreadySignedIn;

/**
 Sign in with the credentials saved in the key chain
 */
- ( NSOperation * __nullable ) silentSignInWithCompletionHandler:(CAASSignInCompletionHandler) completionHandler;

/**
 Executes an asynchronous request against an MACM server
 @param request to be executed
 
 @return a future/promise of the result received in response to the given request  
 */
- (CAASRequestResult *) executeRequest: (CAASRequest *) request;

/**
 The time-out used in all the request against the CAAS server, default is 30 seconds.
 */
@property (nonatomic,assign) NSTimeInterval timeout;

/**
 The time-out used for sign in, default is 10 seconds.
 */
@property (nonatomic,assign) NSTimeInterval signInTimeout;

/**
 Maximum number of retries when a network error occurs, default is 3.
 */
@property (nonatomic,assign) NSInteger maxRetry;

/**
 Cancel all pending requests
 */
- (void) cancelAllPendingRequests;

/**
 Returns the NSURLSession used by the CAASService
 */
@property (nonatomic,strong,readonly) NSURLSession *caasSession;
/**
 Returns the base URL of the MACM server, that is scheme ":" host [ ":" port ]
 */
@property (nonatomic,strong,readonly) NSURL *baseURL;

/**
 Context root of the MACM instance
 */
@property (nonatomic,strong,readonly) NSString *contextRoot;

/**
 Tenant of the MACM instance
 */
@property (nonatomic,strong,readonly,nullable) NSString *tenant;

/**
 true if untrusted certificates are allowed in DEBUG mode.
 In RELEASE mode, untrusted certificates are NEVER allowed, this
 property is ignored
 */
@property (nonatomic,assign) BOOL allowUntrustedCertificates;

@end

NS_ASSUME_NONNULL_END