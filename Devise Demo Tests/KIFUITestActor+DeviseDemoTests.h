//
//  KIFUITestActor+DeviseDemoTests.h
//  Devise
//
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

#import "KIFUITestActor.h"

@interface KIFUITestActor (DeviseDemoTests)

#pragma mark - Basic actions

- (void)dvs_moveToSignUp;
- (void)dvs_moveToLogIn;
- (void)dvs_moveBackToWelcome;
- (void)dvs_closeErrorPopup;
- (void)dvs_enterValidEmail;
- (void)dvs_enterValidPassword;
- (void)dvs_tapConfirmLoginButton;

#pragma mark - Complex actions

- (void)dvs_login;

#pragma mark - Helpers

- (void)dvs_closeSoftwareKeyboard;

@end
