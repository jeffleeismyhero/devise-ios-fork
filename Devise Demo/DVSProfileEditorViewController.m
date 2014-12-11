//
//  ProfileEditorViewController.m
//  Devise
//
//  Created by Grzegorz Lesiak on 20/11/14.
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import "DVSProfileEditorViewController.h"
#import <Devise/Devise.h>

#import "UIAlertView+Devise.h"

static NSString * const DVSProfileEditorEmailTitle = @"E-mail address";

@interface DVSProfileEditorViewController ()

@end

@implementation DVSProfileEditorViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addFormWithTitleToDataSource:DVSProfileEditorEmailTitle];
}

#pragma mark - Touch

- (IBAction)saveButtonTouched:(UIBarButtonItem *)sender {
    DVSUser *localUser = [DVSUser localUser];
    localUser.email = [self getValueForTitle:DVSProfileEditorEmailTitle];
    
    [localUser updateWithSuccess:^{
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [[UIAlertView dvs_alertViewForError:error] show];
    }];
}

@end
