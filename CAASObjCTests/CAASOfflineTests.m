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


@import UIKit;
@import XCTest;
@import CAASObjC;

#import "CAASMockURLProtocol.h"
#import "CAASServicePrivate.h"
#import "CAASRequestPrivate.h"

static NSString *const MACM_MOCK_URL = @"http://macm-mock";
static NSString *const MACM_MOCK_CONTEXTROOT = @"mockContext";
static NSString *const MACM_MOCK_TENANT = @"mockTenant";

@interface CAASOfflineTests : XCTestCase
@property (nonatomic,strong) CAASService *caasService;
@end

@implementation CAASOfflineTests

- (void)setUp {
    [super setUp];

    NSURL *macmURL = [NSURL URLWithString:MACM_MOCK_URL];
    self.caasService = [[CAASService alloc] initWithBaseURL:macmURL contextRoot:@"wps" tenant:nil];

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.protocolClasses = @[CAASMockURLProtocol.class];
    configuration.HTTPCookieAcceptPolicy = NSHTTPCookieAcceptPolicyAlways;
    self.caasService.caasSession = [NSURLSession sessionWithConfiguration:configuration delegate:self.caasService delegateQueue:[NSOperationQueue mainQueue]];
    //[NSURLProtocol registerClass:CAASMockURLProtocol.class];
    
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testBaseURL {
    
    NSURL *macmURL = [NSURL URLWithString:MACM_MOCK_URL];
    CAASService *caasService = [[CAASService alloc] initWithBaseURL:macmURL contextRoot:@"wps" tenant:nil];
    XCTAssert([caasService.baseURL isEqual:macmURL],@"Base URL error");
    XCTAssertNil(caasService.tenant);
    
}

- (void)testContextRoot {
    
    NSURL *macmURL = [NSURL URLWithString:MACM_MOCK_URL];
    CAASService *caasService = [[CAASService alloc] initWithBaseURL:macmURL contextRoot:MACM_MOCK_CONTEXTROOT tenant:nil];
    XCTAssert([caasService.baseURL isEqual:macmURL],@"Base URL error");
    XCTAssert([caasService.contextRoot isEqualToString:MACM_MOCK_CONTEXTROOT],@"Context Root error");
    XCTAssertNil(caasService.tenant);
    
}

- (void)testTenant {
    
    NSURL *macmURL = [NSURL URLWithString:MACM_MOCK_URL];
    CAASService *caasService = [[CAASService alloc] initWithBaseURL:macmURL contextRoot:MACM_MOCK_CONTEXTROOT tenant:MACM_MOCK_TENANT];
    XCTAssert([caasService.baseURL isEqual:macmURL],@"Base URL error");
    XCTAssert([caasService.contextRoot isEqualToString:MACM_MOCK_CONTEXTROOT],@"Context Root error");
    XCTAssert([caasService.tenant isEqualToString:MACM_MOCK_TENANT],@"Tenant error");
    
}

- (void) testDefaultTimeout {
    NSURL *macmURL = [NSURL URLWithString:MACM_MOCK_URL];
    CAASService *caasService = [[CAASService alloc] initWithBaseURL:macmURL contextRoot:MACM_MOCK_CONTEXTROOT tenant:nil];
    XCTAssertEqual(caasService.timeout, 60);
    caasService.timeout = 90;
    XCTAssertEqual(caasService.timeout, 90);
    
    XCTAssertEqual(caasService.signInTimeout, 30);
    caasService.signInTimeout = 45;
    XCTAssertEqual(caasService.signInTimeout, 45);
}

- (void) testTrustedCertificates {
    NSURL *macmURL = [NSURL URLWithString:MACM_MOCK_URL];
    CAASService *caasService = [[CAASService alloc] initWithBaseURL:macmURL contextRoot:MACM_MOCK_CONTEXTROOT tenant:nil];
    XCTAssertFalse(caasService.allowUntrustedCertificates);
    
    caasService.allowUntrustedCertificates = YES;
    
    XCTAssertTrue(caasService.allowUntrustedCertificates);
    
}

- (NSData*)jsonWithName:(NSString*)jsonName {
    NSData *data = [[NSData alloc] initWithContentsOfFile:
                    [[NSBundle bundleForClass:self.class] pathForResource:jsonName ofType:@"json"]];
    
    
    
    XCTAssertNotNil(data, @"Failed to load json '%@'", jsonName);
    
    return data;
}


- (void) testContentItem {
    
    [CAASMockURLProtocol setCAASResponseData:[self jsonWithName:@"contentItem"]];
    [CAASMockURLProtocol setCAASHeaders:@{@"Content-Type":@"application/json; charset=utf-8"}];
    
    XCTestExpectation *resultExpectation = [self expectationWithDescription:@"ContentItem received"];

    NSString *oid = @"c6410aca-4944-4751-9a1a-053994e5c9cb";
    CAASContentItemRequest *request = [[CAASContentItemRequest alloc] initWithOid:oid completionBlock:^(CAASContentItemResult *requestResult){
        [resultExpectation fulfill];
        XCTAssertTrue(requestResult.httpStatusCode == requestResult.httpResponse.statusCode);
        XCTAssertNil(requestResult.error,@"Network error %@",requestResult.error);
        XCTAssertEqualObjects(oid, requestResult.contentItem.oid);
    }];
    
    CAASRequestResult *result = [self.caasService executeRequest:request];
    XCTAssertNotNil(result, @"Request Result is nil");
    
    [self waitForExpectationsWithTimeout:1 handler:^(NSError *error) {
        XCTAssertNil(error, @"ContentItem not received %@",error);
    }];
    
}

- (void) testParameters {
    
    NSString *oid = @"4aab01f2-9ee2-4e29-8e22-863ed3a884bf";
    CAASContentItemRequest *request = [[CAASContentItemRequest alloc] initWithOid:oid completionBlock:^(CAASContentItemResult *requestResult){
    }];

    NSString *value = [request valueForParameter:@"foobar"];
    XCTAssertNil(value,@"foobar should be nil, %@",value);
    
    [request addParameter:@"foo" value:@"bar"];
    NSString *bar = [request valueForParameter:@"foo"];
    XCTAssertEqualObjects(bar,@"bar");
    
    
    
}

- (void) testSortingCriterias {
    
    CAASContentItemsRequest *request = [[CAASContentItemsRequest alloc] initWithContentPath:@"Caas Content/Content Types/Offerings" completionBlock:^(CAASContentItemsResult *requestResult){
        
    }];
    
    XCTAssertNil(request.sortDescriptors);
    
    NSSortDescriptor *titleSortDesc = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    
    request.sortDescriptors = @[titleSortDesc];
    
    NSArray *sortDescriptors = request.sortDescriptors;
    
    XCTAssertTrue(sortDescriptors.count == 1);
    
    NSSortDescriptor *readTitleSortDesc = sortDescriptors[0];
    
    XCTAssertTrue(readTitleSortDesc.ascending);
    
    XCTAssertEqualObjects(readTitleSortDesc.key,@"title");
    
}

- (void) testElements {
  
    CAASContentItemsRequest *request = [[CAASContentItemsRequest alloc] initWithContentPath:@"Caas Content/Content Types/Offerings" completionBlock:^(CAASContentItemsResult *requestResult){
        
    }];
    
    XCTAssertNil(request.elements);
    
    request.elements = @[@"foo",@"bar"];
    
    XCTAssertTrue(request.elements.count == 2);
    

}

- (void) testGeolocalization {
    
    [CAASMockURLProtocol setCAASResponseData:[self jsonWithName:@"contentItems"]];
    [CAASMockURLProtocol setCAASHeaders:@{@"Content-Type":@"application/json; charset=utf-8"}];
    
    XCTestExpectation *resultExpectation = [self expectationWithDescription:@"ContentItem received"];
    
    CAASContentItemsRequest *request = [[CAASContentItemsRequest alloc] initWithContentPath:@"Caas Content/Content Types/Offerings" completionBlock:^(CAASContentItemsResult *requestResult){
        
        [resultExpectation fulfill];
        
        NSURLRequest* request = requestResult.httpRequest;
        NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:request.URL
                                                    resolvingAgainstBaseURL:NO];

        NSArray *queryItems = urlComponents.queryItems;
        NSString *latitude = [self valueForKey:@"wp_ct_latitude" fromQueryItems:queryItems];
        NSString *longitude = [self valueForKey:@"wp_ct_longitude" fromQueryItems:queryItems];
        XCTAssertNotNil(latitude);
        XCTAssertNotNil(longitude);
        
        
    }];
    
    XCTAssertFalse(request.isGeolocalized);
    
    request.geolocalized = YES;

    XCTAssertTrue(request.isGeolocalized);

    CAASRequestResult *result = [self.caasService executeRequest:request];
    XCTAssertNotNil(result, @"Request Result is nil");
    
    [self waitForExpectationsWithTimeout:1 handler:^(NSError *error) {
        XCTAssertNil(error, @"ContentItem not received %@",error);
    }];
    
    
}

- (void) testImage {
    
    //[CAASMockURLProtocol setCAASResponseData:[self jsonWithName:@"contentItems"]];
    [CAASMockURLProtocol setCAASHeaders:@{@"Content-Type":@"image/jpeg"}];
    XCTestExpectation *resultExpectation = [self expectationWithDescription:@"Image received"];
    
    NSURL *imageURL = [NSURL URLWithString:@"http://www.myhost.com/fooImage.jpg?foo=bar"];
    CAASAssetRequest *request = [[CAASAssetRequest alloc] initWithAssetURL:imageURL completionBlock:^(CAASAssetResult *requestResult){
        
        [resultExpectation fulfill];
        
        NSURLRequest* request = requestResult.httpRequest;
        NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:request.URL
                                                    resolvingAgainstBaseURL:NO];
        
        NSArray *queryItems = urlComponents.queryItems;
        NSString *latitude = [self valueForKey:@"wp_ct_latitude" fromQueryItems:queryItems];
        NSString *longitude = [self valueForKey:@"wp_ct_longitude" fromQueryItems:queryItems];
        XCTAssertNotNil(latitude);
        XCTAssertNotNil(longitude);
        
        
    }];
    
    XCTAssertFalse(request.isGeolocalized);
    
    request.geolocalized = YES;
    
    XCTAssertTrue(request.isGeolocalized);
    
    CAASRequestResult *result = [self.caasService executeRequest:request];
    XCTAssertNotNil(result, @"Request Result is nil");
    
    [self waitForExpectationsWithTimeout:1 handler:^(NSError *error) {
        XCTAssertNil(error, @"Image not received %@",error);
    }];
    
    
}

- (NSString *)valueForKey:(NSString *)key fromQueryItems:(NSArray *)queryItems
{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name=%@", key];
    NSArray *items = [queryItems filteredArrayUsingPredicate:predicate];
    
    XCTAssertTrue(items.count  < 2);
    
    if (items.count == 0)
        return nil;
    NSURLQueryItem *queryItem = items.firstObject;
    
    return queryItem.value;
}
             
- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
