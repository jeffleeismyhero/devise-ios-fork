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
#import "UIApplication+Devise.h"
#import "DVSDemoUser.h"
#import "DVSDemoUserDataSource.h"

static NSString * const DVSHomeSegue = @"DisplayHomeView";
static NSString * const DVSRemindPasswordSegue = @"DisplayPasswordReminderView";

@interface DVSLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (strong, nonatomic) DVSDemoUserDataSource *userDataSource;

@end

@implementation DVSLoginViewController

#pragma mark - Object lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userDataSource = [[DVSDemoUserDataSource alloc] init];
}

#pragma mark - UIControl events

- (IBAction)remindButtonTouched:(UIButton *)sender {
    [self performSegueWithIdentifier:DVSRemindPasswordSegue sender:self];
}

- (IBAction)logInTouched:(UIBarButtonItem *)sender {
    DVSDemoUser *user = [DVSDemoUser new];
    
    user.dataSource = self.userDataSource;
    
    user.email = self.emailTextField.text;
    user.password = self.passwordTextField.text;
    
    [UIApplication showNetworkActivity];
    [user loginWithSuccess:^{
        [self performSegueWithIdentifier:DVSHomeSegue sender:self];
        [UIApplication hideNetworkActivity];
    } failure:^(NSError *error) {
        [[UIAlertView dvs_alertViewForError:error] show];
        [UIApplication hideNetworkActivity];
    }];
}

@end
