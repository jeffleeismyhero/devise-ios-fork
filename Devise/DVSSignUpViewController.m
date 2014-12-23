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

static NSString * const DVSEmailTag = @"email";
static NSString * const DVSPasswordTag = @"password";
static NSString * const DVSSignUpTag = @"signUp";

@implementation DVSSignUpViewController

#pragma mark - Initialization

- (instancetype)init {
    self = [super initWithForm:[self defaultForm]];
    return self;
}

#pragma mark - Form initialization

- (XLFormDescriptor *)defaultForm {
    XLFormDescriptor *form = [XLFormDescriptor formDescriptorWithTitle:NSLocalizedString(@"Sign Up", nil)];
    
    XLFormSectionDescriptor *section = [XLFormSectionDescriptor formSectionWithTitle:NSLocalizedString(@"Sign Up", nil)];
    
    [section addFormRow:[XLFormRowDescriptor dvs_emailRowWithTag:DVSEmailTag]];
    [section addFormRow:[XLFormRowDescriptor dvs_passwordRowWithTag:DVSPasswordTag]];
    
    [section addFormRow:[XLFormRowDescriptor dvs_buttonRowWithTag:DVSSignUpTag
                                                            title:NSLocalizedString(@"Sign Up", nil)
                                                            color:[UIColor blueColor]
                                                         selector:@selector(signUpButtonTapped:)]];
    
    [form addFormSection:section];
    return form;
}

#pragma mark - UIControl events

- (void)signUpButtonTapped:(XLFormRowDescriptor *)sender {
    NSDictionary *formValues = [self formValues];
    
    DVSUser *newUser = [DVSUser new];
    
    newUser.password = formValues[DVSEmailTag];
    newUser.email = formValues[DVSPasswordTag];
    
    [newUser registerWithSuccess:^{
        if ([self.delegate respondsToSelector:@selector(signUpViewController:didSignUpUser:)]) {
            [self.delegate signUpViewController:self didSignUpUser:[DVSUser localUser]];
        }
    } failure:^(NSError *error) {
        if ([self.delegate respondsToSelector:@selector(signUpViewController:didFailedWithError:)]) {
            [self.delegate signUpViewController:self didFailedWithError:error];
        }
    }];
    
    [self deselectFormRow:sender];
}

@end
