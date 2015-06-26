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

/**
  A CAASRequest instance represents an asynchronous request performed against an MACM server
 */
@interface CAASRequest : NSObject

/**
 Add a user defined key/param to the context
 @param parameter the name of the parameter to add
 @param value The value correponding to the given parameter
 */
- (void) addParameter:(NSString *) parameter value:(NSString *) value;

/**
 Returns the value of a specified parameter.
 @param parameter The name of the parameter
 @return The value corresponding to the given parameter.
 */
- (NSString *) valueForParameter:(NSString *) parameter;

/**
 If true, the latitude/longitude of the device will be sent to the MACM server
 */
@property (nonatomic,assign,getter=isGeolocalized) BOOL geolocalized;

@end

NS_ASSUME_NONNULL_END