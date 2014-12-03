//
//  OHHTTPStubs+SaasKitTests.h
//
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OHHTTPStubs/OHHTTPStubs.h>

@interface OHHTTPStubs (SaasKitTests)

/// The base server url which is captured and stubbed.
+ (NSURL *)ssk_stubURL;

/// Stubs the login route.
///
/// Options dictionary recognizes the following keys:
/// - allowedEmail (NSString *)
/// - allowedPassword (NSString *)
///
/// @param options An optional options dictionary.
///
/// @returns A description uniquely identifying the stub.
+ (id<OHHTTPStubsDescriptor>)ssk_stubLoginRouteWithOptions:(NSDictionary *)options;

/// Stubs the forgot password route.
///
/// Options dictionary recognizes the following keys:
/// - allowedEmail (NSString *)
///
/// @param options An optional options dictionary.
///
/// @returns A description uniquely identifying the stub.
+ (id<OHHTTPStubsDescriptor>)ssk_stubForgotPasswordRouteWithOptions:(NSDictionary *)options;

/// Stubs the register route.
///
/// Options dictionary doesn't recognize any keys for now.
///
///
/// @param options An optional options dictionary.
///
/// @returns A description uniquely identifying the stub.
+ (id<OHHTTPStubsDescriptor>)ssk_stubRegisterRouteWithOptions:(NSDictionary *)options;

@end
