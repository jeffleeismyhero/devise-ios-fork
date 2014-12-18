//
//  OHHTTPStubs+DeviseTests.m
//  
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <OHHTTPStubs/OHHTTPStubsResponse+JSON.h>

#import "DVSHTTPClient+User.h"
#import "OHHTTPStubs+DeviseTests.h"

NSString * const DVSHTTPStubsAllowedLoginCredentialsKey = @"DVSHTTPStubsAllowedLoginCredentialsKey";
NSString * const DVSHTTPStubsAllowedMethodsKey = @"DVSHTTPStubsAllowedMethodsKey";
NSString * const DVSHTTPStubsNumberOfFailuresKey = @"DVSHTTPStubsNumberOfFailuresKey";

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
            @"email": @"john.appleseed@apple.com",
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
            @"email": @"john.appleseed@apple.com",
            @"authenticationToken": @"xXx_s3ss10N_t0K3N_xXx",
            @"createdAt": @"1970-01-01T00:00:00.000Z",
            @"updatedAt": @"1970-01-01T00:00:00.000Z",
        } } statusCode:200];
    }];
}

+ (id<OHHTTPStubsDescriptor>)dvs_stubUserUpdateRequestsWithOptions:(NSDictionary *)options {
    NSString *path = DVSHTTPClientDefaultUpdatePath;
    options = [self dvs_optionsDictionaryForReceivedOptions:options defaultOptions:@{
        DVSHTTPStubsAllowedMethodsKey: @[ @"PUT" ],
    }];
    return [self dvs_stubRequestsForPath:path options:options response:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [self dvs_responseWithJSON:@{ @"user": @{
            @"id": @1,
            @"email": @"john.appleseed@apple.com",
            @"authenticationToken": @"xXx_s3ss10N_t0K3N_xXx",
            @"createdAt": @"1970-01-01T00:00:00.000Z",
            @"updatedAt": @"1970-01-01T00:00:00.000Z",
        } } statusCode:200];
    }];
}

+ (id<OHHTTPStubsDescriptor>)dvs_stubUserDeleteRequestsWithOptions:(NSDictionary *)options {
    NSString *path = DVSHTTPClientDefaultDeletePath;
    options = [self dvs_optionsDictionaryForReceivedOptions:options defaultOptions:@{
        DVSHTTPStubsAllowedMethodsKey: @[ @"DELETE" ],
    }];
    return [self dvs_stubRequestsForPath:path options:options response:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [self dvs_responseWithJSON:@{ @"user": @{
            @"id": @1,
            @"email": @"john.appleseed@apple.com",
            @"authenticationToken": @"xXx_s3ss10N_t0K3N_xXx",
            @"createdAt": @"1970-01-01T00:00:00.000Z",
            @"updatedAt": @"1970-01-01T00:00:00.000Z",
        } } statusCode:200];
    }];
}

+ (id<OHHTTPStubsDescriptor>)dvs_stubUserChangePasswordRequestsWithOptions:(NSDictionary *)options {
    NSString *path = DVSHTTPClientDefaultChangePasswordPath;
    options = [self dvs_optionsDictionaryForReceivedOptions:options defaultOptions:@{
        DVSHTTPStubsAllowedMethodsKey: @[ @"PUT" ],
    }];
    return [self dvs_stubRequestsForPath:path options:options response:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [self dvs_responseWithJSON:@{ @"user": @{
            @"id": @1,
            @"email": @"john.appleseed@apple.com",
            @"authenticationToken": @"xXx_s3ss10N_t0K3N_xXx",
            @"createdAt": @"1970-01-01T00:00:00.000Z",
            @"updatedAt": @"1970-01-01T00:00:00.000Z",
        } } statusCode:200];
    }];
}

+ (id<OHHTTPStubsDescriptor>)dvs_stubUserRemindPasswordRequestsWithOptions:(NSDictionary *)options {
    NSString *path = DVSHTTPClientDefaultRemindPasswordPath;
    options = [self dvs_optionsDictionaryForReceivedOptions:options defaultOptions:@{
        DVSHTTPStubsAllowedMethodsKey: @[ @"POST" ],
    }];
    return [self dvs_stubRequestsForPath:path options:options response:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithData:nil statusCode:204 headers:nil];
    }];
}

#pragma mark - General stubs

+ (id<OHHTTPStubsDescriptor>)dvs_stubRequestsForPath:(NSString *)path options:(NSDictionary *)options response:(OHHTTPStubsResponseBlock)response {
    if (options[DVSHTTPStubsNumberOfFailuresKey] != nil) {
        NSUInteger numberOfFailures = [options[DVSHTTPStubsNumberOfFailuresKey] unsignedIntegerValue];
        [self dvs_setRemainingNumberOfFailures:numberOfFailures forPath:path];
    }
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
        return [self dvs_throttleResponseForPath:path request:request response:response];
    }];
}

#pragma mark - Failures management

+ (void)dvs_resetRemainingNumberOfFailuresForPath:(NSString *)path {
    NSArray *requests = [self.dvs_remainingNumberOfFailuresRegistry.allKeys copy];
    for (NSURLRequest *request in requests) {
        if ([[request.URL.path substringFromIndex:1] isEqualToString:path]) {
            [self.dvs_remainingNumberOfFailuresRegistry removeObjectForKey:request];
        }
    }
}

+ (NSMutableDictionary *)dvs_remainingNumberOfFailuresRegistry {
    static NSMutableDictionary *registry = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        registry = [NSMutableDictionary dictionary];
    });
    return registry;
}

+ (void)dvs_setRemainingNumberOfFailures:(NSUInteger)failuresCount forPath:(NSString *)path {
    self.dvs_remainingNumberOfFailuresRegistry[path] = @(failuresCount);
}

+ (NSUInteger)dvs_remainingNumberOfFailuresForPath:(NSString *)path {
    return [self.dvs_remainingNumberOfFailuresRegistry[path] unsignedIntegerValue];
}

+ (void)dvs_decrementRemainingNumberOfFailuresForPath:(NSString *)path {
    NSUInteger remaining = [self.dvs_remainingNumberOfFailuresRegistry[path] unsignedIntegerValue] - 1;
    [self dvs_setRemainingNumberOfFailures:remaining forPath:path];
}

+ (OHHTTPStubsResponse *)dvs_throttleResponseForPath:(NSString *)path request:(NSURLRequest *)request response:(OHHTTPStubsResponseBlock)response {
    if ([self dvs_remainingNumberOfFailuresForPath:path] > 0) {
        [self dvs_decrementRemainingNumberOfFailuresForPath:path];
        NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:kCFURLErrorNotConnectedToInternet userInfo:nil];
        return [OHHTTPStubsResponse responseWithError:error];
    } else {
        [self.dvs_remainingNumberOfFailuresRegistry removeObjectForKey:path];
        return response(request);
    }
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
