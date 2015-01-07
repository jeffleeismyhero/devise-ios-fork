//
//  WelcomeViewController.m
//  Devise
//
//  Created by Grzegorz Lesiak on 20/11/14.
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import "DVSDemoWelcomeViewController.h"

#import "DVSMacros.h"
#import "UIAlertView+DeviseDemo.h"

static NSString * const DVSHomeSegue = @"DisplayHomeView";

static NSString * const DVSDefaultWelcomeCell = @"defaultCell";

static NSString * const DVSTitleForAlertCancelButton = @"Close";

@interface DVSDemoWelcomeViewController () <DVSLogInSignUpViewControllerDelegate>

@end

@implementation DVSDemoWelcomeViewController

#pragma mark - Object lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDataSource];
}

#pragma mark - Setup

- (void)setupDataSource {
    [self addMenuEntryWithTitle:NSLocalizedString(@"Sign up", nil)
                       subtitle:NSLocalizedString(@"Create new account", nil)
             accessibilityLabel:DVSAccessibilityLabel(@"Sign up")
                         target:self
                         action:@selector(didSelectRegister)];
    [self addMenuEntryWithTitle:NSLocalizedString(@"Log in", nil)
                       subtitle:NSLocalizedString(@"Already registered?", nil)
             accessibilityLabel:DVSAccessibilityLabel(@"Log in")
                         target:self
                         action:@selector(didSelectLogIn)];
}

#pragma mark - Menu actions

- (void)didSelectLogIn {
    
    DVSLogInSignUpFields logInFields = DVSLogInSignUpFieldEmailAndPassword | DVSLogInSignUpFieldProceedButton | DVSLogInSignUpFieldPasswordReminder;
    DVSLoginSignUpViewController *logInController = [[DVSLoginSignUpViewController alloc] initAsLogInWithFields:logInFields];
    
    logInController.delegate = self;
    [self.navigationController pushViewController:logInController animated:YES];
}

- (void)didSelectRegister {
    DVSLogInSignUpFields signUpFields = DVSLogInSignUpFieldEmailAndPassword | DVSLogInSignUpFieldProceedButton;
    DVSLoginSignUpViewController *signUpController = [[DVSLoginSignUpViewController alloc] initAsSignUpWithFields:signUpFields];
    
    signUpController.delegate = self;
    [self.navigationController pushViewController:signUpController animated:YES];
}

#pragma mark - DVSMenuTableViewController methods

- (NSString *)defaultCellId {
    return DVSDefaultWelcomeCell;
}

#pragma mark - DVSLogInSignUpViewControllerDelegate

- (void)logInSingUpViewController:(DVSLoginSignUpViewController *)controller didSuccessForAction:(DVSViewControllerAction)action andUser:(DVSUser *)user {
    switch (action) {
        case DVSViewControllerActionLogIn:
        case DVSViewControllerActionSignUp:
            [self moveToHomeView];
            break;
            
        case DVSViewControllerActionPasswordRemind:
            [self handlePasswordRemind];
            break;
            
        default:
            break;
    }
}

- (void)logInSingUpViewController:(DVSLoginSignUpViewController *)controller didFailWithError:(NSError *)error forAction:(DVSViewControllerAction)action {
    switch (action) {
        case DVSViewControllerActionLogIn:
            [self handleLogInError:error];
            break;
            
        case DVSViewControllerActionSignUp:
            [self handleSignUpError:error];
            break;
            
        case DVSViewControllerActionPasswordRemind:
            [self handlePasswordRemindError:error];
            break;
    }
}

- (void)logInViewControllerDidCancel:(DVSLoginSignUpViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)moveToHomeView {
    [self performSegueWithIdentifier:DVSHomeSegue sender:self];
}

- (void)handlePasswordRemind {
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Remind successful", nil)
                                message:NSLocalizedString(@"You will receive e-mail with instructions how to reset your password.", nil)
                               delegate:self
                      cancelButtonTitle:NSLocalizedString(DVSTitleForAlertCancelButton, nil)
                      otherButtonTitles:nil] show];
}

- (void)handleLogInError:(NSError *)error {
    UIAlertView *errorAlert = [UIAlertView dvs_alertViewForError:error
                                    statusDescriptionsDictionary:@{ @401: NSLocalizedString(@"Incorrect e-mail or password.", nil) }];
    [errorAlert show];
}

- (void)handleSignUpError:(NSError *)error {
    UIAlertView *errorAlert = [UIAlertView dvs_alertViewForError:error
                                    statusDescriptionsDictionary:@{ @422: NSLocalizedString(@"E-mail is already taken.", nil) }];
    [errorAlert show];
}

- (void)handlePasswordRemindError:(NSError *)error {
    UIAlertView *errorAlert = [UIAlertView dvs_alertViewForError:error
                                    statusDescriptionsDictionary:@{ @404: NSLocalizedString(@"Account for given e-mail does not exist.", nil) }];
    [errorAlert show];
}

@end
