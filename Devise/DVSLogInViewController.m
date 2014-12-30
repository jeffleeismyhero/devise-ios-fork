//
//  DVSLogInViewController.m
//  Devise
//
//  Created by Wojciech Trzasko on 22.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSLogInViewController.h"

#import "DVSBarButtonItem.h"
#import "DVSFieldsUtils.h"
#import "DVSTemplatesViewsUserDataSource.h"
#import "DVSUser+Requests.h"
#import "DVSPasswordReminderViewController.h"
#import "DVSLogInFormViewController.h"
#import "UIViewController+Devise.h"
#import "XLFormSectionDescriptor+Devise.h"

@interface DVSLogInViewController () <DVSLogInFormViewControllerDelegate, DVSPasswordReminderViewControllerDelegate>

@property (strong, nonatomic) DVSLogInFormViewController *formViewController;
@property (strong, nonatomic) DVSTemplatesViewsUserDataSource *userDataSource;

@end

@implementation DVSLogInViewController

#pragma mark - Initialization

- (instancetype)init {
    DVSLogInFields defaultFields = [self defaultFields];
    if (self = [super init]) {
        [self setupWithFieldsOptions:defaultFields];
    }
    return self;
}

- (instancetype)initWithFields:(DVSLogInFields)fields {
    if (self = [super init]) {
        [self setupWithFieldsOptions:fields];
    }
    return self;
}

#pragma mark - Setup

- (void)setupWithFieldsOptions:(DVSLogInFields)fields {
    self.userDataSource = [DVSTemplatesViewsUserDataSource new];
    
    [self setupFormViewControllerForFieldsOptions:fields];
    [self setupNavigationItemsForFieldsOptions:fields];
}

- (void)setupFormViewControllerForFieldsOptions:(DVSLogInFields)fields {
    self.formViewController = [[DVSLogInFormViewController alloc] initWithFields:fields];
    self.formViewController.delegate = self;
    [self attachViewController:self.formViewController];
}

- (void)setupNavigationItemsForFieldsOptions:(DVSLogInFields)fields {
    self.navigationItem.title = NSLocalizedString(@"Log In", nil);
    
    __weak typeof(self) weakSelf = self;
    
    if ([DVSFieldsUtils shouldShow:DVSLogInFieldDismissButton basedOn:fields]) {
        self.navigationItem.leftBarButtonItem = [[DVSBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil)
                                                                                 action:^(DVSBarButtonItem *sender) {
                                                                                     [weakSelf callDidCancelLoginFromDelegate];
                                                                                 }];
    }
    
    if ([DVSFieldsUtils shouldShow:DVSLogInFieldNavigationLogInButton basedOn:fields]) {
        self.navigationItem.rightBarButtonItem = [[DVSBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Log In", nil)
                                                                                  action:^(DVSBarButtonItem *sender) {
                                                                                      [weakSelf performLogInAction];
                                                                                  }];
    }
}

- (DVSLogInFields)defaultFields {
    return DVSLogInFieldEmailAndPassword | DVSLogInFieldLogInButton;
}

#pragma mark - Actions

- (void)performLogInAction {
    NSDictionary *formValues = [self.formViewController formValues];
    
    DVSUser *user = [DVSUser new];
    
    user.email = formValues[DVSFormEmailTag];
    user.password = formValues[DVSFormPasswordTag];
    user.dataSource = self.userDataSource;
    
    [user loginWithSuccess:^{
        if ([self.delegate respondsToSelector:@selector(logInViewController:didLogInUser:)]) {
            [self.delegate logInViewController:self didLogInUser:[DVSUser localUser]];
        }
    } failure:^(NSError *error) {
        if ([self.delegate respondsToSelector:@selector(logInViewController:didFailWithError:)]) {
            [self.delegate logInViewController:self didFailWithError:error];
        }
    }];
}

- (void)performRemindPasswordAction {
    DVSPasswordReminderViewController *passwordReminder = [[DVSPasswordReminderViewController alloc] init];
    passwordReminder.delegate = self;
    
    [self presentViewController:passwordReminder animated:YES completion:nil];
}

#pragma mark - Delegete helpers

- (void)callDidCancelLoginFromDelegate {
    if ([self.delegate respondsToSelector:@selector(logInViewControllerDidCancelLogIn:)]) {
        [self.delegate logInViewControllerDidCancelLogIn:self];
    }
}

#pragma mark - DVSPasswordReminderViewControllerDelegate

- (void)passwordReminderViewControllerDidRemindPassword:(DVSPasswordReminderViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)passwordReminderViewControllerDidCancelRemindPassword:(DVSPasswordReminderViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)passwordReminderViewController:(DVSPasswordReminderViewController *)controller didFailWithError:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(logInViewController:didFailRemindPasswordWithError:)]) {
        [self.delegate logInViewController:self didFailRemindPasswordWithError:error];
    }
}

#pragma mark - DVSLogInFormViewControllerDelegate

- (void)logInFormViewController:(DVSLogInFormViewController *)formController didSelectProceedRow:(XLFormRowDescriptor *)row {
    [self performLogInAction];
}

- (void)logInFormViewController:(DVSLogInFormViewController *)formController didSelectDismissRow:(XLFormRowDescriptor *)row {
    [self callDidCancelLoginFromDelegate];
}

- (void)logInFormViewController:(DVSLogInFormViewController *)formController didSelectPresentRow:(XLFormRowDescriptor *)row {
    [self performRemindPasswordAction];
}

@end
