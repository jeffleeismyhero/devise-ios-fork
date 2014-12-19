//
//  AppDelegate.m
//  Devise
//
//  Created by Patryk Kaczmarek on 19.11.2014.
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import "AppDelegate.h"
#import "Devise.h"

#import "DVSDemoUser.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSString *urlString = @"https://devise-ios-rails-example.herokuapp.com";
    
    DVSConfiguration *configuration = [DVSDemoUser configuration];

    [configuration setServerURL:[NSURL URLWithString:urlString]];
    [configuration setLoggingMode:DVSLoggingModeWarning];
    [configuration setShowsNetworkActivityIndicator:YES];
    
    return YES;
}

@end
