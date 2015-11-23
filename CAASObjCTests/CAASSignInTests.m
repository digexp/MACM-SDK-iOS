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

@interface CAASSignInTests : XCTestCase
@property (nonatomic,strong) CAASService *caasService;
@end

@implementation CAASSignInTests

- (void)setUp {
    [super setUp];
    //
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.caasService = [[CAASService alloc] initWithBaseURL:[NSURL URLWithString:CAASURL] contextRoot:@"wps" tenant:macmTenant];
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSignIn1 {
    
    // This is an example of a functional test case.
    XCTestExpectation *resultExpectation = [self expectationWithDescription:@"Signed In"];
    
    [self.caasService signIn:@"wpsadmin" password:@"wpsadmin" completionHandler: ^(NSError *error, NSInteger httpStatusCode) {
        
        XCTAssertEqual(httpStatusCode,204);
        [resultExpectation fulfill];
        
        XCTAssertTrue(self.caasService.isUserAlreadySignedIn);
        
    }];
    
    [self waitForExpectationsWithTimeout:TIMEOUT handler:^(NSError *error) {
        XCTAssertNil(error, @"Didn't signed in %@",error);
    }];
}

- (void)testSignIn2 {
    
    XCTAssertTrue(self.caasService.isUserAlreadySignedIn);
}

- (void) testSignSign3 {
    
    [self.caasService signOut];
    XCTAssertFalse(self.caasService.isUserAlreadySignedIn);
    
}

- (void) testSignSign4 {
    
    XCTAssertFalse(self.caasService.isUserAlreadySignedIn);
    
}

- (void) testSignSign5 {
    
    // This is an example of a functional test case.
    XCTestExpectation *resultExpectation = [self expectationWithDescription:@"Signed In"];
    
    [self.caasService signIn:@"foo" password:@"bar" completionHandler: ^(NSError *error, NSInteger httpStatusCode) {
        
        XCTAssertEqual(httpStatusCode,401);
        [resultExpectation fulfill];
        
        XCTAssertFalse(self.caasService.isUserAlreadySignedIn);
        
    }];
    
    [self waitForExpectationsWithTimeout:TIMEOUT handler:^(NSError *error) {
        XCTAssertNil(error, @"Didn't signed in %@",error);
    }];
    
}

@end
