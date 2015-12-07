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

#import "CAASProperty.h"

@implementation CAASProperty

+ (NSString *) OID {
    static NSString * _OID = @"id";
    
    return _OID;
}

+ (NSString *) NAME {
    static NSString * _NAME = @"name";
    
    return _NAME;
    
}

+ (NSString *) AUTHORS {
    static NSString * _AUTHORS = @"authors";
    
    return _AUTHORS;
    
}

+ (NSString *) TITLE {
    static NSString * _TITLE = @"title";
    
    return _TITLE;
    
}

+ (NSString *) AUTH_TEMPLATE_ID {
    static NSString * _AUTH_TEMPLATE_ID = @"authtemplateid";
    
    return _AUTH_TEMPLATE_ID;
    
}

+ (NSString *) AUTH_TEMPLATE_NAME {
    static NSString * _AUTH_TEMPLATE_NAME = @"authtemplatename";
    
    return _AUTH_TEMPLATE_NAME;
    
}

+ (NSString *) AUTH_TEMPLATE_TITLE {
    static NSString * _AUTH_TEMPLATE_TITLE = @"authtemplatetitle";
    
    return _AUTH_TEMPLATE_TITLE;
    
}

+ (NSString *) CATEGORIES {
    static NSString * _CATEGORIES = @"categories";
    
    return _CATEGORIES;
    
}

+ (NSString *) CONTENT_TYPE {
    static NSString * _CONTENT_TYPE = @"contenttype";
    
    return _CONTENT_TYPE;
    
}

+ (NSString *) CREATION_DATE {
    static NSString * _CREATION_DATE = @"creationdate";
    
    return _CREATION_DATE;
    
}

+ (NSString *) CREATOR {
    static NSString * _CREATOR = @"creator";
    
    return _CREATOR;
    
}

+ (NSString *) CURRENT_STAGE {
    static NSString * _CURRENT_STAGE = @"currentstage";
    
    return _CURRENT_STAGE;
    
}

+ (NSString *) DESCRIPTION {
    static NSString * _DESCRIPTION = @"description";
    
    return _DESCRIPTION;
    
}

+ (NSString *) EXPIRY_DATE {
    static NSString * _EXPIRY_DATE = @"expirydate";
    
    return _EXPIRY_DATE;
    
}

+ (NSString *) ITEM_COUNT {
    static NSString * _ITEM_COUNT = @"itemcount";
    
    return _ITEM_COUNT;
    
}

+ (NSString *) KEYWORDS {
    static NSString * _KEYWORDS = @"keywords";
    
    return _KEYWORDS;
    
}

+ (NSString *) LAST_MODIFIED_DATE {
    static NSString * _LAST_MODIFIED_DATE = @"lastmodifieddate";
    
    return _LAST_MODIFIED_DATE;
    
}

+ (NSString *) LAST_MODIFIER {
    static NSString * _LAST_MODIFIER = @"lastmodifier";
    
    return _LAST_MODIFIER;
    
}

+ (NSString *) LIBRARY_ID {
    static NSString * _LIBRARY_ID = @"libraryid";
    
    return _LIBRARY_ID;
    
}

+ (NSString *) LIBRARY_NAME {
    static NSString * _LIBRARY_NAME = @"libraryname";
    
    return _LIBRARY_NAME;
    
}

+ (NSString *) LIBRARY_TITLE {
    static NSString * _LIBRARY_TITLE = @"librarytitle";
    
    return _LIBRARY_TITLE;
    
}

+ (NSString *) PARENT_ID {
    static NSString * _PARENT_ID = @"parentid";
    
    return _PARENT_ID;
    
}

+ (NSString *) PARENT_NAME {
    static NSString * _PARENT_ID = @"parentname";
    
    return _PARENT_ID;
    
}

+ (NSString *) PARENT_TITLE {
    static NSString * _PARENT_TITLE = @"parenttitle";
    
    return _PARENT_TITLE;
    
}

+ (NSString *) PROJECT_ID {
    static NSString * _PROJECT_ID = @"projectid";
    
    return _PROJECT_ID;
    
}

+ (NSString *) PROJECT_NAME {
    static NSString * _PROJECT_NAME = @"projectname";
    
    return _PROJECT_NAME;
    
}

+ (NSString *) PROJECT_TITLE {
    static NSString * _PROJECT_TITLE = @"projecttitle";
    
    return _PROJECT_TITLE;
    
}

+ (NSString *) PUBLISH_DATE {
    static NSString * _PUBLISH_DATE = @"publishdate";
    
    return _PUBLISH_DATE;
    
}

+ (NSString *) STATUS {
    static NSString * _STATUS = @"status";
    
    return _STATUS;
    
}

+ (NSString *) STATUS_ID {
    static NSString * _STATUS_ID = @"statusid";
    
    return _STATUS_ID;
    
}

+ (NSString *) STATE {
    static NSString * _STATE = @"state";
    
    return _STATE;
    
}

+ (NSString *) UUID {
    static NSString * _UUID = @"uuid";
    
    return _UUID;
    
}


@end
