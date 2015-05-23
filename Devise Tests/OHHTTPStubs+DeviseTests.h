//
//  OHHTTPStubs+DeviseTests.h
//
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OHHTTPStubs/OHHTTPStubs.h>

/**
 *  Allowed HTTP verbs of the request.
 *
 *  The value is an NSArray.
 */
extern NSString * const DVSHTTPStubsAllowedMethodsKey;

/**
 *  Number of server failures before a route returns a correct response.
 *
 *  The value is a NSNumber.
 */
extern NSString * const DVSHTTPStubsNumberOfFailuresKey;

/**
 *  This category provides various handy additions for testing Devise's networking mechanisms.
 */
@interface OHHTTPStubs (DeviseTests)

/**
 *  Stubs all requests for the given path.
 *
 *  @param path     The path to stub.
 *  @param options  An options dictionary containing stub configuration.
 *  @param response A response-producing block.
 *
 *  @return A stub description object.
 */
+ (id<OHHTTPStubsDescriptor>)dvs_stubRequestsForPath:(NSString *)path options:(NSDictionary *)options response:(OHHTTPStubsResponseBlock)response;

/**
 *  Resets the failure counter for requests for the given path.
 *
 *  @param path The path from which to remove failure counter.
 */
+ (void)dvs_resetRemainingNumberOfFailuresForPath:(NSString *)path;

/** Stubs all requests to the user register route.
 *
 *  @param options An options dictionary containing stub configuration.
 *
 *  @return A stub description object.
 */
+ (id<OHHTTPStubsDescriptor>)dvs_stubUserRegisterRequestsWithOptions:(NSDictionary *)options;

/** Stubs all requests to the user log in route.
 *
 *  @param options An options dictionary containing stub configuration.
 *
 *  @return A stub description object.
 */
+ (id<OHHTTPStubsDescriptor>)dvs_stubUserLogInRequestsWithOptions:(NSDictionary *)options;

/** Stubs all requests to the user update route.
 *
 *  @param options An options dictionary containing stub configuration.
 *
 *  @return A stub description object.
 */
+ (id<OHHTTPStubsDescriptor>)dvs_stubUserUpdateRequestsWithOptions:(NSDictionary *)options;

/** Stubs all requests to the user update route.
 *
 *  @param options An options dictionary containing stub configuration.
 *
 *  @return A stub description object.
 */
+ (id<OHHTTPStubsDescriptor>)dvs_stubUserDeleteRequestsWithOptions:(NSDictionary *)options;


/** Stubs all requests to the user update route.
 *
 *  @param options An options dictionary containing stub configuration.
 *
 *  @return A stub description object.
 */
+ (id<OHHTTPStubsDescriptor>)dvs_stubUserChangePasswordRequestsWithOptions:(NSDictionary *)options;


/** Stubs all requests to the user update route.
 *
 *  @param options An options dictionary containing stub configuration.
 *
 *  @return A stub description object.
 */
+ (id<OHHTTPStubsDescriptor>)dvs_stubUserRemindPasswordRequestsWithOptions:(NSDictionary *)options;

/** Stubs all requests to the user log in route with specified response root.
 *
 *  @param options An options dictionary containing stub configuration.
 *
 *  @return A stub description object.
 */
+ (id<OHHTTPStubsDescriptor>)dvs_stubUserLogInRequestsWithOptions:(NSDictionary *)options remoteRoot:(NSString *)remoteRoot;

@end
