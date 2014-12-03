//
//  OHHTTPStubs+SaasKitTests.m
//  
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "OHHTTPStubs+SaasKitTests.h"
#import <OHHTTPStubs/OHHTTPStubsResponse+JSON.h>

NSString * const SSKHTTPStubsAllowedLoginCredentialsKey = @"SSKHTTPStubsAllowedLoginCredentialsKey";
NSString * const SSKHTTPStubsAllowedMethodsKey = @"SSKHTTPStubsAllowedMethodsKey";
NSString * const SSKHTTPStubsNumberOfFailuresKey = @"SSKHTTPStubsNumberOfFailuresKey";

@implementation OHHTTPStubs (SaasKitTests)

#pragma mark Specific stubs

+ (id<OHHTTPStubsDescriptor>)ssk_stubLoginRequestsWithOptions:(NSDictionary *)options {
    options = [self ssk_optionsDictionaryForReceivedOptions:options defaultOptions:@{
        SSKHTTPStubsAllowedMethodsKey: @[ @"POST" ],
    }];
    return [self ssk_stubRequestsForPath:@"login" options:options response:^OHHTTPStubsResponse *(NSURLRequest *request) {
        NSDictionary *postData = [self ssk_postJSONObjectForRequest:request];
        if (options[SSKHTTPStubsAllowedLoginCredentialsKey] != nil) {
            NSDictionary *allowedCredentials = options[SSKHTTPStubsAllowedLoginCredentialsKey];
            if (![allowedCredentials[postData[@"email"]] isEqualToString:postData[@"password"]]) {
                return [self ssk_responseWithJSON:@{ @"error": @{} } statusCode:401];
            }
        }
        return [self ssk_responseWithJSON:@{ @"user": @{} } statusCode:200];
    }];
}

#pragma mark General stubs

+ (id<OHHTTPStubsDescriptor>)ssk_stubRequestsForPath:(NSString *)path options:(NSDictionary *)options response:(OHHTTPStubsResponseBlock)response {
    if (options[SSKHTTPStubsNumberOfFailuresKey] != nil) {
        NSUInteger numberOfFailures = [options[SSKHTTPStubsNumberOfFailuresKey] unsignedIntegerValue];
        [self ssk_setRemainingNumberOfFailures:numberOfFailures forPath:path];
    }
    return [self stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        if (![request.URL.pathComponents[1] isEqualToString:path]) {
            return NO;
        }
        if (options[SSKHTTPStubsAllowedMethodsKey]) {
            if ([options[SSKHTTPStubsAllowedMethodsKey] indexOfObject:request.HTTPMethod] == NSNotFound) {
                return NO;
            }
        }
        return YES;
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [self ssk_throttleResponseForPath:path request:request response:response];
    }];
}

#pragma mark Failures management

+ (void)ssk_resetRemainingNumberOfFailuresForPath:(NSString *)path {
    NSArray *requests = [self.ssk_remainingNumberOfFailuresRegistry.allKeys copy];
    for (NSURLRequest *request in requests) {
        if ([request.URL.pathComponents[1] isEqualToString:path]) {
            [self.ssk_remainingNumberOfFailuresRegistry removeObjectForKey:request];
        }
    }
}

+ (NSMutableDictionary *)ssk_remainingNumberOfFailuresRegistry {
    static NSMutableDictionary *registry = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        registry = [NSMutableDictionary dictionary];
    });
    return registry;
}

+ (void)ssk_setRemainingNumberOfFailures:(NSUInteger)failuresCount forPath:(NSString *)path {
    self.ssk_remainingNumberOfFailuresRegistry[path] = @(failuresCount);
}

+ (NSUInteger)ssk_remainingNumberOfFailuresForPath:(NSString *)path {
    return [self.ssk_remainingNumberOfFailuresRegistry[path] unsignedIntegerValue];
}

+ (void)ssk_decrementRemainingNumberOfFailuresForPath:(NSString *)path {
    NSUInteger remaining = [self.ssk_remainingNumberOfFailuresRegistry[path] unsignedIntegerValue] - 1;
    [self ssk_setRemainingNumberOfFailures:remaining forPath:path];
}

+ (OHHTTPStubsResponse *)ssk_throttleResponseForPath:(NSString *)path request:(NSURLRequest *)request response:(OHHTTPStubsResponseBlock)response {
    if ([self ssk_remainingNumberOfFailuresForPath:path] > 0) {
        [self ssk_decrementRemainingNumberOfFailuresForPath:path];
        NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:kCFURLErrorNotConnectedToInternet userInfo:nil];
        return [OHHTTPStubsResponse responseWithError:error];
    } else {
        [self.ssk_remainingNumberOfFailuresRegistry removeObjectForKey:path];
        return response(request);
    }
}

#pragma mark Convenience methods

+ (OHHTTPStubsResponse *)ssk_responseWithJSON:(id)jsonObject statusCode:(int)statusCode {
    return [OHHTTPStubsResponse responseWithJSONObject:jsonObject statusCode:statusCode headers:nil];
}

+ (NSDictionary *)ssk_optionsDictionaryForReceivedOptions:(NSDictionary *)options defaultOptions:(NSDictionary *)defaults {
    NSMutableDictionary *mutableOptions = [options mutableCopy];
    [defaults enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (mutableOptions[key] == nil) {
            mutableOptions[key] = obj;
        }
    }];
    return [mutableOptions copy];
}

+ (id)ssk_postJSONObjectForRequest:(NSURLRequest *)request {
    return [NSJSONSerialization JSONObjectWithData:request.HTTPBody options:0 error:nil];
}

@end
