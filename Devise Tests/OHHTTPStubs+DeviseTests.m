//
//  OHHTTPStubs+DeviseTests.m
//  
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "OHHTTPStubs+DeviseTests.h"
#import <OHHTTPStubs/OHHTTPStubsResponse+JSON.h>

NSString * const DVSHTTPStubsAllowedLoginCredentialsKey = @"DVSHTTPStubsAllowedLoginCredentialsKey";
NSString * const DVSHTTPStubsAllowedMethodsKey = @"DVSHTTPStubsAllowedMethodsKey";
NSString * const DVSHTTPStubsNumberOfFailuresKey = @"DVSHTTPStubsNumberOfFailuresKey";

@implementation OHHTTPStubs (DeviseTests)

#pragma mark Specific stubs

+ (id<OHHTTPStubsDescriptor>)dvs_stubLoginRequestsWithOptions:(NSDictionary *)options {
    options = [self dvs_optionsDictionaryForReceivedOptions:options defaultOptions:@{
        DVSHTTPStubsAllowedMethodsKey: @[ @"POST" ],
    }];
    return [self dvs_stubRequestsForPath:@"login" options:options response:^OHHTTPStubsResponse *(NSURLRequest *request) {
        NSDictionary *postData = [self dvs_postJSONObjectForRequest:request];
        if (options[DVSHTTPStubsAllowedLoginCredentialsKey] != nil) {
            NSDictionary *allowedCredentials = options[DVSHTTPStubsAllowedLoginCredentialsKey];
            if (![allowedCredentials[postData[@"email"]] isEqualToString:postData[@"password"]]) {
                return [self dvs_responseWithJSON:@{ @"error": @{} } statusCode:401];
            }
        }
        return [self dvs_responseWithJSON:@{ @"user": @{} } statusCode:200];
    }];
}

#pragma mark General stubs

+ (id<OHHTTPStubsDescriptor>)dvs_stubRequestsForPath:(NSString *)path options:(NSDictionary *)options response:(OHHTTPStubsResponseBlock)response {
    if (options[DVSHTTPStubsNumberOfFailuresKey] != nil) {
        NSUInteger numberOfFailures = [options[DVSHTTPStubsNumberOfFailuresKey] unsignedIntegerValue];
        [self dvs_setRemainingNumberOfFailures:numberOfFailures forPath:path];
    }
    return [self stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        if (![request.URL.pathComponents[1] isEqualToString:path]) {
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

#pragma mark Failures management

+ (void)dvs_resetRemainingNumberOfFailuresForPath:(NSString *)path {
    NSArray *requests = [self.dvs_remainingNumberOfFailuresRegistry.allKeys copy];
    for (NSURLRequest *request in requests) {
        if ([request.URL.pathComponents[1] isEqualToString:path]) {
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

#pragma mark Convenience methods

+ (OHHTTPStubsResponse *)dvs_responseWithJSON:(id)jsonObject statusCode:(int)statusCode {
    return [OHHTTPStubsResponse responseWithJSONObject:jsonObject statusCode:statusCode headers:nil];
}

+ (NSDictionary *)dvs_optionsDictionaryForReceivedOptions:(NSDictionary *)options defaultOptions:(NSDictionary *)defaults {
    NSMutableDictionary *mutableOptions = [options mutableCopy];
    [defaults enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (mutableOptions[key] == nil) {
            mutableOptions[key] = obj;
        }
    }];
    return [mutableOptions copy];
}

+ (id)dvs_postJSONObjectForRequest:(NSURLRequest *)request {
    return [NSJSONSerialization JSONObjectWithData:request.HTTPBody options:0 error:nil];
}

@end
