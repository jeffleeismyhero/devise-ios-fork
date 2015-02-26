//
//  AppDelegate.m
//  Devise
//
//  Created by Patryk Kaczmarek on 19.11.2014.
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import "AppDelegate.h"
#import "Devise.h"
#import <FacebookSDK/FacebookSDK.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSString *urlString = @"https://devise-ios-rails-example.herokuapp.com";

    [[DVSConfiguration sharedConfiguration] setServerURL:[NSURL URLWithString:urlString]];
    [[DVSConfiguration sharedConfiguration] setApiVersion:0];
    [[DVSConfiguration sharedConfiguration] setLoggingMode:DVSLoggingModeWarning];
    [[DVSConfiguration sharedConfiguration] setShowsNetworkActivityIndicator:YES];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}

@end
