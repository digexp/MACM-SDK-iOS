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
#import "CAASAssetRequest.h"
#import "CAASAssetResult.h"


@interface CAASAssetTests : XCTestCase

@property (nonatomic,strong) CAASService *caasService;

@end

@implementation CAASAssetTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.caasService = [[CAASService alloc] initWithBaseURL:[NSURL URLWithString:CAASURL] contextRoot:@"wps" tenant:macmTenant username:@"wpsadmin" password:@"wpsadmin"];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) testImage {
    
    XCTestExpectation *resultItemExpectation = [self expectationWithDescription:@"Receive a Content Item By Path"];
    
    
    __block NSURL *coverURL;
    
    CAASContentItemRequest *requestContentItem = [[CAASContentItemRequest alloc] initWithContentPath:@"Samples/data/book/Book_698080520" completionBlock:^(CAASContentItemResult *requestResult) {
        
        [resultItemExpectation fulfill];
        
        XCTAssertNil(requestResult.error);
        XCTAssertEqual(requestResult.httpStatusCode,200);
        
        coverURL = requestResult.contentItem.elements[@"cover"];
        
        
    }];
    
    requestContentItem.properties = @[@"id",@"title",@"keywords"];
    requestContentItem.elements = @[@"author",@"cover",@"isbn",@"price",@"publish_date"];
    [self.caasService executeRequest:requestContentItem];
    
    [self waitForExpectationsWithTimeout:TIMEOUT handler:^(NSError *error) {
        XCTAssertNil(error, @"Didn't received the object %@",error);
    }];
    

    XCTestExpectation *resultImageExpectation = [self expectationWithDescription:@"Receive an image"];
    
    CAASAssetRequest *requestImage = [[CAASAssetRequest alloc] initWithAssetURL:coverURL completionBlock:^(CAASAssetResult *requestResult) {
        
        [resultImageExpectation fulfill];
        
        XCTAssertNil(requestResult.error);
        XCTAssertEqual(requestResult.httpStatusCode,200);
        
        
    }];
    
    [self.caasService executeRequest:requestImage];
    
    [self waitForExpectationsWithTimeout:TIMEOUT handler:^(NSError *error) {
        XCTAssertNil(error, @"Didn't received the object %@",error);
    }];

}

- (void) testImageFooBar {
    
    XCTestExpectation *resultExpectation = [self expectationWithDescription:@"Receive a Content Item"];
    
    NSURL *url = [[NSURL alloc] initWithString:@"/wps/wcm/myconnect/macm1/foobar/foobar.jpg?MOD=AJPERES" relativeToURL:[NSURL URLWithString:CAASURL]];
    
    CAASAssetRequest *request = [[CAASAssetRequest alloc] initWithAssetURL:url completionBlock:^(CAASAssetResult *requestResult) {
        
        [resultExpectation fulfill];
        XCTAssertNil(requestResult.image);
        
        //XCTAssertNotNil(requestResult.error);
        XCTAssertEqual(requestResult.httpStatusCode,404);
        
        
    }];
    
    [self.caasService executeRequest:request];
    
    [self waitForExpectationsWithTimeout:TIMEOUT handler:^(NSError *error) {
        XCTAssertNil(error, @"Didn't received the object %@",error);
    }];
    
}

@end
