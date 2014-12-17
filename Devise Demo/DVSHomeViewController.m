//
//  HomeViewController.m
//  Devise
//
//  Created by Grzegorz Lesiak on 20/11/14.
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import "DVSHomeViewController.h"
#import <Devise/Devise.h>

#import "UIAlertView+DeviseDemo.h"

static NSString * const DVSEditProfileSegue = @"DisplayProfileEditor";
static NSString * const DVSPasswordChangeSegue = @"DisplayPasswordChange";
static NSString * const DVSHomeDefaultCell = @"defaultCell";

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
    [self addMenuEntryWithTitle:NSLocalizedString(@"Edit profile", nil)
                       subtitle:NSLocalizedString(@"Do you feel something in your account is bad?", nil)
                          segue:DVSEditProfileSegue];
    [self addMenuEntryWithTitle:NSLocalizedString(@"Change password", nil)
                       subtitle:NSLocalizedString(@"Do you want to change your password?", nil)
                          segue:DVSPasswordChangeSegue];
    [self addMenuEntryWithTitle:[self titleForDeleteAlertView]
                       subtitle:NSLocalizedString(@"Do you feel bored?", nil)
                       selector:@selector(handleDeleteCell)];
}

#pragma mark - DVSMenuTableViewController methods

- (NSString *)defaultCellId {
    return DVSHomeDefaultCell;
}

#pragma mark - Delete action

- (void)handleDeleteCell {
    [[[UIAlertView alloc] initWithTitle:[self titleForDeleteAlertView]
                                message:NSLocalizedString(@"Are you sure you want to delete your profile?", nil)
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
    return NSLocalizedString(@"No", nil);
}

- (NSString *)titleForDeleteAlertConfirmButton {
    return NSLocalizedString(@"Yes", nil);
}

- (NSString *)titleForDeleteAlertView {
    return NSLocalizedString(@"Delete profile", nil);
}

#pragma mark - UIControl events

- (IBAction)logoutTouched:(UIBarButtonItem *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
