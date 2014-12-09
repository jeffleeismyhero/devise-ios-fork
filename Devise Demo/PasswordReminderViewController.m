//
//  PasswordReminderViewController.m
//  Devise
//
//  Created by Grzegorz Lesiak on 20/11/14.
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import "PasswordReminderViewController.h"
#import <Devise/Devise.h>

@interface PasswordReminderViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@end

@implementation PasswordReminderViewController

- (IBAction)sendButtonTouched:(UIBarButtonItem *)sender {
    [DVSUser remindPasswordWithEmail:self.emailTextField.text
                             success:^{
                                 [self.navigationController popViewControllerAnimated:YES];
                             } failure:^(NSError *error) {
                                 [[[UIAlertView alloc] initWithTitle:@"Error"
                                                             message:error.localizedDescription
                                                            delegate:nil
                                                   cancelButtonTitle:@"Close"
                                                   otherButtonTitles:nil] show];
                             }];
    
}

@end
