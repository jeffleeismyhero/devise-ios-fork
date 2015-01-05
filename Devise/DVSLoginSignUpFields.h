//
//  DVSLoginSignUpFields.h
//  Devise
//
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

#ifndef Devise_DVSLoginSignUpFields_h
#define Devise_DVSLoginSignUpFields_h

/**
 * A bitmask specyfing elements which are enabled
 */
typedef NS_OPTIONS(NSInteger, DVSLogInSignUpFields) {
    DVSLogInSignUpFieldEmailAndPassword           = 1 << 0,
    DVSLogInSignUpFieldProceedButton              = 1 << 1,
    DVSLogInSignUpFieldDismissButton              = 1 << 2,
    DVSLogInSignUpFieldNavigationProceedButton    = 1 << 3,
    DVSLogInSignUpFieldNavigationDismissButton    = 1 << 4,
    DVSLogInSignUpFieldPasswordReminder           = 1 << 5
};

#endif
