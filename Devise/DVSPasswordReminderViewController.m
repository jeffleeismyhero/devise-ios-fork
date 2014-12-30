//
//  DVSPasswordReminderViewController.m
//  Devise
//
//  Created by Wojciech Trzasko on 29.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSPasswordReminderViewController.h"

#import "DVSBarButtonItem.h"
#import "DVSUser+Requests.h"
#import "DVSTemplatesViewsUserDataSource.h"
#import "XLFormRowDescriptor+Devise.h"
#import "XLFormSectionDescriptor+Devise.h"

@interface DVSPasswordReminderViewController ()

@property (strong, nonatomic) DVSTemplatesViewsUserDataSource *userDataSource;

@end

@implementation DVSPasswordReminderViewController

#pragma mark - Initialization

- (instancetype)init {
    DVSPasswordReminderFields defaultFields = [self defaultFields];
    if (self = [super initWithForm:[self formWithFields:defaultFields]]) {
        [self setupForFieldsOptions:defaultFields];
    }
    return self;
}

- (instancetype)initWithFields:(DVSPasswordReminderFields)fields {
    if (self = [super initWithForm:[self formWithFields:fields]]) {
        [self setupForFieldsOptions:fields];
    }
    return self;
}

- (void)setupForFieldsOptions:(DVSPasswordReminderFields)fields {
    self.userDataSource = [DVSTemplatesViewsUserDataSource new];
    
    __weak typeof(self) weakSelf = self;
    
    if ([self shouldShow:DVSPasswordReminderFieldNavigationDismissButton basedOn:fields]) {
        self.navigationItem.leftBarButtonItem = [[DVSBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil)
                                                                                 action:^(DVSBarButtonItem *sender) {
                                                                                     [weakSelf callDidCancelRemindPasswordFromDelegate];
                                                                                 }];
    }
}
                                               
- (DVSPasswordReminderFields)defaultFields {
   return DVSPasswordReminderFieldDismissButton;
}

#pragma mark - Form initialization

- (XLFormDescriptor *)formWithFields:(DVSPasswordReminderFields)fields {
    XLFormDescriptor *form = [XLFormDescriptor formDescriptorWithTitle:NSLocalizedString(@"Remind password", nil)];
    
    XLFormSectionDescriptor *section = [XLFormSectionDescriptor formSectionWithTitle:NSLocalizedString(@"Remind", nil)];
    
    __weak typeof(self) weakSelf = self;
    
    [section dvs_addEmailTextField];
    [section dvs_addProceedButtonWithTitle:NSLocalizedString(@"Remind", nil)
                                    action:^(XLFormRowDescriptor *sender) {
                                        [weakSelf performRemindAction];
                                        [weakSelf deselectFormRow:sender];
                                    }];
    
    if ([self shouldShow:DVSPasswordReminderFieldDismissButton basedOn:fields]) {
        [section dvs_addDismissButtonWithTitle:NSLocalizedString(@"Cancel", nil)
                                        action:^(XLFormRowDescriptor *sender) {
                                            [weakSelf callDidCancelRemindPasswordFromDelegate];
                                            [weakSelf deselectFormRow:sender];
                                        }];
    }
    
    [form addFormSection:section];
    
    return form;
}
                                               
#pragma mark - Actions

- (void)performRemindAction {
    NSDictionary *formValues = [self formValues];
    
    DVSUser *user = [DVSUser new];
    
    user.email = formValues[DVSFormEmailTag];
    user.dataSource = self.userDataSource;
    
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

#pragma mark - Delegete helpers

- (void)callDidCancelRemindPasswordFromDelegate {
    if ([self.delegate respondsToSelector:@selector(passwordReminderViewControllerDidCancelRemindPassword:)]) {
        [self.delegate passwordReminderViewControllerDidCancelRemindPassword:self];
    }
}

@end
