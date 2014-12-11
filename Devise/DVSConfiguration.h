//
//  DVSConfiguration.h
//
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Routes used in Devise framework.
 */
typedef NS_ENUM(NSInteger, DVSRoute) {
    DVSRouteUser = 0 /// User route (default: users).
};

/**
 *  Logging level of the Devise framework.
 */
typedef NS_ENUM(NSInteger, DVSLogLevel) {
    DVSLogLevelNone, // Don't log anything, ignore all messages.
    DVSLogLevelWarning, // Print all messages using NSLog.
    DVSLogLevelAssert, // Abort the code with the message.
};

/**
 *  The main configuration object of Devise.
 */
@interface DVSConfiguration : NSObject

/**
 *  The root URL of the server backend.
 */
@property (copy, nonatomic) NSURL *serverURL;

/**
 *  The keychain service name for local users persistence.
 */
@property (copy, nonatomic) NSString *keychainServiceName;

/**
 *  The server-side api version (default: 1).
 */
@property (assign, nonatomic) NSUInteger apiVersion;

/**
 *  The logging level of the framework (default: DVSLogLevelNone).
 */
@property (assign, nonatomic) DVSLogLevel logLevel;

/**
 *  The number of retries in case of connection issues (default: 0).
 */
@property (assign, nonatomic) NSUInteger numberOfRetries;

/**
 *  The duration (in seconds) after which a next retry happens (default: 0).
 */
@property (assign, nonatomic) NSTimeInterval retryTresholdDuration;

/**
 *  Whether the network activity indicator should be visible.
 */
@property (assign, nonatomic) BOOL showsNetworkActivityIndicator;

/**
 *  Returns a shared instance of the configuration object.
 */
+ (instancetype)sharedConfiguration;

/**
 *  Creates and returns an instance of configuration object.
 *
 *  @param serverURL The root URL of the server backend.
 *  @return Instance of DVSConfiguration
 */
- (instancetype)initWithServerURL:(NSURL *)serverURL;

/**
 *  All registered route paths.
 */
@property (strong, nonatomic, readonly) NSDictionary *routePaths;

/**
 *  Returns a path for the given route.
 *
 *  @param route The route, for which you want to get the path.
 *  @return Path for given route
 */
- (NSString *)pathForRoute:(DVSRoute)route;

/**
 *  Sets a path for the given route.
 *
 *  @param path  The path you want to set.
 *  @param route The route, for which you want to set the path.
 */
- (void)setPath:(NSString *)path forRoute:(DVSRoute)route;

/**
 *  Logs a message with the level specified by the \c logLevel property.
 *
 *  @param message The message to log.
 */
- (void)logMessage:(NSString *)message;

@end
