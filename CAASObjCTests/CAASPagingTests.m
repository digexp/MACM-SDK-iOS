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

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "CAASTests.h"
#import "CAASService.h"
#import "CAASContentItemsRequest.h"
#import "CAASContentItemsResult.h"

@interface CAASPagingTests : XCTestCase

@property (nonatomic,strong) CAASService *caasService;

@end

@implementation CAASPagingTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.caasService = [[CAASService alloc] initWithBaseURL:[NSURL URLWithString:CAASURL] contextRoot:@"wps" tenant:nil username:@"wpsadmin" password:@"wpsadmin"];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testPageSize1 {
    // This is an example of a functional test case.
    
    XCTestExpectation *resultExpectation = [self expectationWithDescription:@"Received a not found error"];
    
    
    CAASContentItemsRequest *request = [[CAASContentItemsRequest alloc] initWithContentPath:wcmBookPath completionBlock:^(CAASContentItemsResult *requestResult) {
        
        [resultExpectation fulfill];
        
        XCTAssertNil(requestResult.error);
        XCTAssertEqual(requestResult.httpStatusCode,200);
        
        XCTAssertEqual(requestResult.contentItems.count,1);
        XCTAssertEqual(requestResult.pageNumber,1);
        XCTAssertEqual(requestResult.morePages,YES);
        
        
    }];
    
    request.pageSize = 1;
    [self.caasService executeRequest:request];
    
    [self waitForExpectationsWithTimeout:TIMEOUT handler:^(NSError *error) {
        XCTAssertNil(error, @"Didn't received the list %@",error);
    }];
}

- (void)testPageSize5 {
    // This is an example of a functional test case.
    
    XCTestExpectation *resultExpectation = [self expectationWithDescription:@"Received a not found error"];
    
    
    CAASContentItemsRequest *request = [[CAASContentItemsRequest alloc] initWithContentPath:wcmBookPath completionBlock:^(CAASContentItemsResult *requestResult) {
        
        [resultExpectation fulfill];
        
        XCTAssertNil(requestResult.error);
        XCTAssertEqual(requestResult.httpStatusCode,200);
        
        XCTAssertEqual(requestResult.contentItems.count,5);
        XCTAssertEqual(requestResult.pageNumber,1);
        XCTAssertEqual(requestResult.morePages,YES);
        
        
    }];
    
    request.pageSize = 5;
    [self.caasService executeRequest:request];
    
    [self waitForExpectationsWithTimeout:TIMEOUT handler:^(NSError *error) {
        XCTAssertNil(error, @"Didn't received the list %@",error);
    }];
}

- (void)testPageNumber100 {
    // This is an example of a functional test case.
    
    XCTestExpectation *resultExpectation = [self expectationWithDescription:@"Received a not found error"];
    
    
    CAASContentItemsRequest *request = [[CAASContentItemsRequest alloc] initWithContentPath:wcmBookPath completionBlock:^(CAASContentItemsResult *requestResult) {
        
        [resultExpectation fulfill];
        
        XCTAssertNil(requestResult.error);
        XCTAssertEqual(requestResult.httpStatusCode,200);
        
        XCTAssertEqual(requestResult.contentItems.count,0);
        XCTAssertEqual(requestResult.morePages,NO);
        
        
    }];
    
    request.pageSize = 100;
    request.pageNumber = 100;
    [self.caasService executeRequest:request];
    
    [self waitForExpectationsWithTimeout:TIMEOUT handler:^(NSError *error) {
        XCTAssertNil(error, @"Didn't received the list %@",error);
    }];
}

- (void)testPageNumberAndKeywords {
    // This is an example of a functional test case.
    
    XCTestExpectation *resultExpectation = [self expectationWithDescription:@"Received a not found error"];
    
    
    NSString * keyword1 = @"bestseller";
    CAASContentItemsRequest *request = [[CAASContentItemsRequest alloc] initWithContentPath:wcmBookPath completionBlock:^(CAASContentItemsResult *requestResult) {
        
        [resultExpectation fulfill];
        
        XCTAssertNil(requestResult.error);
        XCTAssertEqual(requestResult.httpStatusCode,200);
        
        XCTAssertEqual(requestResult.pageNumber, 1);
        XCTAssertTrue(requestResult.contentItems.count > 0);
        XCTAssertEqual(requestResult.morePages,NO);
        
        CAASContentItem *item = requestResult.contentItems.firstObject;
        
        XCTAssertNotNil(item.oid);
        XCTAssertNotNil(item.title);
        XCTAssertNotNil(item.keywords);
        XCTAssertNil(item.categories);
        
        XCTAssertEqual(item.elements.count,5);
        
        
    }];
    
    request.pageSize = 50;
    request.pageNumber = 1;
    request.allKeywords = @[keyword1];
    request.properties = @[@"id",@"title",@"keywords"];
    request.elements = @[@"author",@"cover",@"isbn",@"price",@"publish_date"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:NO],[NSSortDescriptor sortDescriptorWithKey:@"author" ascending:YES]];
    [self.caasService executeRequest:request];
    
    [self waitForExpectationsWithTimeout:TIMEOUT handler:^(NSError *error) {
        XCTAssertNil(error, @"Didn't received the list %@",error);
    }];
}



@end
