//
//  DVSPasswordChangeViewController.m
//  Devise
//
//  Created by Wojciech Trzasko on 12.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSPasswordChangeViewController.h"
#import <Devise/Devise.h>

#import "UIAlertView+Devise.h"

static NSString * const DVSCurrentPasswordTitle = @"Current password";
static NSString * const DVSNewPasswordTitle = @"New password";

@interface DVSPasswordChangeViewController ()

@end

@implementation DVSPasswordChangeViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addFormWithTitleToDataSource:DVSCurrentPasswordTitle secured:YES];
    [self addFormWithTitleToDataSource:DVSNewPasswordTitle secured:YES];
}

#pragma mark - Touch

- (IBAction)saveButtonTouched:(UIBarButtonItem *)sender {
    DVSUser *localUser = [DVSUser localUser];
    NSString *currentPassword = localUser.password;
    
    localUser.password = [self getValueForTitle:DVSNewPasswordTitle];
    [localUser changePasswordWithSuccess:^{
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        localUser.password = currentPassword;
        [[UIAlertView dvs_alertViewForError:error] show];
    }];
}

@end
