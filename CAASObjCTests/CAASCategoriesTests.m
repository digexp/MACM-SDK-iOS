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

@interface CAASCategoriesTests : XCTestCase

@property (nonatomic,strong) CAASService *caasService;

@end

@implementation CAASCategoriesTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.caasService = [[CAASService alloc] initWithBaseURL:[NSURL URLWithString:CAASURL] contextRoot:@"wps" tenant:macmTenant username:@"wpsadmin" password:@"wpsadmin"];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testAllCategoriesFoobar {
    // This is an example of a functional test case.
    
    XCTestExpectation *resultExpectation = [self expectationWithDescription:@"Received a not found error"];
    
    
    CAASContentItemsRequest *request = [[CAASContentItemsRequest alloc] initWithContentPath:wcmBookPath completionBlock:^(CAASContentItemsResult *requestResult) {
        
        [resultExpectation fulfill];
        
        XCTAssertNil(requestResult.error);
        XCTAssertEqual(requestResult.httpStatusCode,200);
        
        XCTAssertEqual(requestResult.contentItems.count,0);
        
    }];
    
    request.allCategories = @[@"foobar"];
    [self.caasService executeRequest:request];
    
    [self waitForExpectationsWithTimeout:TIMEOUT handler:^(NSError *error) {
        XCTAssertNil(error, @"Didn't received the list %@",error);
    }];
}



- (void)testAnyCategoriesFoobar {
    // This is an example of a functional test case.
    
    XCTestExpectation *resultExpectation = [self expectationWithDescription:@"Received a not found error"];
    
    
    CAASContentItemsRequest *request = [[CAASContentItemsRequest alloc] initWithContentPath:wcmBookPath completionBlock:^(CAASContentItemsResult *requestResult) {
        
        [resultExpectation fulfill];
        
        XCTAssertNil(requestResult.error);
        XCTAssertEqual(requestResult.httpStatusCode,200);
        
        XCTAssertEqual(requestResult.contentItems.count,0);
        
    }];
    
    request.anyCategories = @[@"foobar"];
    [self.caasService executeRequest:request];
    
    [self waitForExpectationsWithTimeout:TIMEOUT handler:^(NSError *error) {
        XCTAssertNil(error, @"Didn't received the list %@",error);
    }];
}


- (void)testAllCategories {
    // This is an example of a functional test case.
    
    XCTestExpectation *resultExpectation = [self expectationWithDescription:@"Received a not found error"];
    
    
    NSString *category = @"Samples/macm/books/novel";
    CAASContentItemsRequest *request = [[CAASContentItemsRequest alloc] initWithContentPath:wcmBookPath completionBlock:^(CAASContentItemsResult *requestResult) {
        
        [resultExpectation fulfill];
        
        XCTAssertNil(requestResult.error);
        XCTAssertEqual(requestResult.httpStatusCode,200);
        
        XCTAssertTrue(requestResult.contentItems.count > 0);
        
        for (CAASContentItem *contentItem in [requestResult contentItems]){
            
            NSString *categories = contentItem.properties[@"categories"];
            XCTAssertTrue([categories isEqualToString:category.lowercaseString]);
            
        }
        
    }];
    
    request.allCategories = @[category];
    request.properties = @[@"categories"];
    [self.caasService executeRequest:request];
    
    [self waitForExpectationsWithTimeout:TIMEOUT handler:^(NSError *error) {
        XCTAssertNil(error, @"Didn't received the list %@",error);
    }];
}




@end
