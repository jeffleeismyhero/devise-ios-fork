//
//  RegistrationViewController.m
//  Devise
//
//  Created by Patryk Kaczmarek on 19.11.2014.
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import "RegistrationViewController.h"
#import <Devise/Devise.h>

#import "DVSMacros.h"
#import "DVSDemoUser.h"
#import "DVSUserViewController.h"
#import "UIAlertView+Devise.h"

static NSString * const DVSEnterSegue = @"DisplayHomeView";
static NSString * const DVSUserSegue = @"EmbedUserView";

@interface RegistrationViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewBottomConstraint;
@property (strong, nonatomic) DVSUserViewController *userViewController;

@end

@implementation RegistrationViewController

#pragma mark - Lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardSizeChanged:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardSizeChanged:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

#pragma mark - Notifications

- (void)keyboardSizeChanged:(NSNotification*)notification {
    CGRect keyboardEndFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect keyboardBeginFrame = [notification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    
    if (keyboardBeginFrame.origin.y > keyboardEndFrame.origin.y) {
        self.containerViewBottomConstraint.constant = keyboardBeginFrame.size.height;
    } else {
        self.containerViewBottomConstraint.constant = 0;
    }
}

#pragma mark - Touch

- (IBAction)signUpTouched:(UIBarButtonItem *)sender {
    DVSDemoUser *newUser = [[DVSDemoUser alloc] init];
    
    newUser.email = self.userViewController.emailTextField.text;
    newUser.password = self.userViewController.passwordTextField.text;
    newUser.username = self.userViewController.usernameTextField.text;
    newUser.firstName = self.userViewController.firstNameTextField.text;
    newUser.lastName = self.userViewController.lastNameTextField.text;
    newUser.phone = self.userViewController.phoneTextField.text;
    
    [newUser registerWithSuccess:^{
        [self performSegueWithIdentifier:DVSEnterSegue sender:self];
    } failure:^(NSError *error) {
        [[UIAlertView dvs_alertViewForError:error] show];
    }];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:DVSUserSegue]) {
        self.userViewController = (DVSUserViewController *)segue.destinationViewController;
    }
}

@end
