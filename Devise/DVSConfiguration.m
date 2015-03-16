//
//  DVSConfiguration.m
//
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "AFNetworking/AFNetworkActivityIndicatorManager.h"

#import "DVSConfiguration.h"
#import "NSURL+Devise+Private.h"

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
    self.facebookAppID = @"1555634144720689";
#ifdef DEBUG
    self.googleClientID = @"371832272280-abhaua47e4mqckj497i3ev22vooj87cn.apps.googleusercontent.com";
#else
    self.googleClientID = @"371832272280-ick7aql3kje38ivqieavam6o7am13drf.apps.googleusercontent.com";
#endif
    self.resourceName = @"users";
    self.keychainServiceName = @"co.netguru.lib.devise.keychain";
    self.loggingMode = DVSLoggingModeNone;
    self.numberOfRetries = 0;
    self.retryThresholdDuration = 0.0;
    self.rootJSONInResponse = YES;
    self.authenticationTokenName = @"authenticationToken";
    return self;
}

- (instancetype)init {
    return [self initWithServerURL:nil];
}

#pragma mark - Logging

- (void)logMessage:(NSString *)message {
    switch (self.loggingMode) {
        case DVSLoggingModeNone: default:
            break;
        case DVSLoggingModeWarning:
            NSLog(@"[DEVISE] %@", message);
            break;
        case DVSLoggingModeAssert:
            NSAssert1(NO, @"[DEVISE] %@", message);
            break;
    }
}

#pragma mark - Property accessors

- (void)setServerURL:(NSURL *)serverURL {
    if (_serverURL == serverURL) return;
    if (![serverURL dvs_hasValidSyntax]) {
        [self logMessage:[NSString stringWithFormat:@"URL \"%@\" has invalid syntax", serverURL]];
    }
    _serverURL = [serverURL copy];
}

- (NSURL *)baseURL {
    if (self.serverURL == nil) return nil;
    NSString *versionPath = (self.apiVersion == 0) ? @"" : [NSString stringWithFormat:@"v%lu", (unsigned long)self.apiVersion];
    return [[self.serverURL URLByAppendingPathComponent:versionPath] URLByAppendingPathComponent:self.resourceName];
}

@end
