//
//  SaasKit.h
//  SaasKit
//
//  Created by Patryk Kaczmarek on 20.11.2014.
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSKUser.h"

#define SSKFunction [NSString stringWithFormat:@"%s [Line %d] ", __PRETTY_FUNCTION__, __LINE__]

typedef NS_ENUM(NSInteger, SSKRoute) {
    //default route: login
    SSKRouteLogin = 0,
    //default route: register
    SSKRouteRegister,
    //default route: forgotPassword
    SSKRouteForgotPassword
};

typedef NS_ENUM(NSInteger, SSKLogLevel) {
    //SSKLogLevelNone will silence all warnings and errors
    SSKLogLevelNone,
    //SSKLogLevelWarning will print all warning into console
    SSKLogLevelWarning,
    //SSKLogLevelAssert will break code execution when any inconsistency appear
    SSKLogLevelAssert
};

@interface SaasKit : NSObject

@property (strong, readonly, nonatomic) NSString *serverPath;
@property (assign, nonatomic) SSKLogLevel logLevel; //default SSKLogLevelNone

#pragma mark - Initialization
/**
 *  Designed initializer for SaasKit. Sets the serverPath of application.
 *  @param serverPath Path of server for application
 */
+ (void)initializeKitWithServerPath:(NSString *)serverPath;
+ (SaasKit *)kit;

#pragma mark - Routes
+ (void)setPath:(NSString *)path forRoute:(SSKRoute)route;
+ (NSString *)pathForRoute:(SSKRoute)route;
+ (NSDictionary *)allRoutes;

#pragma mark - Logging
+ (void)setLogLevel:(SSKLogLevel)level;

/**
 *  Logs message into console using appropriate logLevel
 *  @param message  A message logged to console.
 *  @param function A place where log is declared. Pass any string if you want define place by your own or pass provided SSKFunction macro to do it automatically
 *  @param level    You can omit existing SaasKit.logLevel by passing your own SSKLogLevel.
 */
+ (void)log:(NSString *)message function:(NSString *)function level:(SSKLogLevel)level;
+ (void)log:(NSString *)message function:(NSString *)function;
+ (void)log:(NSString *)message;

@end
