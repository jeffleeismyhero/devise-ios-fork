//
//  DVSPasswordReminderViewController.m
//  Devise
//
//  Created by Wojciech Trzasko on 29.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSPasswordReminderViewController.h"

#import "DVSUser+Requests.h"
#import "XLFormRowDescriptor+Devise.h"
#import "XLFormSectionDescriptor+Devise.h"

@implementation DVSPasswordReminderViewController

- (instancetype)init {
    self = [super initWithForm:[self defaultForm]];
    return self;
}

- (XLFormDescriptor *)defaultForm {
    XLFormDescriptor *form = [XLFormDescriptor formDescriptorWithTitle:NSLocalizedString(@"Remind password", nil)];
    
    XLFormSectionDescriptor *section = [XLFormSectionDescriptor formSectionWithTitle:NSLocalizedString(@"Remind", nil)];
    
    __weak typeof(self) weakSelf = self;
    
    [section dvs_addEmailTextField];
    [section dvs_addProceedButtonWithTitle:NSLocalizedString(@"Remind", nil)
                                    action:^(XLFormRowDescriptor *sender) {
                                        [weakSelf performRemindAction];
                                        [weakSelf deselectFormRow:sender];
                                    }];
    [section dvs_addDismissButtonWithTitle:NSLocalizedString(@"Cancel", nil)
                                    action:^(XLFormRowDescriptor *sender) {
                                        [weakSelf dismissViewControllerAnimated:YES completion:nil];
                                        [weakSelf deselectFormRow:sender];
                                    }];
    
    [form addFormSection:section];
    
    return form;
}

#pragma mark - Actions

- (void)performRemindAction {
    NSDictionary *formValues = [self formValues];
    
    DVSUser *user = [DVSUser new];
    
    user.email = formValues[DVSFormEmailTag];
    
    [user remindPasswordWithSuccess:^{
        if ([self.delegate respondsToSelector:@selector(passwordReminderViewControllerDidRemindPassword:)]) {
            [self.delegate passwordReminderViewControllerDidRemindPassword:self];
        }
    } failure:^(NSError *error) {
        if ([self.delegate respondsToSelector:@selector(passwordReminderViewController:didFailWithError:)]) {
            [self.delegate passwordReminderViewController:self didFailWithError:error];
        }
    }];
}

@end
