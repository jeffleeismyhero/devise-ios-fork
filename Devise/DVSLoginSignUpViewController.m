//
//  DVSLoginSignUpViewController.m
//  Devise
//
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSLoginSignUpViewController.h"

#import "DVSBarButtonItem.h"
#import "DVSFieldsUtils.h"
#import "DVSTemplatesViewsUserDataSource.h"
#import "DVSUser+Requests.h"
#import "DVSPasswordReminderFormViewController.h"
#import "DVSLoginSignUpFormViewController.h"
#import "UIViewController+Devise.h"
#import "XLFormSectionDescriptor+Devise.h"

@interface DVSLoginSignUpViewController () <DVSLoginSignUpFormViewControllerDelegate, DVSPasswordReminderFormViewControllerDelegate>

@property (assign, nonatomic) DVSViewControllerType controllerType;
@property (strong, nonatomic) DVSLoginSignUpFormViewController *formViewController;
@property (strong, nonatomic) DVSTemplatesViewsUserDataSource *userDataSource;

@end

@implementation DVSLoginSignUpViewController

#pragma mark - Initialization

- (instancetype)initAsLogInWithFields:(DVSLogInSignUpFields)fields {
    return [self initWithType:DVSViewControllerTypeLogIn andFields:fields];
}

- (instancetype)initAsSignUpWithFields:(DVSLogInSignUpFields)fields; {
    return [self initWithType:DVSViewControllerTypeSignUp andFields:fields];
}

- (instancetype)initWithType:(DVSViewControllerType)type andFields:(DVSLogInSignUpFields)fields {
    NSAssert(type != DVSViewControllerTypeUnknown, @"Unknown type is not supported.");
    
    if (self = [super init]) {
        [self setupWithFieldsOptions:fields forType:type];
    }
    return self;
}

#pragma mark - Setup

- (void)setupWithFieldsOptions:(DVSLogInSignUpFields)fields forType:(DVSViewControllerType)type {
    self.controllerType = type;
    self.userDataSource = [DVSTemplatesViewsUserDataSource new];
    
    [self setupFormViewControllerForFieldsOptions:fields];
    [self setupNavigationItemsForFieldsOptions:fields];
}

- (void)setupFormViewControllerForFieldsOptions:(DVSLogInSignUpFields)fields {
    
    NSString *proceedTitle = [self localizedProceedButtonTitleForType:self.controllerType];
    NSString *proceedAccessibilityTitle = [self localizedProceedButtonAccessibilityTitleForType:self.controllerType];
    self.formViewController = [[DVSLoginSignUpFormViewController alloc] initWithFields:fields
                                                                       andProceedTitle:proceedTitle
                                                             proceedAccessibilityLabel:proceedAccessibilityTitle];
    self.formViewController.delegate = self;
    [self attachViewController:self.formViewController];
}

- (void)setupNavigationItemsForFieldsOptions:(DVSLogInSignUpFields)fields {
    NSString *title = [self localizedProceedButtonTitleForType:self.controllerType];
    self.navigationItem.title = title;
    
    __weak typeof(self) weakSelf = self;
    
    if ([DVSFieldsUtils shouldShow:DVSLogInSignUpFieldDismissButton basedOn:fields]) {
        self.navigationItem.leftBarButtonItem = [[DVSBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil)
                                                                                 action:^(DVSBarButtonItem *sender) {
                                                                                     [weakSelf callFromDelegateCancel];
                                                                                 }];
    }
    
    if ([DVSFieldsUtils shouldShow:DVSLogInSignUpFieldNavigationProceedButton basedOn:fields]) {
        self.navigationItem.rightBarButtonItem = [[DVSBarButtonItem alloc] initWithTitle:title
                                                                                  action:^(DVSBarButtonItem *sender) {
                                                                                      [weakSelf performProceedActionForType:self.controllerType];
                                                                                  }];
    }
}

- (DVSLogInSignUpFields)defaultFields {
    return DVSLogInSignUpFieldEmailAndPassword | DVSLogInSignUpFieldProceedButton;
}

#pragma mark - Private

- (void)showPasswordReminder {
    DVSPasswordReminderFormViewController *passwordReminderFormController = [[DVSPasswordReminderFormViewController alloc] init];
    passwordReminderFormController.delegate = self;
    [self presentViewController:passwordReminderFormController animated:YES completion:nil];
}

#pragma mark - Type handling

DVSWorkInProgress("Move type properties to separate model class.");

- (NSString *)localizedProceedButtonTitleForType:(DVSViewControllerType)type {
    switch (type) {
        case DVSViewControllerTypeLogIn:
            return NSLocalizedString(@"Log In", nil);
        case DVSViewControllerTypeSignUp:
            return NSLocalizedString(@"Sign Up", nil);
        default:
            return NSLocalizedString(@"Proceed", nil);
    }
}

- (NSString *)localizedProceedButtonAccessibilityTitleForType:(DVSViewControllerType)type {
    switch (type) {
        case DVSViewControllerTypeLogIn:
            return NSLocalizedString(@"Confirm log in", nil);
            
        case DVSViewControllerTypeSignUp:
            return NSLocalizedString(@"Confirm sign up", nil);
            
        default:
            return [self localizedProceedButtonTitleForType:type];
    }
}

- (void)performProceedActionForType:(DVSViewControllerType)type {
    switch (type) {
        case DVSViewControllerTypeLogIn:
            [self performLogInAction];
            break;
            
        case DVSViewControllerTypeSignUp:
            [self performSignUpAction];
            break;
            
        default:
            break;
    }
}

#pragma mark - Actions

- (void)performLogInAction {
    NSDictionary *formValues = [self.formViewController formValues];
    
    DVSUser *user = [DVSUser new];
    
    user.email = formValues[DVSFormEmailTag];
    user.password = formValues[DVSFormPasswordTag];
    user.dataSource = self.userDataSource;
    
    __weak typeof(self) weakSelf = self;
    [user loginWithSuccess:^{
        [weakSelf callFromDelegateSuccessForAction:DVSViewControllerActionLogIn];
    } failure:^(NSError *error) {
        [weakSelf callFromDelegateFailWithError:error forAction:DVSViewControllerActionLogIn];
    }];
}

- (void)performSignUpAction {
    NSDictionary *formValues = [self.formViewController formValues];
    
    DVSUser *newUser = [DVSUser new];
    
    newUser.email = formValues[DVSFormEmailTag];
    newUser.password = formValues[DVSFormPasswordTag];
    newUser.dataSource = self.userDataSource;
    
    __weak typeof(self) weakSelf = self;
    [newUser registerWithSuccess:^{
        [weakSelf callFromDelegateSuccessForAction:DVSViewControllerActionSignUp];
    } failure:^(NSError *error) {
        [weakSelf callFromDelegateFailWithError:error forAction:DVSViewControllerActionSignUp];
    }];
}

- (void)performRemindPasswordAction {
    NSDictionary *formValues = [self.formViewController formValues];
    
    DVSUser *user = [DVSUser new];
    
    user.email = formValues[DVSFormEmailTag];
    user.dataSource = self.userDataSource;
    
    __weak typeof(self) weakSelf = self;
    [user remindPasswordWithSuccess:^{
        [weakSelf callFromDelegateSuccessForAction:DVSViewControllerActionPasswordRemind];
    } failure:^(NSError *error) {
        [weakSelf callFromDelegateFailWithError:error forAction:DVSViewControllerActionPasswordRemind];
    }];
}

#pragma mark - Delegete helpers

- (void)callFromDelegateSuccessForAction:(DVSViewControllerAction)action {
    if ([self.delegate respondsToSelector:@selector(logInSingUpViewController:didSuccessForAction:andUser:)]) {
        [self.delegate logInSingUpViewController:self
                             didSuccessForAction:action
                                         andUser:[DVSUser localUser]];
    }
}

- (void)callFromDelegateFailWithError:(NSError *)error forAction:(DVSViewControllerAction)action {
    if ([self.delegate respondsToSelector:@selector(logInSingUpViewController:didFailWithError:forAction:)]) {
        [self.delegate logInSingUpViewController:self
                                didFailWithError:error
                                       forAction:action];
    }
}

- (void)callFromDelegateCancel {
    if ([self.delegate respondsToSelector:@selector(logInViewControllerDidCancel:)]) {
        [self.delegate logInViewControllerDidCancel:self];
    }
}

#pragma mark - DVSLoginSignUpFormViewControllerDelegate

- (void)logInSignUpFormViewController:(DVSLoginSignUpFormViewController *)formController didSelectProceedRow:(XLFormRowDescriptor *)row {
    [self performProceedActionForType:self.controllerType];
}

- (void)logInSignUpFormViewController:(DVSLoginSignUpFormViewController *)formController didSelectDismissRow:(XLFormRowDescriptor *)row {
    [self callFromDelegateCancel];
}

- (void)logInSignUpFormViewController:(DVSLoginSignUpFormViewController *)formController didSelectPresentRow:(XLFormRowDescriptor *)row {
    [self performRemindPasswordAction];
}

#pragma mark - DVSPasswordReminderFormViewControllerDelegate

- (void)passwordReminderFormViewController:(DVSPasswordReminderFormViewController *)controller didSelectProceedRow:(XLFormRowDescriptor *)row {
    [self performRemindPasswordAction];
}

- (void)passwordReminderFormViewController:(DVSPasswordReminderFormViewController *)controller didSelectDismissRow:(XLFormRowDescriptor *)row {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
