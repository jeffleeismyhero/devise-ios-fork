//
//  DVSSignUpViewController.m
//  Devise
//
//  Created by Wojciech Trzasko on 23.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSSignUpViewController.h"

#import "DVSUser+Requests.h"
#import "XLFormRowDescriptor+Devise.h"

@implementation DVSSignUpViewController

#pragma mark - Initialization

- (instancetype)init {
    DVSSignUpViewsOptions defaultOptions = [self defaultOptions];
    if (self = [super initWithForm:[self formForOptions:defaultOptions]]) {
        [self setupForViews:defaultOptions];
    }
    return self;
}

- (instancetype)initWithViewsOptions:(DVSSignUpViewsOptions)viewsOptions {
    if (self = [super initWithForm:[self formForOptions:viewsOptions]]) {
        [self setupForViews:viewsOptions];
    }
    return self;
}

- (void)setupForViews:(DVSSignUpViewsOptions)viewsOptions {
    __weak typeof(self) weakSelf = self;
    
    if ([self shouldShow:DVSSignUpViewsNavigationSignUpButton basedOn:viewsOptions]) {
        [self setupLeftNavigationBarButtonWithTitle:NSLocalizedString(@"Sign Up", nil)
                                             action:^{
                                                 [weakSelf performSignUpAction];
                                             }];
    }
    
    if ([self shouldShow:DVSSignUpViewsNavigationDismissButton basedOn:viewsOptions]) {
        [self setupRightNavigationBarButtonWithTitle:NSLocalizedString(@"Cancel", nil)
                                              action:^{
                                                  [weakSelf dismissViewControllerAnimated:YES completion:nil];
                                              }];
    }
}

- (DVSSignUpViewsOptions)defaultOptions {
    return DVSSignUpViewsEmailAndPassword | DVSSignUpViewsSignUpButton;
}

#pragma mark - Form initialization

- (XLFormDescriptor *)formForOptions:(DVSSignUpViewsOptions)viewsOptions {
    XLFormDescriptor *form = [XLFormDescriptor formDescriptorWithTitle:NSLocalizedString(@"Sign Up", nil)];
    
    XLFormSectionDescriptor *section = [XLFormSectionDescriptor formSectionWithTitle:NSLocalizedString(@"Sign Up", nil)];
    
    if ([self shouldShow:DVSSignUpViewsEmailAndPassword basedOn:viewsOptions]) {
        [self addEmailAndPasswordToSection:section];
    }
    
    __weak typeof(self) weakSelf = self;
    if ([self shouldShow:DVSSignUpViewsSignUpButton basedOn:viewsOptions]) {
        [self addProceedButtonToSection:section
                                  title:NSLocalizedString(@"Sign Up", nil)
                                 action:^() {
                                     [weakSelf performSignUpAction];
                                 }];
    }
    
    if ([self shouldShow:DVSSignUpViewsDismissButton basedOn:viewsOptions]) {
        [self addDismissButtonToSection:section
                                  title:NSLocalizedString(@"Cancel", nil)
                                 action:^{
                                     [weakSelf dismissViewControllerAnimated:YES completion:nil];
                                 }];
    }
    
    [form addFormSection:section];
    return form;
}

#pragma mark - Actions

- (void)performSignUpAction {
    NSDictionary *formValues = [self formValues];
    
    DVSUser *newUser = [DVSUser new];
    
    newUser.password = formValues[DVSFormEmailTag];
    newUser.email = formValues[DVSFormPasswordTag];
    
    [newUser registerWithSuccess:^{
        if ([self.delegate respondsToSelector:@selector(signUpViewController:didSignUpUser:)]) {
            [self.delegate signUpViewController:self didSignUpUser:[DVSUser localUser]];
        }
    } failure:^(NSError *error) {
        if ([self.delegate respondsToSelector:@selector(signUpViewController:didFailWithError:)]) {
            [self.delegate signUpViewController:self didFailWithError:error];
        }
    }];
}

@end
