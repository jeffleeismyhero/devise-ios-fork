//
//  DVSPasswordReminderFormViewControllers.m
//  Devise
//
//  Created by Wojciech Trzasko on 30.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSPasswordReminderFormViewController.h"

#import "DVSFieldsUtils.h"
#import "XLFormRowDescriptor+Devise.h"
#import "XLFormSectionDescriptor+Devise.h"

@implementation DVSPasswordReminderFormViewController

#pragma mark - Initialization

- (instancetype)initWithFields:(DVSPasswordReminderFields)fields {
    self = [super initWithForm:[self formWithFields:fields]];
    return self;
}

#pragma mark - Form creation

- (XLFormDescriptor *)formWithFields:(DVSPasswordReminderFields)fields {
    XLFormDescriptor *form = [XLFormDescriptor formDescriptorWithTitle:NSLocalizedString(@"Remind password", nil)];
    
    XLFormSectionDescriptor *section = [XLFormSectionDescriptor formSectionWithTitle:NSLocalizedString(@"Remind", nil)];
    
    __weak typeof(self) weakSelf = self;
    
    [section dvs_addEmailTextField];
    [section dvs_addProceedButtonWithTitle:NSLocalizedString(@"Remind", nil)
                                    action:^(XLFormRowDescriptor *sender) {
                                        if ([weakSelf.delegate respondsToSelector:@selector(passwordReminderFormViewController:didSelectProceedRow:)]) {
                                            [weakSelf.delegate passwordReminderFormViewController:self didSelectProceedRow:sender];
                                        }
                                        [weakSelf deselectFormRow:sender];
                                    }];
    
    if ([DVSFieldsUtils shouldShow:DVSPasswordReminderFieldDismissButton basedOn:fields]) {
        [section dvs_addDismissButtonWithTitle:NSLocalizedString(@"Cancel", nil)
                                        action:^(XLFormRowDescriptor *sender) {
                                            if ([weakSelf.delegate respondsToSelector:@selector(passwordReminderFormViewController:didSelectDismissRow:)]) {
                                                [weakSelf.delegate passwordReminderFormViewController:self didSelectDismissRow:sender];
                                            }
                                            [weakSelf deselectFormRow:sender];
                                        }];
    }
    
    [form addFormSection:section];
    
    return form;
}

@end
