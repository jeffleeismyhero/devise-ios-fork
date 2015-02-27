//
//  HomeViewController.m
//  Devise
//
//  Created by Grzegorz Lesiak on 20/11/14.
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import "DVSDemoHomeViewController.h"
#import <Devise/Devise.h>
#import "UIAlertView+DeviseDemo.h"
#import "DVSUserManager.h"
#import <FacebookSDK/FacebookSDK.h>

static NSString * const DVSEditProfileSegue = @"DisplayProfileEditor";
static NSString * const DVSPasswordChangeSegue = @"DisplayPasswordChange";
static NSString * const DVSHomeDefaultCell = @"defaultCell";
static NSString * const DVSTitleForAlertNoButton = @"No";
static NSString * const DVSTitleForAlertYesButton = @"Yes";
static NSString * const DVSTitleForAlertTitle = @"Delete";
static NSString * const DVSTitleForDelete = @"Delete profile";

@interface DVSDemoHomeViewController () <UIAlertViewDelegate>

@end

@implementation DVSDemoHomeViewController

#pragma mark - Object lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDataSource];
}

#pragma mark - Setup

- (void)setupDataSource {
    [self addMenuEntryWithTitle:NSLocalizedString(@"Edit profile", nil)
                       subtitle:NSLocalizedString(@"Do you feel something in your account is bad?", nil)
                          segue:DVSEditProfileSegue];
    
    [self addMenuEntryWithTitle:NSLocalizedString(@"Change password", nil)
                       subtitle:NSLocalizedString(@"Do you want to change your password?", nil)
                          segue:DVSPasswordChangeSegue];
    
    [self addMenuEntryWithTitle:NSLocalizedString(DVSTitleForDelete, nil)
                       subtitle:NSLocalizedString(@"Do you feel bored?", nil)
                         target:self
                         action:@selector(handleDeleteCell)];
}

#pragma mark - DVSMenuTableViewController methods

- (NSString *)defaultCellId {
    return DVSHomeDefaultCell;
}

#pragma mark - Delete action

- (void)handleDeleteCell {
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(DVSTitleForAlertTitle, nil)
                                message:NSLocalizedString(@"Are you sure you want to delete your profile?", nil)
                               delegate:self
                      cancelButtonTitle:NSLocalizedString(DVSTitleForAlertNoButton, nil)
                      otherButtonTitles:NSLocalizedString(DVSTitleForAlertYesButton, nil), nil] show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([buttonTitle isEqualToString:NSLocalizedString(DVSTitleForAlertYesButton, nil)]) {
        
        [[DVSUserManager defaultManager] deleteAccountWithSuccess:^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            [UIAlertView dvs_alertViewForError:error];
        }];
    }
}

#pragma mark - UIControl events

- (IBAction)logoutTouched:(UIBarButtonItem *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[FBSession activeSession] closeAndClearTokenInformation];
    [[DVSUserManager defaultManager] logout];
}

@end
