//
//  WelcomeViewController.m
//  Devise
//
//  Created by Grzegorz Lesiak on 20/11/14.
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import "DVSWelcomeViewController.h"

#import "DVSLoginViewController.h"

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
    [self addMenuEntryWithTitle:NSLocalizedString(@"Sign up", nil)
                       subtitle:NSLocalizedString(@"Create new account", nil)
                          segue:DVSRegisterSegue];
    [self addMenuEntryWithTitle:NSLocalizedString(@"Log in", nil)
                       subtitle:NSLocalizedString(@"Already registered?", nil)
                       selector:@selector(didSelectLogIn)];
}

#pragma mark - Menu actions

- (void)didSelectLogIn {
    
#if ENABLE_DEVISE_CONTROLLERS
    DVSLoginViewController *logInController = [[DVSLoginViewController alloc] init];
    [self presentViewController:logInController animated:YES completion:nil];
#else
    [self performSegueWithIdentifier:DVSLoginSegue sender:self];
#endif
    
}

#pragma mark - DVSMenuTableViewController methods

- (NSString *)defaultCellId {
    return DVSDefaultWelcomeCell;
}

@end
