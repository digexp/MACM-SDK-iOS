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


@import UIKit;


#import "CAASService.h"
#import "CAASServicePrivate.h"
#import "CAASContentItem.h"
#import "CAASContentItemPrivate.h"
#import "CAASRequest.h"
#import "CAASRequestPrivate.h"
#import "CAASContentItemRequest.h"
#import "CAASContentItemsRequest.h"
#import "CAASAssetRequest.h"
#import "CAASContentItemResult.h"
#import "CAASContentItemsResult.h"
#import "CAASAssetResult.h"
#import "CAASAssetResultPrivate.h"
#import "CAASRequestResultPrivate.h"
#import "CAASServiceOperationPrivate.h"

#import "CAASServiceOperationGet.h"
#import "CAASServiceOperationDownload.h"
#import "CAASSignInOperation.h"

#import "CAASUtils.h"

NSString * const kCAASSignIn = @"/%@/mycontenthandler";

NSString * const kCAASSContent = @"/%@/myportal";

NSString *const CAASErrorDomain = @"com.ibm.CAAS";

NSString *const CAASDidSignIn = @"com.ibm.DidSignIn";

NSString *const CAASDidStartRequest = @"com.ibm.DidStartRequest";
NSString *const CAASDidEndRequest = @"com.ibm.DidEndRequest";


@implementation CAASService

- (instancetype)initWithBaseURL:(NSURL *)url contextRoot:(NSString *)contextRoot tenant:(NSString *)tenant
{
    self = [super init];
    if (self){
        
        if ([self commonInitWithBaseURL:url contextRoot:contextRoot tenant:tenant] == nil)
            return nil;
        
        self.loginProtectionSpace = [[NSURLProtectionSpace alloc] initWithHost:self.baseURL.host
                                                                          port:self.baseURL.port.integerValue
                                                                      protocol:self.baseURL.scheme
                                                                         realm:nil
                                                          authenticationMethod:NSURLAuthenticationMethodHTTPBasic];
        NSDictionary *credentials = [[NSURLCredentialStorage sharedCredentialStorage] credentialsForProtectionSpace:self.loginProtectionSpace];
        
        if (credentials != nil){
            NSURLCredential *credential = [credentials.objectEnumerator nextObject];
            if (credential != nil){
                self.user = credential.user;
                self.password = credential.password;
            }
        }
        
    
    
    }
    
    return self;
    
}

- (instancetype)initWithBaseURL:(NSURL *)url contextRoot:(NSString *)contextRoot tenant:( NSString *)tenant username:(NSString *) username password:(NSString *)password {
    
    self = [super init];
    if (self){
        if ([self commonInitWithBaseURL:url contextRoot:contextRoot tenant:tenant] == nil)
            return nil;
        self.user = username;
        self.password = password;
    }
    
    return self;
    
}

- (instancetype) commonInitWithBaseURL:(NSURL *)url contextRoot:(NSString *)contextRoot tenant:(NSString *)tenant
{
    self.caasQueue = [NSOperationQueue new];
    self.timeout = 60;
    self.signInTimeout = 30;
    self.baseURL = url;
    self.contextRoot = contextRoot;
    self.tenant = tenant;
    self.maxRetry = 3;
    self.locationManager = [CLLocationManager new];
    
    if (url.host == nil || url.scheme == nil)
        return nil;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.HTTPCookieAcceptPolicy = NSHTTPCookieAcceptPolicyAlways;
    configuration.HTTPAdditionalHeaders = [self defaultHTTPHeaders];
    
    self.caasSession = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    // Tell the MACM instance that we use basic auth
    NSHTTPCookieStorage *cookiesStorage = self.caasSession.configuration.HTTPCookieStorage;
    
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:@{NSHTTPCookieName:@"ibm.login.type",NSHTTPCookieValue:@"basicauth",NSHTTPCookiePath:@"/",NSHTTPCookieDomain:self.baseURL.host}];
    
    [cookiesStorage setCookie:cookie];
    
    return self;
    
}

- (BOOL) isUserAlreadySignedIn {
    
    if (self.loginProtectionSpace == nil){
        return NO;
    }
    
    NSDictionary *credentials = [[NSURLCredentialStorage sharedCredentialStorage] credentialsForProtectionSpace:self.loginProtectionSpace];
    
    if (credentials != nil){
        NSURLCredential *credential = [credentials.objectEnumerator nextObject];
        if (credential != nil){
            return YES;
        }
    }
    
    return NO;
    
}

- (NSOperation *) signIn:(NSString *) user password: (NSString *) password completionHandler:(CAASSignInCompletionHandler) completionHandler
{


    [self deleteCookies];
    
    if (self.loginProtectionSpace == nil){
        NSError *error = [NSError errorWithDomain:CAASErrorDomain code:-1 userInfo:nil];
        completionHandler(error,0);
        return nil;
    }
    
    self.user = nil;
    self.password = nil;
    
    CAASSignInOperation *signInOp = [[CAASSignInOperation alloc] initWithService:self user:user password:password ];
    
    CAASSignInOperation __weak *weakOperation = signInOp;
    
    [signInOp setCompletionBlock:^{
        NSError *error = weakOperation.error;
        NSInteger httpStatusCode = weakOperation.httpStatusCode;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error == nil && [CAASUtils isHTTPStatusCodeOK:httpStatusCode]){
                [[NSNotificationCenter defaultCenter] postNotificationName:CAASDidSignIn object:self];
            }
            completionHandler(error,httpStatusCode);
        });
    }];
    
    [self.caasQueue cancelAllOperations];
    
    [self.caasQueue addOperation:signInOp];
    return signInOp;
    
    
}

- (void) signOut {
    
    [self deleteCookies];
    [self cancelAllPendingRequests];
    [self removeCredential];
    
}

- (void) deleteCookies {
    
    NSHTTPCookieStorage *cookiesStorage = self.caasSession.configuration.HTTPCookieStorage;
    
    // Remove the cookies
    NSArray *cookies = [cookiesStorage cookies];
    
    for (NSHTTPCookie *cookie in cookies){
        if (![cookie.name isEqualToString:@"ibm.login.type"])
            [[NSHTTPCookieStorage sharedHTTPCookieStorage]  deleteCookie:cookie];
    }
    
}

- (void) cancelAllPendingRequests {
    [self.caasQueue cancelAllOperations];
}

- (NSOperation *) silentSignInWithCompletionHandler:(CAASSignInCompletionHandler) completionHandler
{

    if (self.user == nil || self.password == nil){
        NSError *error = [NSError errorWithDomain:CAASErrorDomain code:CAASNotSignedIn userInfo:nil];
        completionHandler(error,0);
        return nil;
    }
    
    NSString *path = [NSString stringWithFormat:kCAASSignIn,self.contextRoot];
    if (self.tenant != nil){
        path = [path stringByAppendingString:[NSString stringWithFormat:@"/%@",self.tenant]];
    }
    path = [path stringByAppendingString:[NSString stringWithFormat:@"/caas"]];
    
    NSURL *URL = [NSURL URLWithString:path relativeToURL:self.baseURL];
    NSURLComponents *URLComponents = [[NSURLComponents alloc] initWithURL:URL resolvingAgainstBaseURL:YES];
    URLComponents.query = @"uri=login:basicauth";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URLComponents.URL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:self.timeout];
    request.HTTPMethod = @"POST";
    
    CAASServiceOperationGet *signInOp = [[CAASServiceOperationGet alloc] initWithService:self request:request];

    CAASServiceOperationGet __weak *weakOperation = signInOp;
    
    [signInOp setCompletionBlock:^{
        NSError *error = weakOperation.error;
        NSInteger httpStatusCode = weakOperation.httpStatusCode;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error == nil && [CAASUtils isHTTPStatusCodeOK:httpStatusCode]){
                [[NSNotificationCenter defaultCenter] postNotificationName:CAASDidSignIn object:self];
            }
            completionHandler(error,httpStatusCode);
        });
    }];
    
    [self.caasQueue cancelAllOperations];
    
    [self.caasQueue addOperation:signInOp];
    
    return signInOp;
}


- (void) writeCredential: (NSString *) user password: (NSString *) password
{
    
    NSURLCredential *credential = [NSURLCredential credentialWithUser:user password:password persistence:NSURLCredentialPersistencePermanent];
    [[NSURLCredentialStorage sharedCredentialStorage] setCredential:credential forProtectionSpace:self.loginProtectionSpace];
    
}

- (void) removeCredential
{
    self.user = nil;
    self.password = nil;
    
    NSURLCredential *credential;
    
    NSDictionary *credentials = [[NSURLCredentialStorage sharedCredentialStorage] credentialsForProtectionSpace:self.loginProtectionSpace];

    if (credentials == nil)
        return;
    
    credential = [credentials.objectEnumerator nextObject];
    [[NSURLCredentialStorage sharedCredentialStorage] removeCredential:credential forProtectionSpace:self.loginProtectionSpace];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler
{
    
    // If previous challenge failed, reject the handshake
    if ([challenge previousFailureCount] > 0) {
        completionHandler(NSURLSessionAuthChallengeRejectProtectionSpace,nil);
        return;
    }
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodHTTPBasic]){
        // For Basic Authentication
        
        NSURLCredential *credential = [NSURLCredential
                                       credentialWithUser:self.user
                                       password:self.password
                                       persistence:NSURLCredentialPersistenceNone];
        completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
        return;
    }
    
    completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge,nil);
    
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler
{
    // If previous challenge failed, reject the handshake
    if ([challenge previousFailureCount] > 0) {
        completionHandler(NSURLSessionAuthChallengeRejectProtectionSpace,nil);
        return;
    }
    
    // SSL handshake
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]){
        SecTrustRef trustRef = challenge.protectionSpace.serverTrust;
        SecTrustResultType result;
        OSStatus status = SecTrustEvaluate(trustRef,&result);
        if (status == errSecSuccess){
            if (result == kSecTrustResultUnspecified || result == kSecTrustResultProceed){
                NSURLCredential * newCredential = [NSURLCredential credentialForTrust:trustRef];
                completionHandler(NSURLSessionAuthChallengeUseCredential,newCredential);
                return;
            }
#ifdef DEBUG
            
            if (self.allowUntrustedCertificates &&
                result == kSecTrustResultRecoverableTrustFailure){
                NSURLCredential * newCredential = [NSURLCredential credentialForTrust:trustRef];
                completionHandler(NSURLSessionAuthChallengeUseCredential,newCredential);
                return;
            }
#endif
            [[challenge sender] cancelAuthenticationChallenge:challenge];
        }
        completionHandler(NSURLSessionAuthChallengeRejectProtectionSpace,nil);
        return;
    }
    
    completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge,nil);
    
}

- (CAASServiceOperation *) performRequest: (NSURL *) url completionHandler:(CAASContentCompletionHandler) completionHandler

{
    
    NSURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:self.timeout];
    
    CAASServiceOperationGet *getOperation = [[CAASServiceOperationGet alloc] initWithService:self request:request];
    
    CAASServiceOperationGet __weak *weakOperation = getOperation;
    
    [getOperation setCompletionBlock:^{
        NSError *error = weakOperation.error;
        NSInteger httpStatusCode = weakOperation.httpStatusCode;
        NSData *data = weakOperation.data;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error != nil)
                completionHandler(error,0,nil);
            else {
                if ([CAASUtils isHTTPStatusCodeOK:httpStatusCode] && data.length > 0){
                    NSError *jsonError;
                    id json =[NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                    completionHandler(jsonError,httpStatusCode,json);
                    return;
                }
                completionHandler(nil,httpStatusCode,nil);
                
            }
        });
    }];
    
    
    return getOperation;

    
}

- (CAASServiceOperation *) performDownloadRequest: (NSURL *) url completionHandler:(CAASContentDownloadCompletionHandler) completionHandler

{
    
    NSURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:self.timeout];
    
    CAASServiceOperationDownload *downloadOperation = [[CAASServiceOperationDownload alloc] initWithService:self request:request];
    
    CAASServiceOperationDownload __weak *weakOperation = downloadOperation;
    
    [downloadOperation setCompletionBlock:^{
        NSError *error = weakOperation.error;
        NSInteger httpStatusCode = weakOperation.httpStatusCode;
        NSData *data = weakOperation.data;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error != nil)
                completionHandler(error,httpStatusCode,nil);
            else {
                if ([CAASUtils isHTTPStatusCodeOK:httpStatusCode] && data.length > 0){
                    NSError *jsonError;
                    completionHandler(jsonError,httpStatusCode,data);
                    return;
                }
                completionHandler(nil,httpStatusCode,nil);
                
            }
        });
    }];
    
    return downloadOperation;
    
    
}


- (CAASRequestResult *) executeRequest: (CAASRequest *) caasRequest
{
    return [caasRequest execute:self];
}


- (void) addGeolocationsation: (NSMutableDictionary *) params {
    
    CLLocationCoordinate2D coordinate = self.locationManager.location.coordinate;
    
    params[@"wp_ct_latitude"] = @(coordinate.latitude).stringValue;
    params[@"wp_ct_longitude"] = @(coordinate.longitude).stringValue;
    
 
}

+ (NSString *) userAgent {
    
    
    static NSString *userAgent = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        userAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    });
    
    return userAgent;

}

// see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.4
+ (NSString *) acceptLanguage {
    
    NSArray *preferredLanguages = [NSLocale preferredLanguages];
    NSMutableArray *components = [NSMutableArray new];
    NSUInteger count = MIN(3, preferredLanguages.count);
    for (NSUInteger index = 0; index < count; index++) {
        double q = 1.0 - (index * 0.2);
        NSString *preferredLanguage = preferredLanguages[index];
        NSString *component = [NSString stringWithFormat:@"%@;q=\%.1f",preferredLanguage,q];
        [components addObject:component];
    }
    
    NSString *acceptLanguage = [components componentsJoinedByString:@", "];
    
    return acceptLanguage;
}

- (NSDictionary *) defaultHTTPHeaders
{
    
    NSDictionary *headers = @{
                              @"User-Agent" : [self.class userAgent],
                              @"Accept-Language" : [self.class acceptLanguage]
                              };
    
    return headers;
}

@end
