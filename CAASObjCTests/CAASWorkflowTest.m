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

@interface CAASWorkflowTest : XCTestCase

@property (nonatomic,strong) CAASService *caasService;

@end

@implementation CAASWorkflowTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.caasService = [[CAASService alloc] initWithBaseURL:[NSURL URLWithString:CAASURL] contextRoot:@"wps" tenant:macmTenant username:@"wpsadmin" password:@"wpsadmin"];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testWorkflow {
    // This is an example of a functional test case.
    XCTestExpectation *resultByPathExpectation = [self expectationWithDescription:@"Received a list by path"];
    
    CAASContentItemsRequest *requestByPath = [[CAASContentItemsRequest alloc] initWithContentPath:wcmBookPath completionBlock:^(CAASContentItemsResult *requestResult) {
        
        [resultByPathExpectation fulfill];
        
        XCTAssertNil(requestResult.error);
        XCTAssertEqual(requestResult.httpStatusCode,200);
        
        XCTAssertTrue(requestResult.contentItems.count > 0);
        
        
    }];
    
    requestByPath.workflowStatus = CAASContentItemWorkflowStatusDraft;
    requestByPath.properties = @[@"id",@"title",@"keywords"];
    requestByPath.elements = @[@"author",@"cover",@"isbn",@"price",@"publish_date"];
    
    [self.caasService executeRequest:requestByPath];
    
    [self waitForExpectationsWithTimeout:TIMEOUT handler:^(NSError *error) {
        XCTAssertNil(error, @"Didn't received the list by path %@",error);
    }];
    
    
}

@end
