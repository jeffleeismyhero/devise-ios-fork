//
//  DVSLogInViewController.m
//  Devise
//
//  Created by Wojciech Trzasko on 22.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSLogInViewController.h"

#import "DVSUser+Requests.h"

@implementation DVSLogInViewController

static NSString * const DVSEmailTag = @"email";
static NSString * const DVSPasswordTag = @"password";
static NSString * const DVSLogInTag = @"login";

#pragma mark - Initialization

- (instancetype)init {
    self = [super initWithForm:[self defaultForm]];
    return self;
}

#pragma mark - Form initialization

- (XLFormDescriptor *)defaultForm {
    XLFormDescriptor *form = [XLFormDescriptor formDescriptorWithTitle:NSLocalizedString(@"Log In", nil)];
    
    XLFormSectionDescriptor *section = [XLFormSectionDescriptor formSectionWithTitle:NSLocalizedString(@"Log In", nil)];
    [section addFormRow:[XLFormRowDescriptor formRowDescriptorWithTag:DVSEmailTag
                                                              rowType:XLFormRowDescriptorTypeEmail
                                                                title:NSLocalizedString(@"E-mail", nil)]];
    [section addFormRow:[XLFormRowDescriptor formRowDescriptorWithTag:DVSPasswordTag
                                                              rowType:XLFormRowDescriptorTypePassword
                                                                title:NSLocalizedString(@"Password", nil)]];
    
    XLFormRowDescriptor *logInButtonRow = [XLFormRowDescriptor formRowDescriptorWithTag:DVSLogInTag
                                                                                rowType:XLFormRowDescriptorTypeButton
                                                                                  title:NSLocalizedString(@"Log In", nil)];
    logInButtonRow.action.formSelector = @selector(logInButtonTapped:);
    [section addFormRow:logInButtonRow];
    
    [form addFormSection:section];
    
    return form;
}

#pragma mark - UIControl events

- (void)logInButtonTapped:(XLFormRowDescriptor *)sender {
    NSDictionary *formValues = [self formValues];
    
    DVSUser *user = [DVSUser new];
    user.email = formValues[DVSEmailTag];
    user.password = formValues[DVSPasswordTag];
    
    [user loginWithSuccess:^{
        if ([self.delegate respondsToSelector:@selector(logInViewController:didLogInUser:)]) {
            [self.delegate logInViewController:self didLogInUser:[DVSUser localUser]];
        }
    } failure:^(NSError *error) {
        if ([self.delegate respondsToSelector:@selector(logInViewController:didFailedWithError:)]) {
            [self.delegate logInViewController:self didFailedWithError:error];
        }
    }];
    
    [self deselectFormRow:sender];
}

@end
