//
//  UIApplication+Devise.m
//  Devise
//
//  Created by Wojciech Trzasko on 17.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "UIApplication+Devise.h"

@implementation UIApplication (Devise)

+ (void)showNetworkActivity {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

+ (void)hideNetworkActivity {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

@end
