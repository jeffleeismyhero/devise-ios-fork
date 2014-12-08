//
//  PasswordReminderViewController.m
//  Devise
//
//  Created by Grzegorz Lesiak on 20/11/14.
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import "PasswordReminderViewController.h"

@interface PasswordReminderViewController ()

@property (weak, nonatomic) IBOutlet UITextField *mail;

@end

@implementation PasswordReminderViewController

- (IBAction)sendButtonTouched:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
