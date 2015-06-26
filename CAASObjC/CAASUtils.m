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

#import "CAASUtils.h"

#import <sys/utsname.h>

@import UIKit;

@implementation CAASUtils

+ (NSString *)buildQueryStringWithParams:(NSDictionary *)params
{
    
    NSMutableArray *mutablePairs = [NSMutableArray array];
    for (NSString *key in params){
        NSString *param = [NSString stringWithFormat:@"%@=%@",key,[self escape:params[key]]];
        [mutablePairs addObject:param];
    }
    NSString *queryString = [mutablePairs componentsJoinedByString:@"&"];
    
    return queryString;
}


+ (NSString *)escape:(NSString *)string {
    
    static NSString * const toBeEscaped = @":&=;+!@#$()',*";
    
    return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                 (__bridge CFStringRef)string,
                                                                                 NULL,                        // charactersToLeaveUnescaped
                                                                                 (__bridge CFStringRef)toBeEscaped,  // legalURLCharactersToBeEscaped
                                                                                 kCFStringEncodingUTF8);

}

+ (NSString *)escapePath:(NSString *)string {
    
    static NSString * const toBeEscaped = @":/?&=;+!@#$()',*"; 
    
    return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                 (__bridge CFStringRef)string,
                                                                                 NULL,                        // charactersToLeaveUnescaped
                                                                                 (__bridge CFStringRef)toBeEscaped,  // legalURLCharactersToBeEscaped
                                                                                 kCFStringEncodingUTF8);
    
}


+ (NSDictionary *) queryParamsContext
{
    NSMutableDictionary *context = [NSMutableDictionary new];
    
    context[@"ibm.mobile.machineName"] = [self machineName];
    context[@"ibm.mobile.systemVersion"] = [self systemVersion];
    context[@"ibm.mobile.locale"] = [[NSLocale currentLocale] localeIdentifier];
    context[@"ibm.mobile.scale"] = @([UIScreen mainScreen].scale).stringValue;
    context[@"ibm.mobile.os"] = @"iOS";
    
    return context;
}

+ (NSString *) machineName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}

+ (NSString *) systemVersion
{
    return [UIDevice currentDevice].systemVersion;
    
}

+ (BOOL) isHTTPStatusCodeOK:(NSInteger)statusCode
{
    return statusCode >= 200  && statusCode < 300;
}

+ (NSDateFormatter *)createISO8601DateFormatter
{
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [df setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'"];
    
    return df;
}

@end
