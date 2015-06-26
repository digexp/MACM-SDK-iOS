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


@interface CAASObjectTests : XCTestCase

@property (nonatomic,strong) CAASService *caasService;

@end

@implementation CAASObjectTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.caasService = [[CAASService alloc] initWithBaseURL:[NSURL URLWithString:CAASURL] contextRoot:@"wps" tenant:nil username:@"wpsadmin" password:@"wpsadmin"];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testObjectByPathAndId {
    // This is an example of a functional test case.
    
    XCTestExpectation *resultExpectation = [self expectationWithDescription:@"Receive a Content Item By Path"];
    
    
    __block NSString *oid;
    
    CAASContentItemRequest *request = [[CAASContentItemRequest alloc] initWithContentPath:@"OOTB Content/Data/Book/The Girl in the Train"completionBlock:^(CAASContentItemResult *requestResult) {
        
        [resultExpectation fulfill];
        
        XCTAssertNil(requestResult.error);
        XCTAssertEqual(requestResult.httpStatusCode,200);
        
        oid = requestResult.contentItem.oid;
        
        
        
    }];
    
    request.properties = @[@"id",@"title",@"keywords"];
    request.elements = @[@"author",@"cover",@"isbn",@"price",@"publish_date"];
    [self.caasService executeRequest:request];
    
    [self waitForExpectationsWithTimeout:TIMEOUT handler:^(NSError *error) {
        XCTAssertNil(error, @"Didn't received the object %@",error);
    }];
    
    
    XCTestExpectation *resultByIdExpectation = [self expectationWithDescription:@"Receive a Content Item By ID"];
    
    CAASContentItemRequest *requestById = [[CAASContentItemRequest alloc] initWithOid:oid completionBlock:^(CAASContentItemResult *requestResult) {
        
        [resultByIdExpectation fulfill];
        
        XCTAssertNil(requestResult.error);
        XCTAssertEqual(requestResult.httpStatusCode,200);
        
        oid = requestResult.contentItem.oid;
        
        
        
    }];
    
    requestById.properties = @[@"id",@"title",@"keywords"];
    requestById.elements = @[@"author",@"cover",@"isbn",@"price",@"publish_date"];
    [self.caasService executeRequest:requestById];
    
    [self waitForExpectationsWithTimeout:TIMEOUT handler:^(NSError *error) {
        XCTAssertNil(error, @"Didn't received the object %@",error);
    }];
    
    
}

- (void)testObjectByIDFooBar {
    // This is an example of a functional test case.
    
    XCTestExpectation *resultExpectation = [self expectationWithDescription:@"Receive a Content Item"];
    
    
    CAASContentItemRequest *request = [[CAASContentItemRequest alloc] initWithOid:@"foobar"completionBlock:^(CAASContentItemResult *requestResult) {
        
        [resultExpectation fulfill];
        
        XCTAssertEqual(requestResult.httpStatusCode,404);
        
        
    }];
    
    [self.caasService executeRequest:request];
    
    [self waitForExpectationsWithTimeout:TIMEOUT handler:^(NSError *error) {
        XCTAssertNil(error, @"Didn't received the object %@",error);
    }];
}

- (void)testObjectByPathFooBar {
    // This is an example of a functional test case.
    
    XCTestExpectation *resultExpectation = [self expectationWithDescription:@"Receive a Content Item By ID"];
    
    
    CAASContentItemRequest *request = [[CAASContentItemRequest alloc] initWithContentPath:@"foobar"completionBlock:^(CAASContentItemResult *requestResult) {
        
        [resultExpectation fulfill];
        
        XCTAssertEqual(requestResult.httpStatusCode,404);
        
        
    }];
    
    request.properties = @[@"id",@"title",@"keywords"];
    request.elements = @[@"author",@"cover",@"isbn",@"price",@"publish_date"];
    [self.caasService executeRequest:request];
    
    [self waitForExpectationsWithTimeout:TIMEOUT handler:^(NSError *error) {
        XCTAssertNil(error, @"Didn't received the object %@",error);
    }];
}




@end
