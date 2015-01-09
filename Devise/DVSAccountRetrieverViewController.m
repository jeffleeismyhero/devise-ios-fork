//
//  DVSLoginSignUpViewController.m
//  Devise
//
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSAccountRetrieverViewController.h"

#import "DVSAccessibilityLabels.h"
#import "DVSBarButtonItem.h"
#import "DVSFieldsUtils.h"
#import "DVSTemplatesViewsUserDataSource.h"
#import "DVSUser+Requests.h"
#import "DVSPasswordReminderFormViewController.h"
#import "DVSLoginSignUpFormViewController.h"
#import "UIViewController+Devise.h"
#import "XLFormSectionDescriptor+Devise.h"

@interface DVSAccountRetrieverViewController () <DVSLoginSignUpFormViewControllerDelegate, DVSPasswordReminderFormViewControllerDelegate>

@property (assign, nonatomic) DVSRetrieverType controllerType;
@property (strong, nonatomic) DVSLoginSignUpFormViewController *formViewController;
@property (strong, nonatomic) DVSTemplatesViewsUserDataSource *userDataSource;

@end

@implementation DVSAccountRetrieverViewController

#pragma mark - Initialization

- (instancetype)initWithType:(DVSRetrieverType)type fields:(DVSAccountRetrieverFields)fields {
    
    if (self = [super init]) {
        [self setupWithFieldsOptions:fields forType:type];
    }
    return self;
}

#pragma mark - Setup

- (void)setupWithFieldsOptions:(DVSAccountRetrieverFields)fields forType:(DVSRetrieverType)type {
    self.controllerType = type;
    self.userDataSource = [DVSTemplatesViewsUserDataSource new];
    
    [self setupFormViewControllerForFieldsOptions:fields];
    [self setupNavigationItemsForFieldsOptions:fields];
}

- (void)setupFormViewControllerForFieldsOptions:(DVSAccountRetrieverFields)fields {
    
    NSString *proceedTitle = [self localizedProceedButtonTitleForType:self.controllerType];
    NSString *proceedAccessibilityTitle = [self localizedProceedButtonAccessibilityTitleForType:self.controllerType];
    self.formViewController = [[DVSLoginSignUpFormViewController alloc] initWithFields:fields
                                                                       proceedTitle:proceedTitle
                                                             proceedAccessibilityLabel:proceedAccessibilityTitle];
    self.formViewController.delegate = self;
    [self attachViewController:self.formViewController];
}

- (void)setupNavigationItemsForFieldsOptions:(DVSAccountRetrieverFields)fields {
    NSString *title = [self localizedProceedButtonTitleForType:self.controllerType];
    self.navigationItem.title = title;
    
    __weak typeof(self) weakSelf = self;
    
    if ([DVSFieldsUtils shouldShow:DVSAccountRetrieverFieldDismissButton basedOn:fields]) {
        self.navigationItem.leftBarButtonItem = [[DVSBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil)
                                                                                 action:^(DVSBarButtonItem *sender) {
                                                                                     [weakSelf callFromDelegateCancel];
                                                                                 }];
    }
    
    if ([DVSFieldsUtils shouldShow:DVSAccountRetrieverFieldNavigationProceedButton basedOn:fields]) {
        self.navigationItem.rightBarButtonItem = [[DVSBarButtonItem alloc] initWithTitle:title
                                                                                  action:^(DVSBarButtonItem *sender) {
                                                                                      [weakSelf performProceedActionForType:self.controllerType];
                                                                                  }];
    }
}

- (DVSAccountRetrieverFields)defaultFields {
    return DVSAccountRetrieverFieldEmailAndPassword | DVSAccountRetrieverFieldProceedButton;
}

#pragma mark - Private

- (void)showPasswordReminder {
    DVSPasswordReminderFormViewController *passwordReminderFormController = [[DVSPasswordReminderFormViewController alloc] init];
    passwordReminderFormController.delegate = self;
    [self presentViewController:passwordReminderFormController animated:YES completion:nil];
}

#pragma mark - Type handling

DVSWorkInProgress("Move type properties to separate model class.");

- (NSString *)localizedProceedButtonTitleForType:(DVSRetrieverType)type {
    switch (type) {
        case DVSRetrieverTypeLogIn:
            return NSLocalizedString(@"Log In", nil);
        case DVSRetrieverTypeSignUp:
            return NSLocalizedString(@"Sign Up", nil);
        default:
            return NSLocalizedString(@"Proceed", nil);
    }
}

- (NSString *)localizedProceedButtonAccessibilityTitleForType:(DVSRetrieverType)type {
    switch (type) {
        case DVSRetrieverTypeLogIn:
            return NSLocalizedString(DVSAccessibilityLabelConfirmLogInButton, nil);
            
        case DVSRetrieverTypeSignUp:
            return NSLocalizedString(DVSAccessibilityLabelConfirmSignUpButton, nil);
            
        default:
            return [self localizedProceedButtonTitleForType:type];
    }
}

- (void)performProceedActionForType:(DVSRetrieverType)type {
    switch (type) {
        case DVSRetrieverTypeLogIn:
            [self performLogInActionForForm:self.formViewController];
            break;
            
        case DVSRetrieverTypeSignUp:
            [self performSignUpActionForForm:self.formViewController];
            break;
            
        default:
            break;
    }
}

#pragma mark - Actions

- (void)performLogInActionForForm:(XLFormViewController *)formViewController {
    NSDictionary *formValues = [formViewController formValues];
    
    DVSUser *user = [DVSUser new];
    
    user.email = formValues[DVSFormEmailTag];
    user.password = formValues[DVSFormPasswordTag];
    user.dataSource = self.userDataSource;
    
    __weak typeof(self) weakSelf = self;
    [user loginWithSuccess:^{
        [weakSelf callFromDelegateSuccessForAction:DVSRetrieverActionLogIn];
    } failure:^(NSError *error) {
        [weakSelf callFromDelegateFailWithError:error forAction:DVSRetrieverActionLogIn];
    }];
}

- (void)performSignUpActionForForm:(XLFormViewController *)formViewController {
    NSDictionary *formValues = [formViewController formValues];
    
    DVSUser *newUser = [DVSUser new];
    
    newUser.email = formValues[DVSFormEmailTag];
    newUser.password = formValues[DVSFormPasswordTag];
    newUser.dataSource = self.userDataSource;
    
    __weak typeof(self) weakSelf = self;
    [newUser registerWithSuccess:^{
        [weakSelf callFromDelegateSuccessForAction:DVSRetrieverActionSignUp];
    } failure:^(NSError *error) {
        [weakSelf callFromDelegateFailWithError:error forAction:DVSRetrieverActionSignUp];
    }];
}

- (void)performRemindPasswordActionForForm:(XLFormViewController *)formViewController {
    NSDictionary *formValues = [formViewController formValues];
    
    DVSUser *user = [DVSUser new];
    
    user.email = formValues[DVSFormEmailTag];
    user.dataSource = self.userDataSource;
    
    __weak typeof(self) weakSelf = self;
    [user remindPasswordWithSuccess:^{
        [weakSelf callFromDelegateSuccessForAction:DVSRetrieverActionPasswordRemind];
    } failure:^(NSError *error) {
        [weakSelf callFromDelegateFailWithError:error forAction:DVSRetrieverActionPasswordRemind];
    }];
}

#pragma mark - Delegete helpers

- (void)callFromDelegateSuccessForAction:(DVSRetrieverAction)action {
    if ([self.delegate respondsToSelector:@selector(accountRetrieverViewController:didSuccessForAction:user:)]) {
        [self.delegate accountRetrieverViewController:self
                                  didSuccessForAction:action
                                                 user:[DVSUser localUser]];
    }
}

- (void)callFromDelegateFailWithError:(NSError *)error forAction:(DVSRetrieverAction)action {
    if ([self.delegate respondsToSelector:@selector(accountRetrieverViewController:didFailWithError:forAction:)]) {
        [self.delegate accountRetrieverViewController:self
                                     didFailWithError:error
                                            forAction:action];
    }
}

- (void)callFromDelegateCancel {
    if ([self.delegate respondsToSelector:@selector(accountRetrieverViewControllerDidTapDismiss:)]) {
        [self.delegate accountRetrieverViewControllerDidTapDismiss:self];
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
    [self showPasswordReminder];
}

#pragma mark - DVSPasswordReminderFormViewControllerDelegate

- (void)passwordReminderFormViewController:(DVSPasswordReminderFormViewController *)controller didSelectProceedRow:(XLFormRowDescriptor *)row {
    [self performRemindPasswordActionForForm:controller];
}

- (void)passwordReminderFormViewController:(DVSPasswordReminderFormViewController *)controller didSelectDismissRow:(XLFormRowDescriptor *)row {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
