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

@interface CAASKeywordsTests : XCTestCase

@property (nonatomic,strong) CAASService *caasService;

@end

@implementation CAASKeywordsTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.caasService = [[CAASService alloc] initWithBaseURL:[NSURL URLWithString:CAASURL] contextRoot:@"wps" tenant:macmTenant username:@"wpsadmin" password:@"wpsadmin"];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testAnyKeywordsFoobar {
    // This is an example of a functional test case.
    
    
    XCTestExpectation *resultExpectation = [self expectationWithDescription:@"Received a not found error"];
    
    
    CAASContentItemsRequest *request = [[CAASContentItemsRequest alloc] initWithContentPath:wcmBookPath completionBlock:^(CAASContentItemsResult *requestResult) {
        
        [resultExpectation fulfill];
        
        XCTAssertNil(requestResult.error);
        XCTAssertEqual(requestResult.httpStatusCode,200);
        
        XCTAssertEqual(requestResult.contentItems.count,0);
        
    }];
    
    request.anyKeywords = @[@"foobar"];
    [self.caasService executeRequest:request];
    
    [self waitForExpectationsWithTimeout:TIMEOUT handler:^(NSError *error) {
        XCTAssertNil(error, @"Didn't received the list %@",error);
    }];
}




- (void)testAllKeywordsFoobar {
    // This is an example of a functional test case.
    
    XCTestExpectation *resultExpectation = [self expectationWithDescription:@"Received a not found error"];
    
    
    CAASContentItemsRequest *request = [[CAASContentItemsRequest alloc] initWithContentPath:wcmBookPath completionBlock:^(CAASContentItemsResult *requestResult) {
        
        [resultExpectation fulfill];
        
        XCTAssertNil(requestResult.error);
        XCTAssertEqual(requestResult.httpStatusCode,200);
        
        XCTAssertEqual(requestResult.contentItems.count,0);
        
    }];
    
    request.allKeywords = @[@"foobar"];
    [self.caasService executeRequest:request];
    
    [self waitForExpectationsWithTimeout:TIMEOUT handler:^(NSError *error) {
        XCTAssertNil(error, @"Didn't received the list %@",error);
    }];
}



- (void)testListAllKeywords1 {
    // This is an example of a functional test case.
    
    XCTestExpectation *resultExpectation = [self expectationWithDescription:@"Received a not found error"];
    
    
    NSString * keyword = @"bestseller";
    CAASContentItemsRequest *request = [[CAASContentItemsRequest alloc] initWithContentPath:wcmBookPath completionBlock:^(CAASContentItemsResult *requestResult) {
        
        [resultExpectation fulfill];
        
        XCTAssertNil(requestResult.error);
        XCTAssertEqual(requestResult.httpStatusCode,200);
        
        XCTAssertTrue(requestResult.contentItems.count > 0);
        
        for (CAASContentItem *contentItem in [requestResult contentItems]){
            
            NSString *keywords = contentItem.properties[@"keywords"];
            XCTAssertTrue([keywords containsString:keyword.lowercaseString]);
            
        }
        
    }];
    
    request.allKeywords = @[keyword];
    request.properties = @[@"keywords"];
    [self.caasService executeRequest:request];
    
    [self waitForExpectationsWithTimeout:TIMEOUT handler:^(NSError *error) {
        XCTAssertNil(error, @"Didn't received the list %@",error);
    }];
}

- (void)testListAllKeywords2 {
    // This is an example of a functional test case.
    
    XCTestExpectation *resultExpectation = [self expectationWithDescription:@"Received a not found error"];
    
    
    NSString * keyword = @"special_offer";
    CAASContentItemsRequest *request = [[CAASContentItemsRequest alloc] initWithContentPath:wcmBookPath completionBlock:^(CAASContentItemsResult *requestResult) {
        
        [resultExpectation fulfill];
        
        XCTAssertNil(requestResult.error);
        XCTAssertEqual(requestResult.httpStatusCode,200);
        
        XCTAssertTrue(requestResult.contentItems.count > 0);
        
        for (CAASContentItem *contentItem in [requestResult contentItems]){
            
            NSString *keywords = contentItem.properties[@"keywords"];
            
            XCTAssertTrue(contentItem.elements.count == 0);
            
            XCTAssertTrue([keywords containsString:keyword.lowercaseString]);
            
        }
        
    }];
    
    request.allKeywords = @[keyword];
    request.properties = @[@"keywords"];
    [self.caasService executeRequest:request];
    
    [self waitForExpectationsWithTimeout:TIMEOUT handler:^(NSError *error) {
        XCTAssertNil(error, @"Didn't received the list %@",error);
    }];
}


- (void)testListAllKeywords3 {
    // This is an example of a functional test case.
    
    XCTestExpectation *resultExpectation = [self expectationWithDescription:@"Received a not found error"];
    
    
    NSString * keyword1 = @"bestseller";
    NSString * keyword2 = @"special_offer";
    CAASContentItemsRequest *request = [[CAASContentItemsRequest alloc] initWithContentPath:wcmBookPath completionBlock:^(CAASContentItemsResult *requestResult) {
        
        [resultExpectation fulfill];
        
        XCTAssertNil(requestResult.error);
        XCTAssertEqual(requestResult.httpStatusCode,200);
        
        XCTAssertTrue(requestResult.contentItems.count > 0);
        
        for (CAASContentItem *contentItem in [requestResult contentItems]){
            
            NSString *keywords = contentItem.properties[@"keywords"];
            
            XCTAssertTrue(contentItem.elements.count == 0);
            
            XCTAssertTrue([keywords containsString:keyword1.lowercaseString]);
            XCTAssertTrue([keywords containsString:keyword2.lowercaseString]);
            
        }
        
    }];
    
    request.allKeywords = @[keyword1,keyword2];
    request.properties = @[@"keywords"];
    [self.caasService executeRequest:request];
    
    [self waitForExpectationsWithTimeout:TIMEOUT handler:^(NSError *error) {
        XCTAssertNil(error, @"Didn't received the list %@",error);
    }];
}

- (void)testListAllKeywords4 {
    // This is an example of a functional test case.
    
    XCTestExpectation *resultExpectation = [self expectationWithDescription:@"Received a not found error"];
    
    
    NSString * keyword1 = @"bestseller";
    NSString * keyword2 = @"special_offer";
    NSString * keyword3 = @"foobar";
    CAASContentItemsRequest *request = [[CAASContentItemsRequest alloc] initWithContentPath:wcmBookPath completionBlock:^(CAASContentItemsResult *requestResult) {
        
        [resultExpectation fulfill];
        
        XCTAssertNil(requestResult.error);
        XCTAssertEqual(requestResult.httpStatusCode,200);
        
        XCTAssertEqual(requestResult.contentItems.count,0);
        
        
    }];
    
    request.allKeywords = @[keyword1,keyword2,keyword3];
    request.properties = @[@"keywords"];
    [self.caasService executeRequest:request];
    
    [self waitForExpectationsWithTimeout:TIMEOUT handler:^(NSError *error) {
        XCTAssertNil(error, @"Didn't received the list %@",error);
    }];
}


- (void)testAnykeywords {
    // This is an example of a functional test case.
    
    XCTestExpectation *resultExpectation = [self expectationWithDescription:@"Received a not found error"];
    
    
    NSString * keyword1 = @"bestseller";
    NSString * keyword2 = @"special_offer";
    NSString * keyword3 = @"foobar";
    CAASContentItemsRequest *request = [[CAASContentItemsRequest alloc] initWithContentPath:wcmBookPath completionBlock:^(CAASContentItemsResult *requestResult) {
        
        [resultExpectation fulfill];
        
        XCTAssertNil(requestResult.error);
        XCTAssertEqual(requestResult.httpStatusCode,200);
        
        XCTAssertTrue(requestResult.contentItems.count > 0);
        
        for (CAASContentItem *contentItem in [requestResult contentItems]){
            
            NSString *keywords = contentItem.properties[@"keywords"];
            XCTAssertTrue(contentItem.elements.count == 0);
            
            BOOL t1 = [keywords containsString:keyword1.lowercaseString];
            BOOL t2 = [keywords containsString:keyword2.lowercaseString];
            
            XCTAssertTrue(t1 || t2);
            XCTAssertFalse([keywords containsString:keyword3.lowercaseString]);
        }
        
    }];
    
    request.anyKeywords = @[keyword1,keyword2,keyword3];
    request.properties = @[@"keywords"];
    [self.caasService executeRequest:request];
    
    [self waitForExpectationsWithTimeout:TIMEOUT handler:^(NSError *error) {
        XCTAssertNil(error, @"Didn't received the list %@",error);
    }];
}



@end
