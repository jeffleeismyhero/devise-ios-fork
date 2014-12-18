//
//  PasswordReminderViewController.m
//  Devise
//
//  Created by Grzegorz Lesiak on 20/11/14.
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import "DVSPasswordReminderViewController.h"
#import <Devise/Devise.h>

#import "UIAlertView+DeviseDemo.h"
#import "DVSDemoUser.h"

@interface DVSPasswordReminderViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@end

@implementation DVSPasswordReminderViewController

- (IBAction)sendButtonTouched:(UIBarButtonItem *)sender {
    DVSDemoUser *user = [DVSDemoUser new];
    
    user.email = self.emailTextField.text;
    
    [user remindPasswordWithSuccess:^{
         [self.navigationController popViewControllerAnimated:YES];
     } failure:^(NSError *error) {
         UIAlertView *errorAlert = [UIAlertView dvs_alertViewForError:error
                                         statusDescriptionsDictionary:@{ @404: NSLocalizedString(@"User for current e-mail does not exist.", nil) }];
         [errorAlert show];
     }];
}

@end
