//
//  HomeViewController.m
//  Devise
//
//  Created by Grzegorz Lesiak on 20/11/14.
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import "DVSHomeViewController.h"
#import <Devise/Devise.h>

#import "UIAlertView+Devise.h"

static NSString * const DVSEditProfileSegue = @"DisplayProfileEditor";
static NSString * const DVSPasswordChangeSegue = @"DisplayPasswordChange";
static NSString * const DVSHomeDefaultCell = @"defaultCell";

static NSString * const DVSDeleteCellTitle = @"Delete profile";

@interface DVSHomeViewController () <UIAlertViewDelegate>

@end

@implementation DVSHomeViewController

#pragma mark - Object lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDataSource];
}

#pragma mark - Setup

- (void)setupDataSource {
    [self addMenuEntryWithTitle:@"Edit profile"
                       subtitle:@"Do you feel something in your account is bad?"
                          segue:DVSEditProfileSegue];
    [self addMenuEntryWithTitle:@"Change password"
                       subtitle:@"Do you want to change your password?"
                          segue:DVSPasswordChangeSegue];
    [self addMenuEntryWithTitle:DVSDeleteCellTitle
                       subtitle:@"Do you feel bored?"
                       selector:@selector(handleDeleteCell)];
}

#pragma mark - DVSMenuTableViewController methods

- (NSString *)defaultCellId {
    return DVSHomeDefaultCell;
}

#pragma mark - Delete action

- (void)handleDeleteCell {
    [[[UIAlertView alloc] initWithTitle:DVSDeleteCellTitle
                               message:@"Are you sure you want to delete your profile?"
                              delegate:self
                     cancelButtonTitle:[self titleForDeleteAlertCancelButton]
                     otherButtonTitles:[self titleForDeleteAlertConfirmButton], nil] show];
}

#pragma merk - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:[self titleForDeleteAlertConfirmButton]]) {
        [[DVSUser localUser] deleteAccountWithSuccess:^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            [UIAlertView dvs_alertViewForError:error];
        }];
    }
}

- (NSString *)titleForDeleteAlertCancelButton {
    return @"No";
}

- (NSString *)titleForDeleteAlertConfirmButton {
    return @"Yes";
}

#pragma mark - UIControl events

- (IBAction)logoutTouched:(UIBarButtonItem *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
