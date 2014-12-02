//
//  SSKHTTPClient.h
//
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SSKConfiguration;

/// The completion block of all http requests.
///
/// @param responseObject The response object of the request, if any.
/// @param error An error that occured, if any.
typedef void (^SSKHTTPClientCompletionBlock)(id responseObject, NSError *error);

/// The SSKHTTPClient class provides a network abstraction layer.
@interface SSKHTTPClient : NSObject

/// The configuration object used to negotiate various settings.
@property (strong, nonatomic) SSKConfiguration *configuration;

// /////////////////////////////////////////////////////////////////////////////

/// Creates and returns an initialized instance of the http client.
///
/// @param configuration The configuration object to be used.
- (instancetype)initWithConfiguration:(SSKConfiguration *)configuration;

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
- (void)GET:(NSString *)path parameters:(NSDictionary *)parameters completion:(SSKHTTPClientCompletionBlock)block;

/// Performs a POST request for a given path.
///
/// The completion block's object is a deserialized response JSON.
///
/// @param path The relative path of the request.
/// @param parameters The parameters to be included in the request.
/// @param block The completion block executed when the request finishes.
- (void)POST:(NSString *)path parameters:(NSDictionary *)parameters completion:(SSKHTTPClientCompletionBlock)block;

// /////////////////////////////////////////////////////////////////////////////

/// Cancels and invalidates all requests.
- (void)cancelAllRequests;

@end
