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


#import <CAASObjC/CAASObjC.h>

NS_ASSUME_NONNULL_BEGIN

@class CAASAssetResult;

/**
 Definition of the completion block to be executed when a CAASAssetRequest is completed
 */

typedef void (^CAASAssetCompletionBlock)(CAASAssetResult *requestResult);

/**
 A CAASAssetRequest instance represents a request to get an asset from a MACM instance
 */
@interface CAASAssetRequest : CAASRequest

/**
 @param assetURL URL of the asset to be downloaded
 @param completionBlock block to be executed when the request is completed
 
 @return the newly-created CAASAssetRequest instance
 */
- (instancetype) initWithAssetURL:(NSURL *) assetURL completionBlock:(CAASAssetCompletionBlock) completionBlock;

/**
 The URL of the asset to be downloaded by this request
 */
@property (nonatomic,copy,readonly) NSURL *assetURL;

/**
 block of code that will be performed when this request is completed
 */
@property (nonatomic, copy, readonly) CAASAssetCompletionBlock completionBlock;

@end

NS_ASSUME_NONNULL_END
