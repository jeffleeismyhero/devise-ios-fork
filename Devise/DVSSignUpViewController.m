//
//  DVSSignUpViewController.m
//  Devise
//
//  Created by Wojciech Trzasko on 23.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSSignUpViewController.h"

#import "DVSBarButtonItem.h"
#import "DVSFieldsUtils.h"
#import "DVSUser+Requests.h"
#import "DVSTemplatesViewsUserDataSource.h"
#import "XLFormSectionDescriptor+Devise.h"
#import "XLFormRowDescriptor+Devise.h"

@interface DVSSignUpViewController ()

@property (strong, nonatomic) DVSTemplatesViewsUserDataSource *userDataSource;

@end

@implementation DVSSignUpViewController

#pragma mark - Initialization

- (instancetype)init {
    DVSSignUpFields defaultFields = [self defaultFields];
    if (self = [super initWithForm:[self formWithFields:defaultFields]]) {
        [self setupForFieldsOptions:defaultFields];
    }
    return self;
}

- (instancetype)initWithFields:(DVSSignUpFields)fields {
    if (self = [super initWithForm:[self formWithFields:fields]]) {
        [self setupForFieldsOptions:fields];
    }
    return self;
}

- (void)setupForFieldsOptions:(DVSSignUpFields)fields {
    self.userDataSource = [DVSTemplatesViewsUserDataSource new];
    
    __weak typeof(self) weakSelf = self;
    
    if ([DVSFieldsUtils shouldShow:DVSSignUpFieldNavigationSignUpButton basedOn:fields]) {
        self.navigationItem.leftBarButtonItem = [[DVSBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Sign Up", nil)
                                                                                 action:^(DVSBarButtonItem *sender) {
                                                                                     [weakSelf performSignUpAction];
                                                                                 }];
    }
    
    if ([DVSFieldsUtils shouldShow:DVSSignUpFieldNavigationDismissButton basedOn:fields]) {
        self.navigationItem.rightBarButtonItem = [[DVSBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil)
                                                                                  action:^(DVSBarButtonItem *sender) {
                                                                                      [weakSelf callCancelSignUpFromDelegate];
                                                                                  }];
    }
}

- (DVSSignUpFields)defaultFields {
    return DVSSignUpFieldEmailAndPassword | DVSSignUpFieldSignUpButton;
}

#pragma mark - Form initialization

- (XLFormDescriptor *)formWithFields:(DVSSignUpFields)fields {
    XLFormDescriptor *form = [XLFormDescriptor formDescriptorWithTitle:NSLocalizedString(@"Sign Up", nil)];
    
    XLFormSectionDescriptor *section = [XLFormSectionDescriptor formSectionWithTitle:NSLocalizedString(@"Sign Up", nil)];
    
    if ([DVSFieldsUtils shouldShow:DVSSignUpFieldEmailAndPassword basedOn:fields]) {
        [section dvs_addEmailAndPasswordTextFields];
    }
    
    __weak typeof(self) weakSelf = self;
    if ([DVSFieldsUtils shouldShow:DVSSignUpFieldSignUpButton basedOn:fields]) {
        [section dvs_addProceedButtonWithTitle:NSLocalizedString(@"Sign Up", nil)
                                        action:^(XLFormRowDescriptor *sender) {
                                            [weakSelf performSignUpAction];
                                            [weakSelf deselectFormRow:sender];
                                        }];
    }
    
    if ([DVSFieldsUtils shouldShow:DVSSignUpFieldDismissButton basedOn:fields]) {
        [section dvs_addDismissButtonWithAction:^(XLFormRowDescriptor *sender) {
            [weakSelf callCancelSignUpFromDelegate];
            [weakSelf deselectFormRow:sender];
        }];
    }
    
    [form addFormSection:section];
    return form;
}

#pragma mark - Actions

- (void)performSignUpAction {
    NSDictionary *formValues = [self formValues];
    
    DVSUser *newUser = [DVSUser new];
    
    newUser.email = formValues[DVSFormEmailTag];
    newUser.password = formValues[DVSFormPasswordTag];
    newUser.dataSource = self.userDataSource;
    
    [newUser registerWithSuccess:^{
        if ([self.delegate respondsToSelector:@selector(signUpViewController:didSignUpUser:)]) {
            [self.delegate signUpViewController:self didSignUpUser:[DVSUser localUser]];
        }
    } failure:^(NSError *error) {
        if ([self.delegate respondsToSelector:@selector(signUpViewController:didFailWithError:)]) {
            [self.delegate signUpViewController:self didFailWithError:error];
        }
    }];
}

#pragma mark - Delegate helpers

- (void)callCancelSignUpFromDelegate {
    if ([self.delegate respondsToSelector:@selector(signUpViewControllerDidCancelSignUp:)]) {
        [self.delegate signUpViewControllerDidCancelSignUp:self];
    }
}

@end
