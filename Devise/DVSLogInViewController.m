//
//  DVSLogInViewController.m
//  Devise
//
//  Created by Wojciech Trzasko on 22.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSLogInViewController.h"

#import "DVSBarButtonItem.h"
#import "DVSTemplatesViewsUserDataSource.h"
#import "DVSUser+Requests.h"
#import "XLFormRowDescriptor+Devise.h"
#import "XLFormSectionDescriptor+Devise.h"

@interface DVSLogInViewController ()

@property (strong, nonatomic) DVSTemplatesViewsUserDataSource *userDataSource;

@end

@implementation DVSLogInViewController

#pragma mark - Initialization

- (instancetype)init {
    DVSLogInFields defaultFields = [self defaultFields];
    if (self = [super initWithForm:[self formWithFields:defaultFields]]) {
        [self setupForViews:defaultFields];
    }
    return self;
}

- (instancetype)initWithFields:(DVSLogInFields)fields {
    if (self = [super initWithForm:[self formWithFields:fields]]) {
        [self setupForViews:fields];
    }
    return self;
}

- (void)setupForViews:(DVSLogInFields)fields {
    self.userDataSource = [DVSTemplatesViewsUserDataSource new];
    
    __weak typeof(self) weakSelf = self;
    
    if ([self shouldShow:DVSLogInFieldDismissButton basedOn:fields]) {
        self.navigationItem.leftBarButtonItem = [[DVSBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil)
                                                                                 action:^(DVSBarButtonItem *sender) {
                                                                                     [weakSelf dismissViewControllerAnimated:YES completion:nil];
                                                                                 }];
    }
    
    if ([self shouldShow:DVSLogInFieldNavigationLogInButton basedOn:fields]) {
        self.navigationItem.rightBarButtonItem = [[DVSBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Log In", nil)
                                                                                  action:^(DVSBarButtonItem *sender) {
                                                                                      [weakSelf performLogInAction];
                                                                                  }];
    }
}

- (DVSLogInFields)defaultFields {
    return DVSLogInFieldEmailAndPassword | DVSLogInFieldLogInButton;
}

#pragma mark - Form initialization

- (XLFormDescriptor *)formWithFields:(DVSLogInFields)fields {
    XLFormDescriptor *form = [XLFormDescriptor formDescriptorWithTitle:NSLocalizedString(@"Log In", nil)];
    
    XLFormSectionDescriptor *section = [XLFormSectionDescriptor formSectionWithTitle:NSLocalizedString(@"Log In", nil)];
    
    if ([self shouldShow:DVSLogInFieldEmailAndPassword basedOn:fields]) {
        [section dvs_addEmailAndPasswordTextFields];
    }
    
    __weak typeof(self) weakSelf = self;

    if ([self shouldShow:DVSLogInFieldLogInButton basedOn:fields]) {
        [section dvs_addProceedButtonWithTitle:NSLocalizedString(@"Log In", nil)
                                        action:^(XLFormRowDescriptor *sender) {
                                            [weakSelf performLogInAction];
                                            [weakSelf deselectFormRow:sender];
                                        }];
    }
    
    if ([self shouldShow:DVSLogInFieldPasswordReminder basedOn:fields]) {
        [section dvs_addPresentButtonWithTitle:NSLocalizedString(@"Remind password", nil)
                                        action:^(XLFormRowDescriptor *sender) {
                                            [weakSelf performRemindPasswordAction];
                                            [weakSelf deselectFormRow:sender];
                                        }];
    }
    
    if ([self shouldShow:DVSLogInFieldDismissButton basedOn:fields]) {
        [section dvs_addDismissButtonWithAction:^(XLFormRowDescriptor *sender) {
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
            [weakSelf deselectFormRow:sender];
        }];
    }
    
    [form addFormSection:section];
    
    return form;
}

#pragma mark - Actions

- (void)performLogInAction {
    NSDictionary *formValues = [self formValues];
    
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
    // [WIP] Nothing for now
}

@end
