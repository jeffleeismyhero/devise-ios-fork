//
//  DVSUserViewController.m
//  Devise
//
//  Created by Wojciech Trzasko on 09.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSUserViewController.h"

@interface DVSUserViewController ()

@property (weak, nonatomic, readwrite) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic, readwrite) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic, readwrite) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic, readwrite) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic, readwrite) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic, readwrite) IBOutlet UITextField *phoneTextField;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation DVSUserViewController

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.scrollView setContentSize: self.contentView.bounds.size];
}

- (void)fillWithUser:(DVSUser *)user {
    self.usernameTextField.text = user.username;
    self.passwordTextField.text = user.password;
    self.emailTextField.text = user.email;
    self.firstNameTextField.text = user.firstName;
    self.lastNameTextField.text = user.lastName;
    self.phoneTextField.text = user.phone;
}

@end
