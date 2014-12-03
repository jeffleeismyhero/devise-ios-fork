//
//  DVSHTTPClient.h
//
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DVSConfiguration;

/// The completion block of all http requests.
///
/// @param responseObject The response object of the request, if any.
/// @param error An error that occured, if any.
typedef void (^DVSHTTPClientCompletionBlock)(id responseObject, NSError *error);

/// The DVSHTTPClient class provides a network abstraction layer.
@interface DVSHTTPClient : NSObject

/// The configuration object used to negotiate various settings.
@property (strong, nonatomic) DVSConfiguration *configuration;

// /////////////////////////////////////////////////////////////////////////////

/// Creates and returns an initialized instance of the http client.
///
/// @param configuration The configuration object to be used.
- (instancetype)initWithConfiguration:(DVSConfiguration *)configuration;

/// A shared client which uses the shared configuration object by default.
+ (instancetype)sharedClient;

// /////////////////////////////////////////////////////////////////////////////

/// Performs a GET request for a given path.
///
/// The completion block's object is a deserialized response JSON.
///
/// @param path The relative path of the request.
/// @param parameters The parameters to be included in the request.
/// @param block The completion block executed when the request finishes.
- (void)GET:(NSString *)path parameters:(NSDictionary *)parameters completion:(DVSHTTPClientCompletionBlock)block;

/// Performs a POST request for a given path.
///
/// The completion block's object is a deserialized response JSON.
///
/// @param path The relative path of the request.
/// @param parameters The parameters to be included in the request.
/// @param block The completion block executed when the request finishes.
- (void)POST:(NSString *)path parameters:(NSDictionary *)parameters completion:(DVSHTTPClientCompletionBlock)block;

// /////////////////////////////////////////////////////////////////////////////

/// Cancels and invalidates all requests.
- (void)cancelAllRequests;

@end
