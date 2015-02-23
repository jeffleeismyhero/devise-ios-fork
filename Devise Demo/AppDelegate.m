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

#import "DVSDemoUser.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSString *urlString = @"https://devise-ios-rails-example.herokuapp.com";
    
    // For local testing purposes, you can use local rails backend from https://github.com/netguru/devise-ios-rails-example
    // NSString *urlString = @"http://127.0.0.1:3000";
    
    DVSConfiguration *configuration = [DVSDemoUser configuration];

    [configuration setServerURL:[NSURL URLWithString:urlString]];
    [configuration setApiVersion:0];
    [configuration setLoggingMode:DVSLoggingModeWarning];
    [configuration setShowsNetworkActivityIndicator:YES];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}

@end
