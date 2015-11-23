//
//  CAASOpenProjetcs.m
//  CAASObjC
//
//  Created by slizeray on 23/06/15.
//  Copyright (c) 2015 IBM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>


#import "CAASTests.h"
#import "CAASService.h"
#import "CAASContentItemsRequest.h"
#import "CAASContentItemsResult.h"

@interface CAASOpenProjects : XCTestCase

@property (nonatomic,strong) CAASService *caasService;

@end

@implementation CAASOpenProjects

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.caasService = [[CAASService alloc] initWithBaseURL:[NSURL URLWithString:CAASURL] contextRoot:@"wps" tenant:macmTenant username:@"wpsadmin" password:@"wpsadmin"];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testOpenProjects {
    // This is an example of a functional test case.
    XCTestExpectation *resultByPathExpectation = [self expectationWithDescription:@"Received a list by path"];
    
    CAASContentItemsRequest *requestByPath = [[CAASContentItemsRequest alloc] initWithContentPath:@"MACM System/Views/Open Projects" completionBlock:^(CAASContentItemsResult *requestResult) {
        
        [resultByPathExpectation fulfill];
        
        XCTAssertNil(requestResult.error);
        XCTAssertEqual(requestResult.httpStatusCode,200);
        
        XCTAssertTrue(requestResult.contentItems.count > 0);
        
        
    }];
    
    [self.caasService executeRequest:requestByPath];
    
    [self waitForExpectationsWithTimeout:TIMEOUT handler:^(NSError *error) {
        XCTAssertNil(error, @"Didn't received the list by path %@",error);
    }];
    
    
}


- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
