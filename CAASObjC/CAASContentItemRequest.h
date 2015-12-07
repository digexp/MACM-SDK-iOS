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

#import "CAASRequest.h"

NS_ASSUME_NONNULL_BEGIN

@class CAASContentItemResult;

/**
 Definition of the completion block to be executed when a CAASContentItemRequest is completed
 */

typedef void (^CAASContentItemCompletionBlock)(CAASContentItemResult *requestResult);

/**
 A CAASRequest instance retrieves a content item that matches a given object id
 */
@interface CAASContentItemRequest : CAASRequest

/**
 Designated initializer of a CAASContentItemRequest
 @param oid the object id of the content item
 @param completionBlock the block to be executed when the request completes
 */

- (instancetype) initWithOid:(NSString *) oid completionBlock:(CAASContentItemCompletionBlock) completionBlock;

/**
 Designated initializer of a CAASContentItemRequest
 @param contentPath the object path of the content item
 @param completionBlock the block to be executed when the request completes
 */

- (instancetype) initWithContentPath:(NSString *) contentPath completionBlock:(CAASContentItemCompletionBlock) completionBlock;

/**
 A block object to be executed when the request is completed
 */
@property (nonatomic, copy, readonly) CAASContentItemCompletionBlock completionBlock;


/// The object id of the content item
@property (nonatomic,strong,readonly,nullable) NSString * oid;

/**
 Path of the content item
 @see http://www-01.ibm.com/support/knowledgecenter/SSYK7J_8.5.0/macm/macm_rest_api_sys_cont_items.dita
 */
@property (nonatomic,strong,readonly,nullable) NSString * contentPath;

/**
 Specifies a collection of element names that should be fetched. If this collection is empty, all properties will be retrieved
 */
@property (nonatomic, strong,nullable) NSArray<NSString *> * elements;

/**
 Specifies a collection of property names that should be fetched. If this collection is empty, all properties will be retrieved
 * See also: #CAASProperty.
 */
@property (nonatomic, strong,nullable) NSArray<NSString *> * properties;

/**
 Sets/Returns a specific project name. Setting the project name allows to retrieve data for draft content.
 */
@property (nonatomic,strong,nullable) NSString *projectName;

@end

NS_ASSUME_NONNULL_END