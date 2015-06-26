//
//  CAASContentItemsResult.h
//  CAASObjC
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

@interface CAASContentItemsResult : CAASRequestResult

/**
 The object id of the list of content items
 */
@property (readonly,nullable) NSString *oid;

/**
 The content items of the list
 */
@property (readonly,nullable) NSArray *contentItems;

/**
 Returns `true` when there are more page after this page
 */
@property (readonly) BOOL morePages;

/**
 Returns the page number of this list
 */
@property (readonly) NSInteger pageNumber;

@end

NS_ASSUME_NONNULL_END
