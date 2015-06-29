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


#import "CAASContentItemsResult.h"
#import "CAASRequestResultPrivate.h"

@interface CAASContentItemsResult()

@end

@implementation CAASContentItemsResult

- (NSArray<CAASContentItem *> *) contentItems {
    
    NSDictionary *json = self.json;
    
    return json[@"contentItems"];
}

- (BOOL) morePages {
    
    NSDictionary *json = self.json;
    
    NSDictionary *listProperties = json[@"listProperties"];
    
    if (listProperties != nil) {
        BOOL hasNext = [listProperties[@"hasNext"] boolValue];
        return hasNext;
    }
    
    return NO;
}

- (NSInteger) pageNumber {
    
    NSDictionary *json = self.json;
    
    NSDictionary *listProperties = json[@"listProperties"];
    
    if (listProperties != nil) {
        NSInteger pageNumber = [listProperties[@"pageNumber"] integerValue];
        return pageNumber;
    }
    
    return 0;
}

- (NSString *) oid {
    
    NSDictionary *json = self.json;
    
    NSDictionary *listProperties = json[@"listProperties"];
    
    if (listProperties != nil) {
        NSString *oid = listProperties[@"id"];
        return oid;
    }
                         
    return nil;
    
}



@end
