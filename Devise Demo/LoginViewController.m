//
//  ViewController.m
//  Devise
//
//  Created by Patryk Kaczmarek on 19.11.2014.
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import "LoginViewController.h"

static NSString * const DVSHomeSegue = @"DisplayHomeView";
static NSString * const DVSRemindPasswordSegue = @"DisplayPasswordReminderView";

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LoginViewController

- (IBAction)remindButtonTouched:(UIButton *)sender {
    [self performSegueWithIdentifier:DVSRemindPasswordSegue sender:self];
}

- (IBAction)logInTouched:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:DVSHomeSegue sender:self];
}

@end
