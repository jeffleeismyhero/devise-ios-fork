//
//  SaasKit.h
//  SaasKit
//
//  Created by Patryk Kaczmarek on 20.11.2014.
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSKUser.h"

typedef NS_ENUM(NSInteger, SSKRoute) {
    //default route: login
    SSKRouteLogin,
    //default route: register
    SSKRouteRegister,
    //default route: forgotPassword
    SSKRouteForgotPassword
};

@interface SaasKit : NSObject

@property (strong, readonly, nonatomic) NSString *serverPath;

/*!
 Designed initializer for SaasKit. Sets the serverPath of application.
 @param serverPath Path of server for application.
 */
+ (void)initializeKitWithServerPath:(NSString *)serverPath;
+ (instancetype)kit;

+ (void)setPath:(NSString *)path forRoute:(SSKRoute)route;
+ (NSString *)pathForRoute:(SSKRoute)route;

@end
