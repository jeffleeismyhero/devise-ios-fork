//
//  AppDelegate.m
//  Devise
//
//  Created by Patryk Kaczmarek on 19.11.2014.
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import "AppDelegate.h"
#import "Devise.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    DVSConfiguration *configuration = [DVSConfiguration sharedConfiguration];
    [configuration setServerURL:[NSURL URLWithString:@"https://devise-ios-rails-example.herokuapp.com"]];
    [configuration setApiVersion:0];
    [configuration setLoggingMode:DVSLoggingModeWarning];
    [configuration setFacebookAppID:@"1555634144720689"];
    
#ifdef DEBUG
    [configuration setGoogleClientID:@"371832272280-abhaua47e4mqckj497i3ev22vooj87cn.apps.googleusercontent.com" ];
#else
    [configuration setGoogleClientID:@"371832272280-ick7aql3kje38ivqieavam6o7am13drf.apps.googleusercontent.com"];
#endif
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[DVSUserManager defaultManager] handleURL:url sourceApplication:sourceApplication annotation:annotation];
}

@end
