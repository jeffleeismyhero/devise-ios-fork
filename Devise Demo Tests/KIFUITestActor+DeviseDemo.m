//
//  KIFUITestActor+DeviseDemo.m
//  Devise
//
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

#import "KIFUITestActor+DeviseDemo.h"

@implementation KIFUITestActor (DeviseDemo)

- (void)dvs_moveToSignUp {
    [self tapViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Sign up")];
}

- (void)dvs_moveToLogIn {
    [self tapViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Log in")];
}

- (void)dvs_moveBackToWelcome {
    [self tapViewWithAccessibilityLabel:@"Welcome"];
}

@end
