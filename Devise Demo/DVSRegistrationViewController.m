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
#import "NSString+DeviseDemo.h"
#import "UIAlertView+DeviseDemo.h"

static NSString * const DVSEnterSegue = @"DisplayHomeView";

@interface DVSRegistrationViewController ()

@property (strong, nonatomic) DVSDemoUserDataSource *userDataSource;

@end

@implementation DVSRegistrationViewController

#pragma mark - Object lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userDataSource = [DVSDemoUserDataSource dataSource];
    
    [self addFormWithTitleToDataSource:[self localizedTitleForUsername]];
    [self addFormWithTitleToDataSource:[self localizedTitleForPassword] secured:YES];
    [self addFormWithTitleToDataSource:[self localizedTitleForEmail]];
    [self addFormWithTitleToDataSource:[self localizedTitleForFirstName]];
    [self addFormWithTitleToDataSource:[self localizedTitleForLastName]];
    [self addFormWithTitleToDataSource:[self localizedTitleForPhone] keyboardType:UIKeyboardTypePhonePad];
}

#pragma mark - UIControl events

- (IBAction)signUpTouched:(UIBarButtonItem *)sender {
    DVSDemoUser *newUser = [DVSDemoUser new];
    
    newUser.dataSource = self.userDataSource;
    
    newUser.username = [self getValueForTitle:[self localizedTitleForUsername]];
    newUser.password = [self getValueForTitle:[self localizedTitleForPassword]];
    newUser.email = [self getValueForTitle:[self localizedTitleForEmail]];
    newUser.firstName = [self getValueForTitle:[self localizedTitleForFirstName]];
    newUser.lastName = [self getValueForTitle:[self localizedTitleForLastName]];    
    newUser.phone = [self getValueForTitle:[self localizedTitleForPhone]];
    
    [newUser registerWithSuccess:^{
        [self performSegueWithIdentifier:DVSEnterSegue sender:self];
    } failure:^(NSError *error) {
        [[UIAlertView dvs_alertViewForError:error] show];
    }];
}

#pragma mark - Localized titles

- (NSString *)localizedTitleForUsername {
    return NSLocalizedString(@"Username", nil);
}

- (NSString *)localizedTitleForPassword {
    return NSLocalizedString(@"Password", nil);
}

- (NSString *)localizedTitleForEmail {
    return NSLocalizedString(@"E-mail", nil);
}

- (NSString *)localizedTitleForFirstName {
    return NSLocalizedString(@"First name", nil);
}

- (NSString *)localizedTitleForLastName {
    return NSLocalizedString(@"Last name", nil);
}

- (NSString *)localizedTitleForPhone {
    return NSLocalizedString(@"Phone", nil);
}

@end
