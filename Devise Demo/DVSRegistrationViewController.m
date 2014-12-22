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
#import "UIAlertView+DeviseDemo.h"

static NSString * const DVSEnterSegue = @"DisplayHomeView";
static NSString * const DVSTitleForUsername = @"Username";
static NSString * const DVSTitleForPassword = @"Password";
static NSString * const DVSTitleForEmail = @"E-mail";
static NSString * const DVSTitleForFirstName = @"First name";
static NSString * const DVSTitleForLastName = @"Last name";
static NSString * const DVSTitleForPhone = @"Phone";

@interface DVSRegistrationViewController ()

@property (strong, nonatomic) DVSDemoUserDataSource *userDataSource;

@end

@implementation DVSRegistrationViewController

#pragma mark - Object lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userDataSource = [DVSDemoUserDataSource new];
    
    [self addFormWithTitleToDataSource:NSLocalizedString(DVSTitleForUsername, nil)];
    [self addFormWithTitleToDataSource:NSLocalizedString(DVSTitleForPassword, nil) secured:YES];
    [self addFormWithTitleToDataSource:NSLocalizedString(DVSTitleForEmail, nil)];
    [self addFormWithTitleToDataSource:NSLocalizedString(DVSTitleForFirstName, nil)];
    [self addFormWithTitleToDataSource:NSLocalizedString(DVSTitleForLastName, nil)];
    [self addFormWithTitleToDataSource:NSLocalizedString(DVSTitleForPhone, nil) keyboardType:UIKeyboardTypePhonePad];
}

#pragma mark - UIControl events

- (IBAction)signUpButtonTapped:(UIBarButtonItem *)sender {
    DVSDemoUser *newUser = [DVSDemoUser new];
    
    newUser.dataSource = self.userDataSource;
    
    newUser.username = [self getValueForTitle:NSLocalizedString(DVSTitleForUsername, nil)];
    newUser.password = [self getValueForTitle:NSLocalizedString(DVSTitleForPassword, nil)];
    newUser.email = [self getValueForTitle:NSLocalizedString(DVSTitleForEmail, nil)];
    newUser.firstName = [self getValueForTitle:NSLocalizedString(DVSTitleForFirstName, nil)];
    newUser.lastName = [self getValueForTitle:NSLocalizedString(DVSTitleForLastName, nil)];
    newUser.phone = [self getValueForTitle:NSLocalizedString(DVSTitleForPhone, nil)];
    
    [newUser registerWithSuccess:^{
        [self performSegueWithIdentifier:DVSEnterSegue sender:self];
    } failure:^(NSError *error) {
        UIAlertView *errorAlert = [UIAlertView dvs_alertViewForError:error
                                        statusDescriptionsDictionary:@{ @422: NSLocalizedString(@"E-mail is already taken.", nil) }];
        [errorAlert show];
    }];
}

@end
