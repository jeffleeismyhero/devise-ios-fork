//
//  DVSLoginSignUpFormViewController.m
//  Devise
//
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSLoginSignUpFormViewController.h"

#import "DVSAccessibilityLabels.h"
#import "DVSFieldsUtils.h"
#import "XLFormRowDescriptor+Devise.h"
#import "XLFormSectionDescriptor+Devise.h"

@implementation DVSLoginSignUpFormViewController

#pragma mark - Initialization

- (instancetype)initWithFields:(DVSLogInSignUpFields)fields andProceedTitle:(NSString *)proceedTitle proceedAccessibilityLabel:(NSString *)accessibilityLabel {
    self = [super initWithForm:[self formWithFields:fields andProceedTitle:proceedTitle proceedAccessibilityLabel:accessibilityLabel]];
    return self;
}

#pragma mark - Form creation

- (XLFormDescriptor *)formWithFields:(DVSLogInSignUpFields)fields andProceedTitle:(NSString *)proceedTitle proceedAccessibilityLabel:(NSString *)accessibilityLabel {
    XLFormDescriptor *form = [XLFormDescriptor formDescriptor];
    
    XLFormSectionDescriptor *section = [XLFormSectionDescriptor formSectionWithTitle:proceedTitle];
    
    if ([DVSFieldsUtils shouldShow:DVSLogInSignUpFieldEmailAndPassword basedOn:fields]) {
        [section dvs_addEmailAndPasswordTextFields];
    }
    
    __weak typeof(self) weakSelf = self;
    
    if ([DVSFieldsUtils shouldShow:DVSLogInSignUpFieldProceedButton basedOn:fields]) {
        [section dvs_addProceedButtonWithTitle:proceedTitle
                            accessibilityLabel:accessibilityLabel
                                        action:^(XLFormRowDescriptor *sender) {
                                            if ([weakSelf.delegate respondsToSelector:@selector(logInSignUpFormViewController:didSelectProceedRow:)]) {
                                                [weakSelf.delegate logInSignUpFormViewController:weakSelf didSelectProceedRow:sender];
                                            }
                                            [weakSelf deselectFormRow:sender];
                                        }];
    }
    
    if ([DVSFieldsUtils shouldShow:DVSLogInSignUpFieldPasswordReminder basedOn:fields]) {
        [section dvs_addPresentButtonWithTitle:NSLocalizedString(@"Remind password", nil)
                            accessibilityLabel:NSLocalizedString(DVSAccessibilityLabelMoveToPasswordRemindButton, nil)
                                        action:^(XLFormRowDescriptor *sender) {
                                            if ([weakSelf.delegate respondsToSelector:@selector(logInSignUpFormViewController:didSelectPresentRow:)]) {
                                                [weakSelf.delegate logInSignUpFormViewController:weakSelf didSelectPresentRow:sender];
                                            }
                                            [weakSelf deselectFormRow:sender];
                                        }];
    }
    
    if ([DVSFieldsUtils shouldShow:DVSLogInSignUpFieldDismissButton basedOn:fields]) {
        [section dvs_addDismissButtonWithAction:^(XLFormRowDescriptor *sender) {
            if ([weakSelf.delegate respondsToSelector:@selector(logInSignUpFormViewController:didSelectDismissRow:)]) {
                [weakSelf.delegate logInSignUpFormViewController:weakSelf didSelectDismissRow:sender];
            }
            [weakSelf deselectFormRow:sender];
        }];
    }
    
    [form addFormSection:section];
    
    
    return form;
}

@end


