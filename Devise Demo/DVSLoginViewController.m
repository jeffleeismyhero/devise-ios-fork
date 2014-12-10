//
//  ViewController.m
//  Devise
//
//  Created by Patryk Kaczmarek on 19.11.2014.
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import "DVSLoginViewController.h"
#import <Devise/Devise.h>

#import "UIAlertView+Devise.h"

static NSString * const DVSHomeSegue = @"DisplayHomeView";
static NSString * const DVSRemindPasswordSegue = @"DisplayPasswordReminderView";

@interface DVSLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation DVSLoginViewController

- (IBAction)remindButtonTouched:(UIButton *)sender {
    [self performSegueWithIdentifier:DVSRemindPasswordSegue sender:self];
}

- (IBAction)logInTouched:(UIBarButtonItem *)sender {
    DVSUser *user = [DVSUser user];
    
    user.email = self.emailTextField.text;
    user.password = self.passwordTextField.text;
    
    [user loginWithSuccess:^{
        [self performSegueWithIdentifier:DVSHomeSegue sender:self];
    } failure:^(NSError *error) {
        [[UIAlertView dvs_alertViewForError:error] show];
    }];
}

@end
