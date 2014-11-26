//
//  OHHTTPStubs+SaasKitTests.m
//  
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "OHHTTPStubs+SaasKitTests.h"

@implementation OHHTTPStubs (SaasKitTests)

#pragma mark Configuration

+ (NSURL *)ssk_stubURL {
    return [NSURL URLWithString:@"http://saaskit.tests"];
}

#pragma mark Stubs

+ (id<OHHTTPStubsDescriptor>)ssk_stubLoginRouteWithOptions:(NSDictionary *)options {
    return [self ssk_stubRequestsForPath:@"/login" withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        BOOL valid = (^BOOL() {
            NSDictionary *input = [self ssk_retrievePostDataOfRequest:request];
            if (input[@"username"] == nil && input[@"email"] == nil) {
                return NO;
            } if (input[@"password"] == nil) {
                return NO;
            } if (input[@"email"] != nil && options[@"allowedEmail"] != nil) {
                if (![input[@"email"] isEqualToString:options[@"allowedEmail"]]) {
                    return NO;
                }
            } if (input[@"username"] != nil && options[@"allowedUsername"] != nil) {
                if (![input[@"username"] isEqualToString:options[@"allowedUsername"]]) {
                    return NO;
                }
            } if (input[@"password"] != nil && options[@"allowedPassword"] != nil) {
                if (![input[@"password"] isEqualToString:options[@"allowedPassword"]]) {
                    return NO;
                }
            }
            return YES;
        })();
        int statusCode = (valid) ? 200 : 400;
        return [self ssk_responseWithData:nil statusCode:statusCode];
    }];
}

+ (id<OHHTTPStubsDescriptor>)ssk_stubForgotPasswordRouteWithOptions:(NSDictionary *)options {
    return [self ssk_stubRequestsForPath:@"/forgotPassword" withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        BOOL valid = (^BOOL() {
            NSDictionary *input = [self ssk_retrievePostDataOfRequest:request];
            if (input[@"email"] == nil) {
                return NO;
            } if (input[@"email"] != nil && options[@"allowedEmail"] != nil) {
                if (![input[@"email"] isEqualToString:options[@"allowedEmail"]]) {
                    return NO;
                }
            }
            return YES;
        })();
        int statusCode = (valid) ? 200 : 400;
        return [self ssk_responseWithData:nil statusCode:statusCode];
    }];
}

#pragma mark Convenience methods

+ (NSDictionary *)ssk_retrievePostDataOfRequest:(NSURLRequest *)request {
    NSData *data = request.HTTPBody;
    if (data != nil) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if (dict != nil && [dict isKindOfClass:[NSDictionary class]]) {
            return dict;
        }
    }
    return nil;
}

+ (id<OHHTTPStubsDescriptor>)ssk_stubRequestsForPath:(NSString *)path withStubResponse:(OHHTTPStubsResponseBlock)responseBlock {
    return [self stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        if ([request.URL.host isEqualToString:[self ssk_stubURL].host]) {
            return [request.URL.path isEqualToString:path];
        } else {
            return NO;
        }
    } withStubResponse:responseBlock];
}

+ (OHHTTPStubsResponse *)ssk_responseWithData:(NSData *)data statusCode:(int)statusCode {
    return [OHHTTPStubsResponse responseWithData:data statusCode:statusCode headers:@{
        @"Content-Type": @"application/json",
    }];
}

@end
