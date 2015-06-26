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
@import CoreLocation;

#import "CAASServiceOperation.h"

#pragma clang assume_nonnull begin

FOUNDATION_EXPORT NSString * const kCAASSignIn;
FOUNDATION_EXPORT NSString * const kCAASSContent;

typedef void (^CAASContentCompletionHandler)(NSError * __nullable error,NSInteger httpStatusCode, NSDictionary * __nullable json);


typedef void (^CAASContentDownloadCompletionHandler)(NSError * __nullable error,NSInteger httpStatusCode, NSData * __nullable data);



@interface CAASService() <NSURLSessionDelegate, NSURLSessionTaskDelegate>

@property (nonatomic,strong) NSURLProtectionSpace *loginProtectionSpace;
@property (nonatomic,strong,readwrite) NSURL *baseURL;
@property (nonatomic,strong,readwrite) NSString *contextRoot;
@property (nonatomic,strong,readwrite) NSString * __nullable tenant;
@property (nonatomic,strong) NSString * __nullable user;
@property (nonatomic,strong) NSString * __nullable password;

@property (nonatomic,strong) NSOperationQueue *caasQueue;

@property (nonatomic,strong,readwrite) NSURLSession *caasSession;

@property (nonatomic,strong) CLLocationManager *locationManager;

- (NSURLSession *) caasSession;

- (void) writeCredential: (NSString *) user password: (NSString *) password;

- (CAASServiceOperation *) performRequest: (NSURL *) url completionHandler:(CAASContentCompletionHandler) completionHandler;

- (CAASServiceOperation *) performDownloadRequest: (NSURL *) url completionHandler:(CAASContentDownloadCompletionHandler) completionHandler;

- (void) addGeolocationsation: (NSMutableDictionary *) params;

@end

#pragma clang assume_nonnull end

