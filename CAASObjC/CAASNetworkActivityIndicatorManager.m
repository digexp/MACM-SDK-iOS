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

#import "CAASNetworkActivityIndicatorManager.h"
#import "CAASService.h"

@interface CAASNetworkActivityIndicatorManager()

@property (nonatomic, assign) NSInteger activityCount;

@end

@implementation CAASNetworkActivityIndicatorManager

+ (CAASNetworkActivityIndicatorManager *)sharedInstance {
    
    static CAASNetworkActivityIndicatorManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [CAASNetworkActivityIndicatorManager new];
    });
    
    return _sharedInstance;
}

- (instancetype) init {
    self = [super init];
    if (self){
        
    }
    return self;
}

- (void) setEnabled:(BOOL)enabled {
    _enabled = enabled;
    if (_enabled){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didStartRequest:) name:CAASDidStartRequest object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEndRequest:) name:CAASDidEndRequest object:nil];
        
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self resetNetworkActivity];
    }
}

- (void) didStartRequest:(NSNotification *)notification {
    @synchronized(self) {
        _activityCount++;
    }
    [self refreshNetworkActivityIndicator];
    
}

- (void) didEndRequest:(NSNotification *)notification {
    @synchronized(self) {
        _activityCount--;
    }
    [self refreshNetworkActivityIndicator];
}

- (void) refreshNetworkActivityIndicator {
    
    if (![UIApplication sharedApplication].applicationState == UIApplicationStateActive)
        return;
    
    if (![NSThread isMainThread]) {
        SEL sel_refresh = @selector(refreshNetworkActivityIndicator);
        [self performSelectorOnMainThread:sel_refresh
                               withObject:nil
                            waitUntilDone:NO];
        return;
    }
    
    BOOL active = (self.activityCount > 0);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = active;
    
}

- (void)resetNetworkActivity {
    @synchronized(self) {
        _activityCount = 0;
    }
    
    [self refreshNetworkActivityIndicator];
}


@end
