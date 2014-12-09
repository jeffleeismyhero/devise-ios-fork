//
//  ViewController.m
//  Devise
//
//  Created by Patryk Kaczmarek on 19.11.2014.
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import "LoginViewController.h"
#import <Devise/Devise.h>

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
    DVSUser *user = [DVSUser user];
    
    user.email = self.emailTextField.text;
    user.password = self.emailTextField.text;
    
    [user loginWithSuccess:^{
        [self performSegueWithIdentifier:DVSHomeSegue sender:self];
    } failure:^(NSError *error) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:error.localizedDescription
                                   delegate:nil
                          cancelButtonTitle:@"Close"
                          otherButtonTitles:nil] show];
    }];
}

@end
