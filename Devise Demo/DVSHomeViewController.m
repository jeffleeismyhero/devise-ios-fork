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

static NSString * const DVSPasswordChangeSegue = @"DisplayProfileEditor";
static NSString * const DVSHomeDefaultCell = @"defaultCell";

static NSString * const DVSDeleteCellTitle = @"Delete profile";

@interface DVSHomeViewController () <UIAlertViewDelegate>

@property (nonatomic,strong) NSArray * dataSourceArray;

@end

@implementation DVSHomeViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDataSource];
}

#pragma mark - Setup

- (void)setupDataSource {
    self.dataSourceArray = @[ @{DVSTableModelTitleKey: @"Edit profile",
                                DVSTableModelSubtitleKey: @"Do you feel something in your account is bad?",
                                DVSTableModelSegueKey: DVSPasswordChangeSegue},
                              @{DVSTableModelTitleKey: DVSDeleteCellTitle,
                                DVSTableModelSubtitleKey: @"Do you feel bored?"}
                              ];
}

#pragma mark - DVSMenuTableViewController methods

- (NSString *)defaultCellId {
    return DVSHomeDefaultCell;
}

- (NSArray *)tableDataSource {
    return self.dataSourceArray;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dataDictionary = [self tableDataSource][indexPath.row];
    NSString *title = (NSString *)dataDictionary[DVSTableModelTitleKey];
    
    if ([title isEqualToString:DVSDeleteCellTitle]) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self handleDeleteCell];
    } else {
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

- (void)handleDeleteCell {
    [[[UIAlertView alloc] initWithTitle:DVSDeleteCellTitle
                               message:@"are you sure you want to do delete your profile?"
                              delegate:self
                     cancelButtonTitle:[self titleForCancelButton]
                     otherButtonTitles:[self titleForConfirmButton], nil] show];
}

#pragma merk - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:[self titleForConfirmButton]]) {
        [[DVSUser localUser] deleteAccountWithSuccess:^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            [UIAlertView dvs_alertViewForError:error];
        }];
    }
}

- (NSString *)titleForCancelButton {
    return @"No";
}

- (NSString *)titleForConfirmButton {
    return @"Yes";
}

#pragma mark - Button callbacks

- (IBAction)logoutTouched:(UIBarButtonItem *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
