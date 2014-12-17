//
//  DVSPasswordChangeViewController.m
//  Devise
//
//  Created by Wojciech Trzasko on 12.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSPasswordChangeViewController.h"
#import <Devise/Devise.h>

#import "DVSDemoUser.h"
#import "DVSDemoUserDataSource.h"
#import "NSError+Devise.h"
#import "UIAlertView+Devise.h"

@interface DVSPasswordChangeViewController () <UIAlertViewDelegate>

@property (strong, nonatomic) DVSDemoUserDataSource *userDataSource;

@end

@implementation DVSPasswordChangeViewController

#pragma mark - Object lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userDataSource = [DVSDemoUserDataSource dataSource];
    
    [self addFormWithTitleToDataSource:[self localizedTitleForCurrentPassword]
                               secured:YES];
    [self addFormWithTitleToDataSource:[self localizedTitleForNewPassword]
                               secured:YES];
    [self addFormWithTitleToDataSource:[self localizedTitleForNewPasswordConfirm]
                               secured:YES];
}

#pragma mark - UIControl events

- (IBAction)saveButtonTouched:(UIBarButtonItem *)sender {
    DVSDemoUser *localUser = [DVSDemoUser localUser];
    
    localUser.dataSource = self.userDataSource;
    
    NSString *currentPassword = localUser.password;
    
    NSString *currentPasswordConfirm = [self getValueForTitle:[self localizedTitleForCurrentPassword]];
    if (![currentPassword isEqualToString:currentPasswordConfirm]) {
        [[UIAlertView dvs_alertViewForError:[NSError dvs_passwordConfirmError]] show];
        return;
    }
    
    NSString *newPassword = [self getValueForTitle:[self localizedTitleForNewPassword]];
    NSString *newPasswordConfirm = [self getValueForTitle:[self localizedTitleForNewPasswordConfirm]];
    
    if (![newPassword isEqualToString:newPasswordConfirm]) {
        [[UIAlertView dvs_alertViewForError:[NSError dvs_newPasswordConfirmError]] show];
        return;
    }
    
    localUser.password = newPassword;
    [localUser changePasswordWithSuccess:^{
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Password changed", nil)
                                    message:NSLocalizedString(@"Password was changed. \nNow you can login with new password.", nil)
                                   delegate:self
                          cancelButtonTitle:[self titleForPasswordChangedAlertCancelButton]
                          otherButtonTitles:nil] show];
    } failure:^(NSError *error) {
        localUser.password = currentPassword;
        [[UIAlertView dvs_alertViewForError:error] show];
    }];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:[self titleForPasswordChangedAlertCancelButton]]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (NSString *)titleForPasswordChangedAlertCancelButton {
    return NSLocalizedString(@"Close", nil);
}

#pragma mark - Localized titles

- (NSString *)localizedTitleForCurrentPassword {
    return NSLocalizedString(@"Current password", nil);
}

- (NSString *)localizedTitleForNewPassword {
    return NSLocalizedString(@"New password", nil);
}

- (NSString *)localizedTitleForNewPasswordConfirm {
    return NSLocalizedString(@"Confirm new password", nil);
}

@end
