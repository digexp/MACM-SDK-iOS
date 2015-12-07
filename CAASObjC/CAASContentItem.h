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
 * Return this content item's name
 */
@property (nonatomic,readonly,strong,nullable) NSString *name;

/**
 * Return this content item's "contenttype" property
 */
@property (nonatomic,readonly,strong,nullable) NSString *contentType;

/**
 * Return this content item's "authors" property
 */
@property (nonatomic,readonly,strong,nullable) NSString *authors;

/**
 * Return this content item's "authTemplateId" property
 */
@property (nonatomic,readonly,strong,nullable) NSString *authTemplateId;

/**
 * Return this content item's "authTemplateName" property
 */
@property (nonatomic,readonly,strong,nullable) NSString *authTemplateName;

/**
* Return this content item's "authTemplateTitle" property
*/
@property (nonatomic,readonly,strong,nullable) NSString *authTemplateTitle;

/**
 The keywords of this content item
 */
@property (nonatomic,readonly,strong,nullable) NSArray<NSString *> *keywords;

/**
 The categories of this content item
 */
@property (nonatomic,readonly,strong,nullable) NSArray<NSString *> *categories;

/**
 The project name of this content item
 */
@property (nonatomic,readonly,strong,nullable) NSString *projectName;

/**
 The last modified date of this content item
 */
@property (nonatomic,readonly,strong,nullable) NSDate *lastmodifiedDate;

/**
 The last creation date of this content item
 */
@property (nonatomic,readonly,strong,nullable) NSDate *creationDate;

/**
 The expiry date of this content item
 */
@property (nonatomic,readonly,strong,nullable) NSDate *expiryDate;

/**
 The publish date of this content item
 */
@property (nonatomic,readonly,strong,nullable) NSDate *publishDate;

/**
 The creator of this content item
 */
@property (nonatomic,readonly,strong,nullable) NSString *creator;

/**
 The last modifier of this content item
 */
@property (nonatomic,readonly,strong,nullable) NSString *lastModifier;

/**
 The library id of this content item
 */
@property (nonatomic,readonly,strong,nullable) NSString *libraryId;

/**
 The library name of this content item
 */
@property (nonatomic,readonly,strong,nullable) NSString *libraryName;

/**
 The library title of this content item
 */
@property (nonatomic,readonly,strong,nullable) NSString *libraryTitle;

/**
 The parent id of this content item
 */
@property (nonatomic,readonly,strong,nullable) NSString *parentId;

/**
 The parent name of this content item
 */
@property (nonatomic,readonly,strong,nullable) NSString *parentName;

/**
 The parent title of this content item
 */
@property (nonatomic,readonly,strong,nullable) NSString *parentTitle;

/**
 The status of this content item
 */
@property (nonatomic,readonly,strong,nullable) NSString *status;

/**
 The status id of this content item
 */
@property (nonatomic,readonly,strong,nullable) NSString *statusId;

/**
 The current stage of this content item
 */
@property (nonatomic,readonly,strong,nullable) NSString *currentStage;

/**
 The description of this content item
 */
@property (nonatomic,readonly,strong,nullable) NSString *contentItemDescription;

/**
 All the elements of this content item
 */
@property (nonatomic,readonly,strong) NSDictionary<NSString *,id> *elements;

/**
 All the properties of this content item
 */
@property (nonatomic,readonly,strong) NSDictionary<NSString *,id> *properties;

@end

NS_ASSUME_NONNULL_END