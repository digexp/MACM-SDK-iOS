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


#import "CAASMockURLProtocol.h"

static NSData *caasResponseData = nil;
static NSDictionary *caasHeaders = nil;
static NSInteger caasStatusCode = 200;
static NSError *caasError = nil;


@implementation CAASMockURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    return YES;
}

+ (void)load {
    
    //[NSURLProtocol registerClass:CAASMockURLProtocol.class];
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

+ (void)setCAASResponseData:(NSData*)data {
    
    caasResponseData = data;
}

+ (void)setCAASHeaders:(NSDictionary*)headers {
    
    caasHeaders = headers;
}

+ (void)setCAASStatusCode:(NSInteger)statusCode {
    caasStatusCode = statusCode;
}

+ (void)setCAASError:(NSError*)error {
    
    caasError = error;
}

- (NSCachedURLResponse *)cachedResponse {
    return nil;
}

- (void)startLoading {
    NSURLRequest *request = [self request];
    id<NSURLProtocolClient> client = [self client];
    
    if(caasResponseData) {
        // Send the canned data
        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[request URL]
                                                                  statusCode:caasStatusCode
                                                                 HTTPVersion:@"HTTP/1.1"
                                                                headerFields:caasHeaders];
        
        [client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
        [client URLProtocol:self didLoadData:caasResponseData];
        [client URLProtocolDidFinishLoading:self];
        
    }
    else if(caasError) {
        // Send the canned error
        [client URLProtocol:self didFailWithError:caasError];
    }
}

- (void)stopLoading {
}



@end
