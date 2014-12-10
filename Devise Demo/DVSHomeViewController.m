//
//  HomeViewController.m
//  Devise
//
//  Created by Grzegorz Lesiak on 20/11/14.
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import "DVSHomeViewController.h"

static NSString * const DVSPasswordChangeSegue = @"password change";
static NSString * const DVSHomeDefaultCell = @"defaultCell";

@interface DVSHomeViewController ()

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
                              ];
}

#pragma mark - DVSMenuTableViewController methods

- (NSString *)defaultCellId {
    return DVSHomeDefaultCell;
}

- (NSArray *)tableDataSource {
    return self.dataSourceArray;
}

#pragma mark - Button callbacks

- (IBAction)logoutTouched:(UIBarButtonItem *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
