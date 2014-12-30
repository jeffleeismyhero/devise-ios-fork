//
//  DVSLogInFormViewController.m
//  Devise
//
//  Created by Wojciech Trzasko on 30.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSLogInFormViewController.h"

#import "DVSFieldsUtils.h"
#import "XLFormRowDescriptor+Devise.h"
#import "XLFormSectionDescriptor+Devise.h"

@implementation DVSLogInFormViewController

#pragma mark - Initialization

- (instancetype)initWithFields:(DVSLogInFields)fields {
    self = [super initWithForm:[self formWithFields:fields]];
    return self;
}

#pragma mark - Form initialization

- (XLFormDescriptor *)formWithFields:(DVSLogInFields)fields {
    XLFormDescriptor *form = [XLFormDescriptor formDescriptorWithTitle:NSLocalizedString(@"Log In", nil)];
    
    XLFormSectionDescriptor *section = [XLFormSectionDescriptor formSectionWithTitle:NSLocalizedString(@"Log In", nil)];
    
    if ([DVSFieldsUtils shouldShow:DVSLogInFieldEmailAndPassword basedOn:fields]) {
        [section dvs_addEmailAndPasswordTextFields];
    }
    
    __weak typeof(self) weakSelf = self;
    
    if ([DVSFieldsUtils shouldShow:DVSLogInFieldLogInButton basedOn:fields]) {
        [section dvs_addProceedButtonWithTitle:NSLocalizedString(@"Log In", nil)
                                        action:^(XLFormRowDescriptor *sender) {
                                            if ([weakSelf.delegate respondsToSelector:@selector(logInFormViewController:didSelectProceedRow:)]) {
                                                [weakSelf.delegate logInFormViewController:weakSelf didSelectProceedRow:sender];
                                            }
                                            [weakSelf deselectFormRow:sender];
                                        }];
    }
    
    if ([DVSFieldsUtils shouldShow:DVSLogInFieldPasswordReminder basedOn:fields]) {
        [section dvs_addPresentButtonWithTitle:NSLocalizedString(@"Remind password", nil)
                                        action:^(XLFormRowDescriptor *sender) {
                                            if ([weakSelf.delegate respondsToSelector:@selector(logInFormViewController:didSelectPresentRow:)]) {
                                                [weakSelf.delegate logInFormViewController:weakSelf didSelectPresentRow:sender];
                                            }
                                            [weakSelf deselectFormRow:sender];
                                        }];
    }
    
    if ([DVSFieldsUtils shouldShow:DVSLogInFieldDismissButton basedOn:fields]) {
        [section dvs_addDismissButtonWithAction:^(XLFormRowDescriptor *sender) {
            if ([weakSelf.delegate respondsToSelector:@selector(logInFormViewController:didSelectDismissRow:)]) {
                [weakSelf.delegate logInFormViewController:weakSelf didSelectDismissRow:sender];
            }
            [weakSelf deselectFormRow:sender];
        }];
    }
    
    [form addFormSection:section];
    
    
    return form;
}

@end
