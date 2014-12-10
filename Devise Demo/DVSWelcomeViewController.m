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

@property (nonatomic,strong) NSArray *dataSourceArray;

@end

@implementation DVSWelcomeViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDataSource];
}

#pragma mark - Setup

- (void)setupDataSource {
    self.dataSourceArray = @[ @{DVSTableModelTitleKey: @"Sign up",
                                DVSTableModelSubtitleKey: @"Create new account",
                                DVSTableModelSegueKey: DVSRegisterSegue},
                              @{DVSTableModelTitleKey: @"Log in",
                                DVSTableModelSubtitleKey: @"Already registered?",
                                DVSTableModelSegueKey: DVSLoginSegue}
                              ];
}

#pragma mark - DVSMenuTableViewController methods

- (NSString *)defaultCellId {
    return DVSDefaultWelcomeCell;
}

- (NSArray *)tableDataSource {
    return self.dataSourceArray;
}

@end
