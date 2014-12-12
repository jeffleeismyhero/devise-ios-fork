//
//  DVSPasswordChangeViewController.m
//  Devise
//
//  Created by Wojciech Trzasko on 12.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSPasswordChangeViewController.h"
#import <Devise/Devise.h>

#import "NSError+Devise.h"
#import "UIAlertView+Devise.h"

static NSString * const DVSCurrentPasswordTitle = @"Current password";
static NSString * const DVSNewPasswordTitle = @"New password";
static NSString * const DVSNewPasswordConfirmTitle = @"Confirm new password";

@interface DVSPasswordChangeViewController ()

@end

@implementation DVSPasswordChangeViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addFormWithTitleToDataSource:DVSCurrentPasswordTitle secured:YES];
    [self addFormWithTitleToDataSource:DVSNewPasswordTitle secured:YES];
    [self addFormWithTitleToDataSource:DVSNewPasswordConfirmTitle secured:YES];
}

#pragma mark - Touch

- (IBAction)saveButtonTouched:(UIBarButtonItem *)sender {
    DVSUser *localUser = [DVSUser localUser];
    NSString *currentPassword = localUser.password;
    
    NSString *currentPasswordConfirm = [self getValueForTitle:DVSCurrentPasswordTitle];
    if (![currentPassword isEqualToString:currentPasswordConfirm]) {
        [[UIAlertView dvs_alertViewForError:[NSError dvs_passwordConfirmError]] show];
        return;
    }
    
    NSString *newPassword = [self getValueForTitle:DVSNewPasswordTitle];
    NSString *newPasswordConfirm = [self getValueForTitle:DVSNewPasswordConfirmTitle];
    if (![newPassword isEqualToString:newPasswordConfirm]) {
        [[UIAlertView dvs_alertViewForError:[NSError dvs_newPasswordConfirmError]] show];
        return;
    }
    
    localUser.password = newPassword;
    [localUser changePasswordWithSuccess:^{
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        localUser.password = currentPassword;
        [[UIAlertView dvs_alertViewForError:error] show];
    }];
}

@end
