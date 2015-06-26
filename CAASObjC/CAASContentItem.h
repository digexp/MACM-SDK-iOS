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

typedef NS_ENUM(NSInteger, CAASContentItemWorkflowStatus) {
    CAASContentItemWorkflowStatusNone,
    CAASContentItemWorkflowStatusPublished,
    CAASContentItemWorkflowStatusDraft,
    CAASContentItemWorkflowStatusExpired,
    CAASContentItemWorkflowStatusDeleted
};

/**
 A CAASContentItem instance represents a MACM/WCM content item
 */

@interface CAASContentItem : NSObject

/**
 The object id of this content item
 */
@property (nonatomic,readonly,strong) NSString *oid;

/**
 The title of the content item
 */
@property (nonatomic,readonly,strong,nullable) NSString *title;


/**
 The keywords of this content item
 */
@property (nonatomic,readonly,strong,nullable) NSArray *keywords;

/**
 The categories of this content item
 */
@property (nonatomic,readonly,strong,nullable) NSArray *categories;

/**
 The project name of this content item
 */
@property (nonatomic,readonly,strong,nullable) NSString *projectName;

/**
 The last modified date of this content item
 */
@property (nonatomic,readonly,strong,nullable) NSDate *lastmodifieddate;

/**
 All the elements of this content item
 */
@property (nonatomic,readonly,strong) NSDictionary *elements;

/**
 All the properties of this content item
 */
@property (nonatomic,readonly,strong) NSDictionary *properties;

@end

NS_ASSUME_NONNULL_END