//
//  WelcomeViewController.m
//  Devise
//
//  Created by Grzegorz Lesiak on 20/11/14.
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import "DVSWelcomeViewController.h"

static NSString * const DVSRegisterSegue = @"DisplayRegisterView";
static NSString * const DVSLoginSegue = @"DisplayLoginView";

static NSString * const DVSDefaultWelcomeCell = @"defaultCell";

@interface DVSWelcomeViewController ()

@end

@implementation DVSWelcomeViewController

#pragma mark - Object lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDataSource];
}

#pragma mark - Setup

- (void)setupDataSource {
    [self addMenuEntryWithTitle:@"Sign up" subtitle:@"Create new account" segue:DVSRegisterSegue];
    [self addMenuEntryWithTitle:@"Log in" subtitle:@"Already registered?" segue:DVSLoginSegue];
}

#pragma mark - DVSMenuTableViewController methods

- (NSString *)defaultCellId {
    return DVSDefaultWelcomeCell;
}

@end
