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
#import "CAASContentItem.h"

NS_ASSUME_NONNULL_BEGIN

@class CAASContentItemsResult;

/**
 Definition of the completion block to be executed when a CAASContentItemsRequest is completed
 */

typedef void (^CAASContentItemsCompletionBlock)(CAASContentItemsResult *requestResult);


/**
 A CAASContentItemsRequest instance represents a request to get a list of content items
 */

@interface CAASContentItemsRequest : CAASRequest

/**
 Designated initializer of a CAASContentItemRequest
 @param oid the object id of the content item
 @param completionBlock the block to be executed when the request completes
 */

- (instancetype) initWithOid:(NSString *) oid completionBlock:(CAASContentItemsCompletionBlock) completionBlock;

/**
 @param contentPath path of the content items
 @param completionBlock block to be executed when the request is completed
 
 @return the newly-created CAASContentItemsRequest instance
 */

- (instancetype) initWithContentPath:(NSString *) contentPath completionBlock:(CAASContentItemsCompletionBlock) completionBlock;

/**
 A block object to be executed when the request is completed
 */
@property (nonatomic, copy, readonly) CAASContentItemsCompletionBlock completionBlock;


/**
 Object ID of the content items
 */
@property (nonatomic,strong,readonly,nullable) NSString *oid;

/**
 Path of the content items
 */
@property (nonatomic,strong,readonly,nullable) NSString *contentPath;

/**
 An array of sort descriptor objects
 */
@property (nonatomic, strong,nullable) NSArray *sortDescriptors;

/**
 Page number of the request
 */
@property (nonatomic) NSInteger pageNumber;

/**
 Size of the page of the request
 */
@property (nonatomic) NSInteger pageSize;

/**
 Specifies a collection of elements names that should be fetched. If this collection is empty, all properties will be retrieved
 */
@property (nonatomic, strong,nullable) NSArray *elements;

/**
 Specifies a collection of property names that should be fetched. If this collection is empty, all properties will be retrieved
 */
@property (nonatomic, strong,nullable) NSArray *properties;

/**
 Content item must be in the given workflow status. Support workflow status values are "Published", "Draft", "Expired", and "Deleted"
 */
@property (nonatomic) CAASContentItemWorkflowStatus workflowStatus;

/**
 content must have all of the given keywords
 */
@property (nonatomic,strong,nullable) NSArray *allKeywords;

/**
 content must have at least one of the given keywords
 */
@property (nonatomic,strong,nullable) NSArray *anyKeywords;

/**
 list of categories. content must have all the given categories
 */
@property (nonatomic,strong,nullable) NSArray *allCategories;

/**
 list of categories. content must have at least one of the given categories
 */
@property (nonatomic,strong,nullable) NSArray *anyCategories;

/**
 Content title must contain the given string
 */
@property (nonatomic,strong,nullable) NSString *titleContains;


/**
 Sets/Returns a specific project name. Setting the project name allows to retrieve data for draft content.
 */
@property (nonatomic,strong,nullable) NSString *projectName;

@end

NS_ASSUME_NONNULL_END