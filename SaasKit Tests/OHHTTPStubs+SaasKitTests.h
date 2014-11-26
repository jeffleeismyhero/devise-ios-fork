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
/// - allowedUsername (NSString *)
/// - allowedPassword (NSString *)
///
/// If provided with both allowedEmail and allowedUsername, this method will
/// prefer email over username.
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

@end
