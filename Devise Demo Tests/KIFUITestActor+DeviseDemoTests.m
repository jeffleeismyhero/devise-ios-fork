//
//  KIFUITestActor+DeviseDemoTests.m
//  Devise
//
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

#import "KIFUITestActor+DeviseDemoTests.h"

NSString * const DVSValidEmail = @"john.appleseed@example.com";
NSString * const DVSValidPassword = @"$eCR3t";

@implementation KIFUITestActor (DeviseDemoTests)

#pragma mark - Basic actions

- (void)dvs_moveToSignUp {
    [self tapViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Sign up")];
    [self waitForViewWithAccessibilityLabel:DVSAccessibilityLabel(DVSAccessibilityLabelConfirmSignUpButton)];
}

- (void)dvs_moveToLogIn {
    [self tapViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Log in")];
    [self waitForViewWithAccessibilityLabel:DVSAccessibilityLabel(DVSAccessibilityLabelConfirmLogInButton)];
}

- (void)dvs_moveBackToWelcome {
    [self tapViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Welcome")];
    [self waitForViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Welcome")];
}

- (void)dvs_closeErrorPopup {
    [self tapViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Close")];
    [self waitForAbsenceOfViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Error")];
}

- (void)dvs_enterValidEmail {
    [self enterText:DVSValidEmail intoViewWithAccessibilityLabel:DVSAccessibilityLabel(DVSAccessibilityLabelEmailTextField)];
}

- (void)dvs_enterValidPassword {
    [self enterText:DVSValidPassword intoViewWithAccessibilityLabel:DVSAccessibilityLabel(DVSAccessibilityLabelPasswordTextField)];
}

- (void)dvs_tapLogOutButton {
    [self tapViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Log out")];
    [self waitForViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Welcome")];
}

- (void)dvs_tapConfirmLoginButton {
    [self tapViewWithAccessibilityLabel:DVSAccessibilityLabel(DVSAccessibilityLabelConfirmLogInButton)];
}

- (void)dvs_tapConfirmSignUpButton {
    [self tapViewWithAccessibilityLabel:DVSAccessibilityLabel(DVSAccessibilityLabelConfirmSignUpButton)];
}

- (void)dvs_waitForErrorView {
    [self waitForViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Error")];
}

#pragma mark - Complex actions

- (void)dvs_login {
    id<OHHTTPStubsDescriptor> loginStub = [OHHTTPStubs dvs_stubUserLogInRequestsWithOptions:nil];
    
    [self dvs_moveToLogIn];
    [self dvs_enterValidEmail];
    [self dvs_enterValidPassword];
    [self dvs_closeSoftwareKeyboard];
    [self dvs_tapConfirmLoginButton];
    
    [OHHTTPStubs removeStub:loginStub];
}

#pragma mark - Helpers

- (void)dvs_closeSoftwareKeyboard {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [self waitForAbsenceOfSoftwareKeyboard];
}

@end
