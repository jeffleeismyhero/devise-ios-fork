//
//  SaasKit.m
//  SaasKit
//
//  Created by Patryk Kaczmarek on 20.11.2014.
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import "SaasKit.h"

@interface SaasKit ()

@property (nonatomic, strong) NSMutableDictionary *routes;

@end

@implementation SaasKit

- (instancetype)initWithServerPath:(NSString *)serverPath {
    self = [super init];
    if (self) {
        _serverPath = serverPath;
        _routes = [@{[self keyForRoute:SSKRouteLogin] : @"login",
                     [self keyForRoute:SSKRouteRegister] : @"register",
                     [self keyForRoute:SSKRouteForgotPassword] : @"forgotPassword"} mutableCopy];
    }
    return self;
}

+ (instancetype)sharedInstanceWithServerPath:(NSString *)serverPath {
    static SaasKit *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        SaasKit *saasKit = [[SaasKit alloc] initWithServerPath:serverPath];
        sharedInstance = saasKit;
    });
    
    return sharedInstance;
}

#pragma mark - Public Methods

+ (SaasKit *)kit {
    return [self sharedInstanceWithServerPath:nil];
}

+ (void)initializeKitWithServerPath:(NSString *)serverPath {
    [self sharedInstanceWithServerPath:serverPath];
}

+ (void)setPath:(NSString *)path forRoute:(SSKRoute)route {
    SaasKit *kit = [self kit];
    kit.routes[[kit keyForRoute:route]] = path;
}

+ (NSString *)pathForRoute:(SSKRoute)route {
    SaasKit *kit = [self kit];
    return kit.routes[[kit keyForRoute:route]];
}

+ (NSDictionary *)allRoutes {
    return [self kit].routes;
}

#pragma mark - Private Methods
- (NSString *)keyForRoute:(SSKRoute)route {
    return [NSString stringWithFormat:@"%d", route];
}

@end
