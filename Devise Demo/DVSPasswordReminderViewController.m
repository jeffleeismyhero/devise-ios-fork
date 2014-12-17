//
//  PasswordReminderViewController.m
//  Devise
//
//  Created by Grzegorz Lesiak on 20/11/14.
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import "DVSPasswordReminderViewController.h"
#import <Devise/Devise.h>

#import "UIAlertView+Devise.h"
#import "UIApplication+Devise.h"
#import "DVSDemoUser.h"

@interface DVSPasswordReminderViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@end

@implementation DVSPasswordReminderViewController

- (IBAction)sendButtonTouched:(UIBarButtonItem *)sender {
    DVSDemoUser *user = [DVSDemoUser new];
    
    user.email = self.emailTextField.text;
    
    [UIApplication showNetworkActivity];
    [user remindPasswordWithSuccess:^{
         [self.navigationController popViewControllerAnimated:YES];
         [UIApplication hideNetworkActivity];
     } failure:^(NSError *error) {
         [[UIAlertView dvs_alertViewForError:error] show];
         [UIApplication hideNetworkActivity];
     }];
}

@end
