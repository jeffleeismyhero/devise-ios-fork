//
//  DVSPasswordReminderViewController.m
//  Devise
//
//  Created by Wojciech Trzasko on 29.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSPasswordReminderViewController.h"

#import "DVSBarButtonItem.h"
#import "DVSFieldsUtils.h"
#import "DVSUser+Requests.h"
#import "DVSPasswordReminderFormViewController.h"
#import "DVSTemplatesViewsUserDataSource.h"
#import "UIViewController+Devise.h"
#import "XLFormRowDescriptor+Devise.h"
#import "XLFormSectionDescriptor+Devise.h"

@interface DVSPasswordReminderViewController () <DVSPasswordReminderFormViewControllerDelegate>

@property (strong, nonatomic) DVSTemplatesViewsUserDataSource *userDataSource;
@property (strong, nonatomic) DVSPasswordReminderFormViewController *formViewController;

@end

@implementation DVSPasswordReminderViewController

#pragma mark - Initialization

- (instancetype)init {
    DVSPasswordReminderFields defaultFields = [self defaultFields];
    if (self = [super init]) {
        [self setupWithFields:defaultFields];
    }
    return self;
}

- (instancetype)initWithFields:(DVSPasswordReminderFields)fields {
    if (self = [super init]) {
        [self setupWithFields:fields];
    }
    return self;
}

#pragma mark - Setup

- (void)setupWithFields:(DVSPasswordReminderFields)fields {
    self.userDataSource = [DVSTemplatesViewsUserDataSource new];
    [self setupFormForFieldsOptions:fields];
    [self setupNavigationItemsForFieldsOptions:fields];
}

- (void)setupFormForFieldsOptions:(DVSPasswordReminderFields)fields {
    self.formViewController = [[DVSPasswordReminderFormViewController alloc] initWithFields:fields];
    self.formViewController.delegate = self;
    [self attachViewController:self.formViewController];
}

- (void)setupNavigationItemsForFieldsOptions:(DVSPasswordReminderFields)fields {
    self.navigationItem.title = NSLocalizedString(@"Remind password", nil);
    
    __weak typeof(self) weakSelf = self;
    
    if ([DVSFieldsUtils shouldShow:DVSPasswordReminderFieldNavigationDismissButton basedOn:fields]) {
        self.navigationItem.leftBarButtonItem = [[DVSBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil)
                                                                                 action:^(DVSBarButtonItem *sender) {
                                                                                     [weakSelf callDidCancelRemindPasswordFromDelegate];
                                                                                 }];
    }
}
                                               
- (DVSPasswordReminderFields)defaultFields {
   return DVSPasswordReminderFieldDismissButton;
}
                                               
#pragma mark - Actions

- (void)performRemindAction {
    NSDictionary *formValues = [self.formViewController formValues];
    
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

#pragma mark - DVSPasswordReminderFormViewControllerDelegate

- (void)passwordReminderFormViewController:(DVSPasswordReminderFormViewController *)controller didSelectProceedRow:(XLFormRowDescriptor *)row {
    [self performRemindAction];
}

- (void)passwordReminderFormViewController:(DVSPasswordReminderFormViewController *)controller didSelectDismissRow:(XLFormRowDescriptor *)row {
    [self callDidCancelRemindPasswordFromDelegate];
}

@end
