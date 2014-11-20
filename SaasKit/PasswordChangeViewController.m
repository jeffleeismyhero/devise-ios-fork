//
//  PasswordChangeViewController.m
//  SaasKit
//
//  Created by Grzegorz Lesiak on 20/11/14.
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import "PasswordChangeViewController.h"

@interface PasswordChangeViewController ()

@property (weak, nonatomic) IBOutlet UITextField *password;

@end

@implementation PasswordChangeViewController

- (IBAction)saveButtonTouched:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated: YES];
}

@end
