//
//  OHHTTPStubs+DeviseTests.m
//
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <OHHTTPStubs/OHHTTPStubsResponse+JSON.h>

#import "DVSHTTPClient+User.h"
#import "OHHTTPStubs+DeviseDemoTests.h"

NSString * const DVSHTTPStubsAllowedMethodsKey = @"DVSHTTPStubsAllowedMethodsKey";

@implementation OHHTTPStubs (DeviseTests)

#pragma mark - Specific stubs

+ (id<OHHTTPStubsDescriptor>)dvs_stubUserRegisterRequestsWithOptions:(NSDictionary *)options {
    NSString *path = DVSHTTPClientDefaultRegisterPath;
    options = [self dvs_optionsDictionaryForReceivedOptions:options defaultOptions:@{
                                                                                     DVSHTTPStubsAllowedMethodsKey: @[ @"POST" ],
                                                                                     }];
    return [self dvs_stubRequestsForPath:path options:options response:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [self dvs_responseWithJSON:@{ @"user": @{
                                                     @"id": @1,
                                                     @"email": @"john.appleseed@example.com",
                                                     @"authenticationToken": @"xXx_s3ss10N_t0K3N_xXx",
                                                     @"createdAt": @"1970-01-01T00:00:00.000Z",
                                                     @"updatedAt": @"1970-01-01T00:00:00.000Z",
                                                     } } statusCode:200];
    }];
}

+ (id<OHHTTPStubsDescriptor>)dvs_stubUserLogInRequestsWithOptions:(NSDictionary *)options {
    NSString *path = DVSHTTPClientDefaultLogInPath;
    options = [self dvs_optionsDictionaryForReceivedOptions:options defaultOptions:@{
                                                                                     DVSHTTPStubsAllowedMethodsKey: @[ @"POST" ],
                                                                                     }];
    return [self dvs_stubRequestsForPath:path options:options response:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [self dvs_responseWithJSON:@{ @"user": @{
                                                     @"id": @1,
                                                     @"email": @"john.appleseed@example.com",
                                                     @"authenticationToken": @"xXx_s3ss10N_t0K3N_xXx",
                                                     @"createdAt": @"1970-01-01T00:00:00.000Z",
                                                     @"updatedAt": @"1970-01-01T00:00:00.000Z",
                                                     } } statusCode:200];
    }];
}

#pragma mark - General stubs

+ (id<OHHTTPStubsDescriptor>)dvs_stubRequestsForPath:(NSString *)path options:(NSDictionary *)options response:(OHHTTPStubsResponseBlock)response {
    return [self stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        if (![[request.URL.path substringFromIndex:1] isEqualToString:path]) {
            return NO;
        }
        if (options[DVSHTTPStubsAllowedMethodsKey]) {
            if ([options[DVSHTTPStubsAllowedMethodsKey] indexOfObject:request.HTTPMethod] == NSNotFound) {
                return NO;
            }
        }
        return YES;
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return response(request);
    }];
}

#pragma mark - Convenience methods

+ (OHHTTPStubsResponse *)dvs_responseWithJSON:(id)jsonObject statusCode:(int)statusCode {
    return [OHHTTPStubsResponse responseWithJSONObject:jsonObject statusCode:statusCode headers:nil];
}

+ (NSDictionary *)dvs_optionsDictionaryForReceivedOptions:(NSDictionary *)options defaultOptions:(NSDictionary *)defaults {
    NSMutableDictionary *mutableOptions = (options != nil) ? [options mutableCopy] : [NSMutableDictionary dictionary];
    [defaults enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (mutableOptions[key] == nil) {
            mutableOptions[key] = obj;
        }
    }];
    return [mutableOptions copy];
}

@end
