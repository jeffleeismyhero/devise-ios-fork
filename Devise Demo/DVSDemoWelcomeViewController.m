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

static NSString * const DVSRegisterSegue = @"DisplayRegisterView";
static NSString * const DVSLoginSegue = @"DisplayLoginView";
static NSString * const DVSHomeSegue = @"DisplayHomeView";

static NSString * const DVSDefaultWelcomeCell = @"defaultCell";

static NSString * const DVSTitleForAlertCancelButton = @"Close";

@interface DVSDemoWelcomeViewController () <DVSLogInViewControllerDelegate, DVSSignUpViewControllerDelegate>

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
                         target:self
                         action:@selector(didSelectRegister)];
    [self addMenuEntryWithTitle:NSLocalizedString(@"Log in", nil)
                       subtitle:NSLocalizedString(@"Already registered?", nil)
                         target:self
                         action:@selector(didSelectLogIn)];
}

#pragma mark - Menu actions

- (void)didSelectLogIn {
    DVSLogInFields logInFields = DVSLogInFieldEmailAndPassword | DVSLogInFieldLogInButton | DVSLogInFieldPasswordReminder;
    DVSLogInViewController *logInController = [[DVSLogInViewController alloc] initWithFields:logInFields];
    
    logInController.delegate = self;
    
    [self.navigationController pushViewController:logInController animated:YES];
}

- (void)didSelectRegister {
    DVSSignUpFields signUpFields = DVSSignUpFieldEmailAndPassword | DVSSignUpFieldSignUpButton;
    DVSSignUpViewController *signUpController = [[DVSSignUpViewController alloc] initWithFields:signUpFields];
    
    signUpController.delegate = self;
    
    [self.navigationController pushViewController:signUpController animated:YES];
}

#pragma mark - DVSMenuTableViewController methods

- (NSString *)defaultCellId {
    return DVSDefaultWelcomeCell;
}

#pragma mark - DVSLoginViewControllerDelegate

- (void)logInViewController:(DVSLogInViewController *)controller didLogInUser:(DVSUser *)user {
    [self performSegueWithIdentifier:DVSHomeSegue sender:self];
}

- (void)logInViewController:(DVSLogInViewController *)controller didFailWithError:(NSError *)error {
    UIAlertView *errorAlert = [UIAlertView dvs_alertViewForError:error
                                    statusDescriptionsDictionary:@{ @401: NSLocalizedString(@"Incorrect e-mail or password.", nil) }];
    [errorAlert show];
}

- (void)logInViewControllerDidRemindPassword:(DVSLogInViewController *)controller {
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Remind successful", nil)
                                message:NSLocalizedString(@"You will receive e-mail with instructions how to reset your password.", nil)
                               delegate:self
                      cancelButtonTitle:NSLocalizedString(DVSTitleForAlertCancelButton, nil)
                      otherButtonTitles:nil] show];
}

- (void)logInViewController:(DVSLogInViewController *)controller didFailRemindPasswordWithError:(NSError *)error {
    UIAlertView *errorAlert = [UIAlertView dvs_alertViewForError:error
                                    statusDescriptionsDictionary:@{ @404: NSLocalizedString(@"Account for given e-mail does not exist.", nil) }];
    [errorAlert show];
}

- (void)logInViewControllerDidCancelLogIn:(DVSLogInViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - DVSSignUpViewControllerDelegate

- (void)signUpViewController:(DVSSignUpViewController *)controller didSignUpUser:(DVSUser *)user {
    [self performSegueWithIdentifier:DVSHomeSegue sender:self];
}

- (void)signUpViewController:(DVSSignUpViewController *)controller didFailWithError:(NSError *)error {
    UIAlertView *errorAlert = [UIAlertView dvs_alertViewForError:error
                                    statusDescriptionsDictionary:@{ @422: NSLocalizedString(@"E-mail is already taken.", nil) }];
    [errorAlert show];
}

- (void)signUpViewControllerDidCancelSignUp:(DVSSignUpViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
