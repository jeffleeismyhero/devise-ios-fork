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
#import "DVSSignUpFormViewController.h"
#import "DVSTemplatesViewsUserDataSource.h"
#import "UIViewController+Devise.h"
#import "XLFormSectionDescriptor+Devise.h"

@interface DVSSignUpViewController () <DVSSignUpFormViewControllerDelegate>

@property (strong, nonatomic) DVSTemplatesViewsUserDataSource *userDataSource;
@property (strong, nonatomic) DVSSignUpFormViewController *formViewController;

@end

@implementation DVSSignUpViewController

#pragma mark - Initialization

- (instancetype)init {
    DVSSignUpFields defaultFields = [self defaultFields];
    if (self = [super init]) {
        [self setupWithFields:defaultFields];
    }
    return self;
}

- (instancetype)initWithFields:(DVSSignUpFields)fields {
    if (self = [super init]) {
        [self setupWithFields:fields];
    }
    return self;
}

- (void)setupWithFields:(DVSSignUpFields)fields {
    self.userDataSource = [DVSTemplatesViewsUserDataSource new];
    [self setupFormForFieldsOptions:fields];
    [self setupNavigationItemsForFieldsOptions:fields];
}

- (void)setupFormForFieldsOptions:(DVSSignUpFields)fields {
    self.formViewController = [[DVSSignUpFormViewController alloc] initWithFields:fields];
    self.formViewController.delegate = self;
    [self attachViewController:self.formViewController];
}

- (void)setupNavigationItemsForFieldsOptions:(DVSSignUpFields)fields {
    self.navigationItem.title = NSLocalizedString(@"Sign Up", nil);
    
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

#pragma mark - Actions

- (void)performSignUpAction {
    NSDictionary *formValues = [self.formViewController formValues];
    
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

#pragma mark - DVSSignUpFormViewControllerDelegate

- (void)signUpFormViewController:(DVSSignUpFormViewController *)controller didSelectProceedRow:(XLFormRowDescriptor *)row {
    [self performSignUpAction];
}

- (void)signUpFormViewController:(DVSSignUpFormViewController *)controller didSelectDismissRow:(XLFormRowDescriptor *)row {
    [self callCancelSignUpFromDelegate];
}

@end
