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

#import "CAASContentItem.h"
#import "CAASContentItemPrivate.h"
#import "CAASUtils.h"
#import "CAASProperty.h"

@implementation CAASContentItem

- (instancetype) initWithContentItem:(NSDictionary *) contentItem baseURL:(NSURL *) baseURL
{
    
    return [self initWithContentItem:contentItem itemIndex:0 baseURL:baseURL];
}

- (instancetype) initWithContentItem:(NSDictionary *) contentItem itemIndex:(NSInteger)itemIndex baseURL:(NSURL *) baseURL
{
    self = [super init];
    if (self){
        NSDictionary *header = contentItem[@"header"];
        NSDictionary *propertyIndex = header[@"propertyIndex"];
        NSDictionary *elementIndex = header[@"elementIndex"];
        NSDictionary *elementTypeIndex = header[@"elementTypeIndex"];
        NSArray *allvalues = contentItem[@"values"];
        
        NSArray *values = allvalues[itemIndex];
        NSMutableDictionary *properties = [NSMutableDictionary new];
        NSPredicate *predicateDates = [NSPredicate predicateWithFormat:@"self in %@",@[@"creationdate",@"expirydate",@"lastmodifieddate",@"publishdate"]];
        for (NSString *propertyName in propertyIndex) {
            NSInteger index = [propertyIndex[propertyName] integerValue];
            
            if ([predicateDates evaluateWithObject:propertyName]){
                properties[propertyName] = [[self iso8601dateFormatter] dateFromString:values[index]];
            } else {
                properties[propertyName] = values[index];
            }
        }
        self.properties = properties;
        
        NSMutableDictionary *elements = [NSMutableDictionary new];
        if (elementIndex != nil){
            for (NSString *propertyName in elementIndex) {
                CAASTypeInformation type = CAASTypeInformationText;
                if (elementTypeIndex != nil){
                    NSInteger typeIndex = [elementTypeIndex[propertyName] integerValue];
                    type = [values[typeIndex] integerValue];
                }
                NSInteger index = [elementIndex[propertyName] integerValue];
                if (values[index] == [NSNull null])
                    continue;
                switch (type) {
                    case CAASTypeInformationNone:
                        break;
                    case CAASTypeInformationText:
                    case CAASTypeInformationHTML:
                        elements[propertyName] = values[index];
                        break;
                    case CAASTypeInformationURL:
                    {
                        NSString *urlString = values[index];
                        // test absolute URL
                        if ([urlString hasPrefix:@"http:"] || [urlString hasPrefix:@"https:"]){
                            elements[propertyName] = [NSURL URLWithString:urlString];
                        } else {
                            elements[propertyName] = [NSURL URLWithString:urlString relativeToURL:baseURL];
                        }
                    }
                        break;
                    case CAASTypeInformationDate:
                        elements[propertyName] = [[self iso8601dateFormatter] dateFromString:values[index]];
                        break;
                    case CAASTypeInformationNumber:
                        elements[propertyName] = @([values[index] floatValue]);
                        break;
                }
            }
        }
        self.elements = elements;
        
        
    }
    
    return self;
}


- (NSString *) oid {
    
    return self.properties[CAASProperty.OID];
    
}

- (NSString *) name {
    
    return self.properties[CAASProperty.NAME];
    
}

- (NSString *) title {
    
    return self.properties[CAASProperty.TITLE];
    
}

- (NSString *) contentType {
    
    return self.properties[CAASProperty.CONTENT_TYPE];
    
}

- (NSString *) authors {
    
    return self.properties[CAASProperty.AUTHORS];
    
}

- (NSString *) authTemplateId {
    
    return self.properties[CAASProperty.AUTH_TEMPLATE_ID];
    
}

- (NSString *) authTemplateName {
    
    return self.properties[CAASProperty.AUTH_TEMPLATE_NAME];
    
}

- (NSString *) authTemplateTitle {
    
    return self.properties[CAASProperty.AUTH_TEMPLATE_TITLE];
    
}

- (NSArray<NSString *> *) keywords {
    
    NSString *allkeywords = self.properties[CAASProperty.KEYWORDS];
    
    if (allkeywords != nil){
        NSArray *keywords = [allkeywords componentsSeparatedByString:@","];
        return keywords;
    }
    
    return nil;
}

- (NSArray<NSString *> *) categories {
    
    NSString *allkeywords = self.properties[CAASProperty.CATEGORIES];
    
    if (allkeywords != nil){
        NSArray *keywords = [allkeywords componentsSeparatedByString:@","];
        return keywords;
    }
    
    return nil;
}

- (NSDate *) lastmodifiedDate {
    
    NSString *lastmodifieddate = self.properties[CAASProperty.LAST_MODIFIED_DATE];
    
    if (lastmodifieddate != nil){
        NSTimeInterval timestamp = [lastmodifieddate doubleValue];
        NSDate *d = [NSDate dateWithTimeIntervalSince1970:timestamp / 1000];
        return d;
    }
    
    return nil;
    
}

- (NSDate *) creationDate {
    
    NSString *creationdate = self.properties[CAASProperty.CREATION_DATE];
    
    if (creationdate != nil){
        NSTimeInterval timestamp = [creationdate doubleValue];
        NSDate *d = [NSDate dateWithTimeIntervalSince1970:timestamp / 1000];
        return d;
    }
    
    return nil;
    
}

- (NSDate *) expiryDate {
    
    NSString *expiryDate = self.properties[CAASProperty.EXPIRY_DATE];
    
    if (expiryDate != nil){
        NSTimeInterval timestamp = [expiryDate doubleValue];
        NSDate *d = [NSDate dateWithTimeIntervalSince1970:timestamp / 1000];
        return d;
    }
    
    return nil;
    
}

- (NSDate *) publishDate {
    
    NSString *publishDate = self.properties[CAASProperty.PUBLISH_DATE];
    
    if (publishDate != nil){
        NSTimeInterval timestamp = [publishDate doubleValue];
        NSDate *d = [NSDate dateWithTimeIntervalSince1970:timestamp / 1000];
        return d;
    }
    
    return nil;
    
}

- (NSString *) creator {
    
    return self.properties[CAASProperty.CREATOR];
    
}


- (NSString *) currentStage {
    
    return self.properties[CAASProperty.CURRENT_STAGE];
    
}


- (NSString *) contentItemDescription {
    
    return self.properties[CAASProperty.DESCRIPTION];
    
}


- (NSString *) lastModifier {
    
    return self.properties[CAASProperty.LAST_MODIFIER];
    
}

- (NSString *) libraryId {
    
    return self.properties[CAASProperty.LIBRARY_ID];
    
}


- (NSString *) libraryName {
    
    return self.properties[CAASProperty.LIBRARY_NAME];
    
}

- (NSString *) libraryTitle {
    
    return self.properties[CAASProperty.LIBRARY_TITLE];
    
}

- (NSString *) parentId {
    
    return self.properties[CAASProperty.PARENT_ID];
    
}


- (NSString *) parentName {
    
    return self.properties[CAASProperty.PARENT_NAME];
    
}

- (NSString *) parentTitle {
    
    return self.properties[CAASProperty.PARENT_TITLE];
    
}

- (NSString *) status {
    
    return self.properties[CAASProperty.STATUS];
    
}

- (NSString *) statusId {
    
    return self.properties[CAASProperty.STATUS_ID];
    
}


- (NSString *) description {
    
    NSMutableString *des = [NSMutableString new];
    [des appendString:@"properties\r"];
    for (NSString *key in self.properties){
        [des appendString:[NSString stringWithFormat:@"%@ = %@\r",key,self.properties[key]]];
    }
    [des appendString:@"elements\r"];
    for (NSString *key in self.elements){
        [des appendString:[NSString stringWithFormat:@"%@ = %@\r",key,self.elements[key]]];
    }
    return des;
}

- (NSDateFormatter *) iso8601dateFormatter
{
    
    static NSDateFormatter *_dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dateFormatter = [CAASUtils createISO8601DateFormatter];
    });
    
    return _dateFormatter;
    
}

- (NSNumberFormatter *) numberFormatter
{
    static NSNumberFormatter *_numberFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _numberFormatter = [NSNumberFormatter new];
        _numberFormatter.decimalSeparator = @".";
    });
    
    return _numberFormatter;
    
}




@end
