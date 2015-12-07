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

/**
 * This class provides the names of the properties supported
 * for content items and project items.
 * 
 * Content items support the following properties:
 * <ul>
 * <li>#OID</li>
 * <li>#NAME</li>
 * <li>#AUTHORS</li>
 * <li>#TITLE</li>
 * <li>#AUTH_TEMPLATE_ID</li>
 * <li>#AUTH_TEMPLATE_NAME</li>
 * <li>#AUTH_TEMPLATE_TITLE</li>
 * <li>#CATEGORIES</li>
 * <li>#CONTENT_TYPE</li>
 * <li>#CREATION_DATE</li>
 * <li>#CREATOR</li>
 * <li>#CURRENT_STAGE</li>
 * <li>#DESCRIPTION</li>
 * <li>#EXPIRY_DATE</li>
 * <li>#KEYWORDS</li>
 * <li>#LAST_MODIFIED_DATE</li>
 * <li>#LAST_MODIFIER</li>
 * <li>#LIBRARY_ID</li>
 * <li>#LIBRARY_NAME</li>
 * <li>#LIBRARY_TITLE</li>
 * <li>#PARENT_ID</li>
 * <li>#PARENT_NAME</li>
 * <li>#PARENT_TITLE</li>
 * <li>#PROJECT_ID</li>
 * <li>#PROJECT_NAME</li>
 * <li>#PROJECT_TITLE</li>
 * <li>#PUBLISH_DATE</li>
 * <li>#STATUS</li>
 * <li>#STATUS_ID</li>
 * </ul>
 * <p>Project items support the following properties:
 * <ul>
 * <li>#NAME</li>
 * <li>#TITLE</li>
 * <li>#CREATION_DATE</li>
 * <li>#CREATOR</li>
 * <li>#ITEM_COUNT</li>
 * <li>#LAST_MODIFIER</li>
 * <li>#STATE</li>
 * <li>#UUID</li>
 * </ul>
 */

NS_ASSUME_NONNULL_BEGIN

@interface CAASProperty : NSObject

+ (NSString *) OID;

+ (NSString *) NAME;

+ (NSString *) AUTHORS;

+ (NSString *) TITLE;

+ (NSString *) AUTH_TEMPLATE_ID;

+ (NSString *) AUTH_TEMPLATE_NAME;

+ (NSString *) AUTH_TEMPLATE_TITLE;

+ (NSString *) CATEGORIES;

+ (NSString *) CONTENT_TYPE;

+ (NSString *) CREATION_DATE;

+ (NSString *) CREATOR;

+ (NSString *) CURRENT_STAGE;

+ (NSString *) DESCRIPTION;

+ (NSString *) EXPIRY_DATE;

+ (NSString *) ITEM_COUNT;

+ (NSString *) KEYWORDS;

+ (NSString *) LAST_MODIFIED_DATE;

+ (NSString *) LAST_MODIFIER;

+ (NSString *) LIBRARY_ID;

+ (NSString *) LIBRARY_NAME;

+ (NSString *) LIBRARY_TITLE;

+ (NSString *) PARENT_ID;

+ (NSString *) PARENT_NAME;

+ (NSString *) PARENT_TITLE;

+ (NSString *) PROJECT_ID;

+ (NSString *) PROJECT_NAME;

+ (NSString *) PROJECT_TITLE;

+ (NSString *) PUBLISH_DATE;

+ (NSString *) STATUS;

+ (NSString *) STATUS_ID;

+ (NSString *) STATE;

+ (NSString *) UUID;

@end

NS_ASSUME_NONNULL_END

