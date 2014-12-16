//
//  RegistrationViewController.m
//  Devise
//
//  Created by Patryk Kaczmarek on 19.11.2014.
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import "DVSRegistrationViewController.h"
#import <Devise/Devise.h>

#import "DVSMacros.h"
#import "DVSDemoUser.h"
#import "DVSDemoUserDataSource.h"
#import "UIAlertView+Devise.h"

static NSString * const DVSEnterSegue = @"DisplayHomeView";

static NSString * const DVSRegistrationUsernameTitle = @"Username";
static NSString * const DVSRegistrationPasswordTitle = @"Password";
static NSString * const DVSRegistrationEmailTitle = @"Email";
static NSString * const DVSRegistrationFirstNameTitle = @"First name";
static NSString * const DVSRegistrationLastNameTitle = @"Last name";
static NSString * const DVSRegistrationPhoneTitle = @"Phone";

@interface DVSRegistrationViewController ()

@property (strong, nonatomic) DVSDemoUserDataSource *userDataSource;

@end

@implementation DVSRegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userDataSource = [DVSDemoUserDataSource dataSource];
    
    [self addFormWithTitleToDataSource:DVSRegistrationUsernameTitle];
    [self addFormWithTitleToDataSource:DVSRegistrationPasswordTitle secured:YES];
    [self addFormWithTitleToDataSource:DVSRegistrationEmailTitle];
    [self addFormWithTitleToDataSource:DVSRegistrationFirstNameTitle];
    [self addFormWithTitleToDataSource:DVSRegistrationLastNameTitle];
    [self addFormWithTitleToDataSource:DVSRegistrationPhoneTitle];
}

#pragma mark - UIButtons events

- (IBAction)signUpTouched:(UIBarButtonItem *)sender {
    DVSDemoUser *newUser = [DVSDemoUser new];
    
    newUser.dataSource = self.userDataSource;
    
    newUser.username = [self getValueForTitle:DVSRegistrationUsernameTitle];
    newUser.password = [self getValueForTitle:DVSRegistrationPasswordTitle];
    newUser.email = [self getValueForTitle:DVSRegistrationEmailTitle];
    newUser.firstName = [self getValueForTitle:DVSRegistrationFirstNameTitle];
    newUser.lastName = [self getValueForTitle:DVSRegistrationLastNameTitle];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    newUser.phone = [formatter numberFromString:[self getValueForTitle:DVSRegistrationPhoneTitle]];
    
    [newUser registerWithSuccess:^{
        [self performSegueWithIdentifier:DVSEnterSegue sender:self];
    } failure:^(NSError *error) {
        [[UIAlertView dvs_alertViewForError:error] show];
    }];
}

@end
