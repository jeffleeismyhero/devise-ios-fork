//
//  RegistrationViewController.m
//  SaasKit
//
//  Created by Patryk Kaczmarek on 19.11.2014.
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import "RegistrationViewController.h"
#import "SaasKit.h"
#import "SSKUser.h"
#import "UIView+SSKAdditions.h"

#define SSKEnterSegue @"enter"

@interface RegistrationViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewBottomConstraint;

@end

@implementation RegistrationViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(keyboardSizeChanged:)
                                                 name: UIKeyboardWillShowNotification object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(keyboardSizeChanged:)
                                                 name: UIKeyboardWillHideNotification object: nil];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.scrollView setContentSize: self.contentView.bounds.size];
}

- (void) keyboardSizeChanged: (NSNotification*) notification
{
    CGRect keyboardEndFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect keyboardBeginFrame = [notification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    
    if ( keyboardBeginFrame.origin.y>keyboardEndFrame.origin.y ) {
        self.scrollViewBottomConstraint.constant = keyboardBeginFrame.size.height;
    } else {
        self.scrollViewBottomConstraint.constant = 0;
    }
}

- (IBAction)signUpTouched:(UIBarButtonItem *)sender
{
    SSKUser * newUser = [SSKUser user];
    newUser.username = self.userName.text;
    newUser.password = self.password.text;
    newUser.firstName = self.firstName.text;
    newUser.lastName = self.lastName.text;
    newUser.phone = self.phone.text;
    [newUser signUpWithSuccess:^{
        SSKWorkInProgress( "Proceed further" );
        [self performSegueWithIdentifier: SSKEnterSegue sender:self];
    } failure:^(NSError *error) {
        [[[UIAlertView alloc] initWithTitle: @"Error" message: error.localizedDescription delegate:nil cancelButtonTitle: @"Close" otherButtonTitles: nil] show];
    }];
}

@end
