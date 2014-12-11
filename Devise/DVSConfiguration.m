//
//  DVSConfiguration.m
//
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <AFNetworking/AFNetworkActivityIndicatorManager.h>

#import "DVSConfiguration.h"
#import "NSURL+Devise.h"

@interface DVSConfiguration ()

@property (strong, nonatomic) NSMutableDictionary *mutableRoutePaths;

@end

#pragma mark -

@implementation DVSConfiguration

#pragma mark - Initialization

+ (instancetype)sharedConfiguration {
    static dispatch_once_t onceToken;
    static DVSConfiguration *sharedConfiguration = nil;
    dispatch_once(&onceToken, ^{
        sharedConfiguration = [[self alloc] initWithServerURL:nil];
    });
    return sharedConfiguration;
}

- (instancetype)initWithServerURL:(NSURL *)serverURL {
    self = [super init];
    if (self == nil) return nil;
    self.serverURL = serverURL;
    self.apiVersion = 1;
    self.keychainServiceName = @"co.netguru.lib.devise.keychain";
    self.logLevel = DVSLogLevelNone;
    self.numberOfRetries = 0;
    self.retryTresholdDuration = 0.0;
    [self setPath:@"users" forRoute:DVSRouteUser];
    return self;
}

- (instancetype)init {
    return [self initWithServerURL:nil];
}

#pragma mark - Routes

- (NSMutableDictionary *)mutableRoutePaths {
    if (_mutableRoutePaths != nil) return _mutableRoutePaths;
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    _mutableRoutePaths = dictionary;
    return _mutableRoutePaths;
}

- (NSDictionary *)routePaths {
    return [self.mutableRoutePaths copy];
}

- (NSString *)pathForRoute:(DVSRoute)route {
    return self.mutableRoutePaths[@(route)];
}

- (void)setPath:(NSString *)path forRoute:(DVSRoute)route {
    self.mutableRoutePaths[@(route)] = path;
}

#pragma mark - Logging

- (void)logMessage:(NSString *)message {
    switch (self.logLevel) {
        case DVSLogLevelNone: default:
            break;
        case DVSLogLevelWarning:
            NSLog(@"[DEVISE] %@", message);
            break;
        case DVSLogLevelAssert:
            NSAssert1(NO, @"[DEVISE] %@", message);
            break;
    }
}

#pragma mark - Property accessors

- (void)setServerURL:(NSURL *)serverURL {
    if (_serverURL != serverURL) {
        if (![serverURL dvs_hasValidSyntax]) {
            [self logMessage:[NSString stringWithFormat:@"URL \"%@\" has invalid syntax", serverURL]];
        }
        _serverURL = serverURL;
    }
}

- (void)setShowsNetworkActivityIndicator:(BOOL)shows {
    if (_showsNetworkActivityIndicator != shows) {
        [AFNetworkActivityIndicatorManager sharedManager].enabled = shows;
        _showsNetworkActivityIndicator = shows;
    }
}

@end
