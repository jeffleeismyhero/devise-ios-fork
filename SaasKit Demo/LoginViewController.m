//
//  ViewController.m
//  SaasKit
//
//  Created by Patryk Kaczmarek on 19.11.2014.
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import "LoginViewController.h"
#define SSKEnterSegue @"enter"
#define SSKRemindPasswordSegue @"remind password"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end

@implementation LoginViewController

- (IBAction)remindButtonTouched:(UIButton *)sender {
    [self performSegueWithIdentifier: SSKRemindPasswordSegue sender:self];
}

- (IBAction)logInTouched:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier: SSKEnterSegue sender:self];
}

@end
