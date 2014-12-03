//
//  OHHTTPStubs+SaasKitTests.h
//
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OHHTTPStubs/OHHTTPStubs.h>

/// Acceptable login credentials, with emails as keys and passwords as values.
extern NSString * const SSKHTTPStubsAllowedLoginCredentialsKey; // NSDictionary

/// Allowed HTTP verbs of the request.
extern NSString * const SSKHTTPStubsAllowedMethodsKey; // NSArray

/// Number of server failures before a route returns a correct response.
extern NSString * const SSKHTTPStubsNumberOfFailuresKey; // NSNumber

// /////////////////////////////////////////////////////////////////////////////

/// This category provides various handy additions for testing SaasKit's
/// networking mechanisms.
@interface OHHTTPStubs (SaasKitTests)

/// Stubs all requests for the given path.
///
/// @param path The path to stub.
/// @param options An options dictionary containing stub configuration.
/// @param response A response-producing block.
///
/// @return A stub description object.
+ (id<OHHTTPStubsDescriptor>)ssk_stubRequestsForPath:(NSString *)path options:(NSDictionary *)options response:(OHHTTPStubsResponseBlock)response;

/// Resets the failure counter for requests for the given path.
///
/// @param path The path from which to remove failure counter.
+ (void)ssk_resetRemainingNumberOfFailuresForPath:(NSString *)path;

// /////////////////////////////////////////////////////////////////////////////

/// Stubs all requests to the login route.
///
/// @param options An options dictionary containing stub configuration.
///
/// @returns A stub description object.
+ (id<OHHTTPStubsDescriptor>)ssk_stubLoginRequestsWithOptions:(NSDictionary *)options;

@end
