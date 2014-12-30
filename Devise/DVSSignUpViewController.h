//
//  DVSSignUpViewController.h
//  Devise
//
//  Created by Wojciech Trzasko on 23.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "XLFormViewController.h"

#import "DVSUser.h"

typedef NS_OPTIONS(NSInteger, DVSSignUpFields) {
    DVSSignUpFieldEmailAndPassword           = 1 << 0,
    DVSSignUpFieldSignUpButton               = 1 << 1,
    DVSSignUpFieldDismissButton              = 1 << 2,
    DVSSignUpFieldNavigationSignUpButton     = 1 << 3,
    DVSSignUpFieldNavigationDismissButton    = 1 << 4
};

@protocol DVSSignUpViewControllerDelegate;

@interface DVSSignUpViewController : XLFormViewController

@property (weak, nonatomic) id<DVSSignUpViewControllerDelegate> delegate;

- (instancetype)initWithFields:(DVSSignUpFields)fields;

@end

@protocol DVSSignUpViewControllerDelegate <NSObject>

- (void)signUpViewController:(DVSSignUpViewController *)controller didSignUpUser:(DVSUser *)user;
- (void)signUpViewController:(DVSSignUpViewController *)controller didFailWithError:(NSError *)error;
- (void)signUpViewControllerDidCancelSignUp:(DVSSignUpViewController *)controller;

@end
