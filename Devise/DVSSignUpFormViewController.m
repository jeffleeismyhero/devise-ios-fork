//
//  DVSSignUpFormViewController.m
//  Devise
//
//  Created by Wojciech Trzasko on 30.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSSignUpFormViewController.h"

#import "DVSFieldsUtils.h"
#import "XLFormRowDescriptor+Devise.h"
#import "XLFormSectionDescriptor+Devise.h"

@implementation DVSSignUpFormViewController

#pragma mark - Initialization

- (instancetype)initWithFields:(DVSSignUpFields)fields {
    self = [super initWithForm:[self formWithFields:fields]];
    return self;
}

#pragma mark - Form creation

- (XLFormDescriptor *)formWithFields:(DVSSignUpFields)fields {
    XLFormDescriptor *form = [XLFormDescriptor formDescriptor];
    
    XLFormSectionDescriptor *section = [XLFormSectionDescriptor formSectionWithTitle:NSLocalizedString(@"Sign Up", nil)];
    
    if ([DVSFieldsUtils shouldShow:DVSSignUpFieldEmailAndPassword basedOn:fields]) {
        [section dvs_addEmailAndPasswordTextFields];
    }
    
    __weak typeof(self) weakSelf = self;
    
    if ([DVSFieldsUtils shouldShow:DVSSignUpFieldSignUpButton basedOn:fields]) {
        [section dvs_addProceedButtonWithTitle:NSLocalizedString(@"Sign Up", nil)
                                        action:^(XLFormRowDescriptor *sender) {
                                            if ([weakSelf.delegate respondsToSelector:@selector(signUpFormViewController:didSelectProceedRow:)]) {
                                                [weakSelf.delegate signUpFormViewController:self didSelectProceedRow:sender];
                                            }
                                            [weakSelf deselectFormRow:sender];
                                        }];
    }
    
    if ([DVSFieldsUtils shouldShow:DVSSignUpFieldDismissButton basedOn:fields]) {
        [section dvs_addDismissButtonWithAction:^(XLFormRowDescriptor *sender) {
            if ([weakSelf.delegate respondsToSelector:@selector(signUpFormViewController:didSelectDismissRow:)]) {
                [weakSelf.delegate signUpFormViewController:self didSelectDismissRow:sender];
            }
            [weakSelf deselectFormRow:sender];
        }];
    }
    
    [form addFormSection:section];
    return form;
}

@end
