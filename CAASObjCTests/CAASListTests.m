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

@interface CAASListTests : XCTestCase
@property (nonatomic,strong) CAASService *caasService;
@end

@implementation CAASListTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.caasService = [[CAASService alloc] initWithBaseURL:[NSURL URLWithString:CAASURL] contextRoot:@"wps" tenant:nil];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testList1Unauthorized {
    // This is an example of a functional test case.
    
    [self.caasService signOut];
    XCTAssertFalse(self.caasService.isUserAlreadySignedIn);
    
    XCTestExpectation *resultExpectation = [self expectationWithDescription:@"Received a not authorized error"];
    
    
    CAASContentItemsRequest *request = [[CAASContentItemsRequest alloc] initWithContentPath:@"does not exist" completionBlock:^(CAASContentItemsResult *requestResult) {
        
        [resultExpectation fulfill];
        
        XCTAssertEqual(requestResult.httpStatusCode,401);
        
    }];
    
    [self.caasService executeRequest:request];
    
    [self waitForExpectationsWithTimeout:TIMEOUT handler:^(NSError *error) {
        XCTAssertNil(error, @"Didn't received the list %@",error);
    }];

}

- (void)testList2WithSignIn {
    // This is an example of a functional test case.
    XCTestExpectation *resultExpectation = [self expectationWithDescription:@"Signed In"];
    
    [self.caasService signIn:@"wpsadmin" password:@"wpsadmin" completionHandler: ^(NSError *error, NSInteger httpStatusCode) {
        
        [resultExpectation fulfill];
        
        XCTAssertTrue(self.caasService.isUserAlreadySignedIn);
        
    }];
    
    [self waitForExpectationsWithTimeout:TIMEOUT handler:^(NSError *error) {
        XCTAssertNil(error, @"Didn't signed in %@",error);
    }];
}

- (void)testList3WithSignInFoobar {
    // This is an example of a functional test case.
    
    XCTAssertTrue(self.caasService.isUserAlreadySignedIn);
    
    XCTestExpectation *resultExpectation = [self expectationWithDescription:@"Received a not found error"];
    

    CAASContentItemsRequest *request = [[CAASContentItemsRequest alloc] initWithContentPath:@"foobar" completionBlock:^(CAASContentItemsResult *requestResult) {
        
        [resultExpectation fulfill];
        
        XCTAssertEqual(requestResult.httpStatusCode,404);
        
    }];

    [self.caasService executeRequest:request];
    
    [self waitForExpectationsWithTimeout:TIMEOUT handler:^(NSError *error) {
        XCTAssertNil(error, @"Didn't received the list %@",error);
    }];
}

- (void)testList4ByPathAndIdWithSignIn {
    // This is an example of a functional test case.
    
    XCTAssertTrue(self.caasService.isUserAlreadySignedIn);
    
    XCTestExpectation *resultByPathExpectation = [self expectationWithDescription:@"Received a list by path"];
    
    __block NSString *oid;
    
    CAASContentItemsRequest *requestByPath = [[CAASContentItemsRequest alloc] initWithContentPath:wcmBookPath completionBlock:^(CAASContentItemsResult *requestResult) {
        
        [resultByPathExpectation fulfill];
        
        XCTAssertNil(requestResult.error);
        XCTAssertEqual(requestResult.httpStatusCode,200);
        
        XCTAssertTrue(requestResult.contentItems.count > 0);
        
        oid = requestResult.oid;
        
    }];
    
    [self.caasService executeRequest:requestByPath];
    
    [self waitForExpectationsWithTimeout:TIMEOUT handler:^(NSError *error) {
        XCTAssertNil(error, @"Didn't received the list by path %@",error);
    }];
    
    XCTestExpectation *resultByIdExpectation = [self expectationWithDescription:@"Received a list by id"];
    
    CAASContentItemsRequest *requestById = [[CAASContentItemsRequest alloc] initWithContentPath:wcmBookPath completionBlock:^(CAASContentItemsResult *requestResult) {
        
        [resultByIdExpectation fulfill];
        
        XCTAssertNil(requestResult.error);
        XCTAssertEqual(requestResult.httpStatusCode,200);
        
        XCTAssertTrue(requestResult.contentItems.count > 0);
        
    }];
    
    [self.caasService executeRequest:requestById];
    
    [self waitForExpectationsWithTimeout:TIMEOUT handler:^(NSError *error) {
        XCTAssertNil(error, @"Didn't received the list by id%@",error);
    }];
    

}





@end
