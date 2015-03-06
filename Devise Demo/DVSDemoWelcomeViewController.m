//
//  WelcomeViewController.m
//  Devise
//
//  Created by Grzegorz Lesiak on 20/11/14.
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import "DVSDemoWelcomeViewController.h"
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#import "DVSMacros.h"
#import "UIAlertView+DeviseDemo.h"
#import "DVSUserManager.h"
#import "DVSDemoUser.h"
#import "Devise-Prefix.pch"
#import "DVSHTTPClient+User.h"
#import "DVSOAuthJSONParameters.h"

static NSString * const DVSHomeSegue = @"DisplayHomeView";
static NSString * const DVSDefaultWelcomeCell = @"defaultCell";
static NSString * const DVSTitleForAlertCancelButton = @"Close";


@interface DVSDemoWelcomeViewController () <DVSAccountRetrieverViewControllerDelegate>

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
#if ENABLE_FACEBOOK_LOGIN
    [self addMenuEntryWithTitle:NSLocalizedString(@"Sign in using Facebook", nil)
                       subtitle:NSLocalizedString(nil, nil)
             accessibilityLabel:DVSAccessibilityLabel(@"Sign in using Facebook")
                         target:self
                         action:@selector(didSelectFacebookSigning)];
#endif
#if ENABLE_GOOGLE_LOGIN
    [self addMenuEntryWithTitle:NSLocalizedString(@"Sign in using Google", nil)
                       subtitle:NSLocalizedString(nil, nil)
             accessibilityLabel:DVSAccessibilityLabel(@"Sign in using Google")
                         target:self
                         action:@selector(didSelectGoogleSigning)];
#endif
}

#pragma mark - Menu actions

- (void)didSelectLogIn {
    
    DVSAccountRetrieverFields logInFields = DVSAccountRetrieverFieldEmailAndPassword | DVSAccountRetrieverFieldProceedButton | DVSAccountRetrieverFieldPasswordReminder;
    DVSAccountRetrieverViewController *logInController = [[DVSAccountRetrieverViewController alloc] initWithType:DVSRetrieverTypeLogIn fields:logInFields];
    
    logInController.delegate = self;
    [self.navigationController pushViewController:logInController animated:YES];
}

- (void)didSelectRegister {
    DVSAccountRetrieverFields signUpFields = DVSAccountRetrieverFieldEmailAndPassword | DVSAccountRetrieverFieldProceedButton;
    DVSAccountRetrieverViewController *signUpController = [[DVSAccountRetrieverViewController alloc] initWithType:DVSRetrieverTypeSignUp fields:signUpFields];
    
    signUpController.delegate = self;
    [self.navigationController pushViewController:signUpController animated:YES];
}

- (void)didSelectFacebookSigning {
    [[DVSUserManager defaultManager] signInUsingFacebookWithSuccess:^{
        [self moveToHomeView];
    } failure:^(NSError *error) {
        [self handleSignInWithFacebookError:error];
    }];
}

- (void)didSelectGoogleSigning {
    [self setupGoogleSharedInstance];
    [[GPPSignIn sharedInstance] authenticate];
}

#pragma mark - GPPSignInDelegate

// This method is implemented here due to the possible bug in the Google+ SDK (not 100% sure, because it's closed source). Setting [DVSUserManager sharedInstance] as an SDK's delegate doesn't work (after successfully authorization in the web browser and returning to the application in AppDelegate, Google+ SDK's delegate is set to nil, so it can't notify Devise about finishing authentication).
- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error {
    if (error) {
        [self handleSignInWithGoogleError:error];
    } else {
        GTLServicePlus *plusService = [self getGooglePlusService];
        GTLQueryPlus *query = [GTLQueryPlus queryForPeopleGetWithUserId:@"me"];
        [plusService executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLPlusPerson *person, NSError *error) {
            if (error) {
                [self handleSignInWithGoogleError:error];
            } else {
                NSDictionary *parameters = [DVSOAuthJSONParameters dictionaryForParametersWithProvider:DVSOAuthProviderGoogle oAuthToken:auth.accessToken userID:person.identifier userEmail:[GPPSignIn sharedInstance].authentication.userEmail];
                
                [[DVSUserManager defaultManager].httpClient signInUsingGoogleUser:[DVSUserManager defaultManager].user parameters:parameters success:^{
                    [self moveToHomeView];
                } failure:^(NSError *error) {
                    [self handleSignInWithGoogleError:error];
                }];
            }
        }];
    }
}

#pragma mark - Google+ SDK helpers

- (void)setupGoogleSharedInstance {
    [GPPSignIn sharedInstance].clientID = [DVSConfiguration sharedConfiguration].googleClientID;
    [GPPSignIn sharedInstance].scopes = @[ kGTLAuthScopePlusLogin, kGTLAuthScopePlusUserinfoProfile, kGTLAuthScopePlusUserinfoEmail, kGTLAuthScopePlusMe ];
    [GPPSignIn sharedInstance].shouldFetchGoogleUserID = YES;
    [GPPSignIn sharedInstance].shouldFetchGooglePlusUser = YES;
    [GPPSignIn sharedInstance].shouldFetchGoogleUserEmail = YES;
    [GPPSignIn sharedInstance].delegate = (id<GPPSignInDelegate>)[DVSUserManager defaultManager];
}

- (GTLServicePlus *)getGooglePlusService {
    GTLServicePlus* service = [[GTLServicePlus alloc] init];
    service.retryEnabled = YES;
    [service setAuthorizer:[GPPSignIn sharedInstance].authentication];
    service.apiVersion = @"v1";
    return service;
}

#pragma mark - DVSMenuTableViewController methods

- (NSString *)defaultCellId {
    return DVSDefaultWelcomeCell;
}

#pragma mark - DVSAccountRetrieverViewControllerDelegate

- (void)accountRetrieverViewController:(DVSAccountRetrieverViewController *)controller didSuccessForAction:(DVSRetrieverAction)action user:(DVSUser *)user {
    switch (action) {
        case DVSRetrieverActionLogIn:
        case DVSRetrieverActionSignUp:
            [self moveToHomeView];
            break;
            
        case DVSRetrieverActionPasswordRemind:
            [self handlePasswordRemind];
            break;
            
        default:
            break;
    }
}

- (void)accountRetrieverViewController:(DVSAccountRetrieverViewController *)controller didFailWithError:(NSError *)error forAction:(DVSRetrieverAction)action {
    switch (action) {
        case DVSRetrieverActionLogIn:
            [self handleLogInError:error];
            break;
            
        case DVSRetrieverActionSignUp:
            [self handleSignUpError:error];
            break;
            
        case DVSRetrieverActionPasswordRemind:
            [self handlePasswordRemindError:error];
            break;
    }
}

- (void)accountRetrieverViewControllerDidTapDismiss:(DVSAccountRetrieverViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Actions

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

- (void)handleSignInWithFacebookError:(NSError *)error {
    UIAlertView *errorAlert = [UIAlertView dvs_alertViewForError:error
                                    statusDescriptionsDictionary:@{ @0: NSLocalizedString(@"Facebook login failed. Setup your Facebook account in the system settings and try again.", nil) }];
    [errorAlert show];
}

- (void)handleSignInWithGoogleError:(NSError *)error {
    UIAlertView *errorAlert = [UIAlertView dvs_alertViewForError:error
                                    statusDescriptionsDictionary:@{ @0: NSLocalizedString(@"Google login failed.", nil) }];
    [errorAlert show];
}

- (void)handlePasswordRemindError:(NSError *)error {
    UIAlertView *errorAlert = [UIAlertView dvs_alertViewForError:error
                                    statusDescriptionsDictionary:@{ @404: NSLocalizedString(@"Account for given e-mail does not exist.", nil) }];
    [errorAlert show];
}

@end

