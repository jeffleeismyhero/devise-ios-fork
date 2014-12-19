//
//  ProfileEditorViewController.m
//  Devise
//
//  Created by Grzegorz Lesiak on 20/11/14.
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import "DVSProfileEditorViewController.h"
#import <Devise/Devise.h>

#import "UIAlertView+DeviseDemo.h"
#import "DVSDemoUser.h"
#import "DVSDemoUserDataSource.h"

@interface DVSProfileEditorViewController () <UIAlertViewDelegate>

@property (strong, nonatomic) DVSDemoUserDataSource *userDataSource;

@end

@implementation DVSProfileEditorViewController

#pragma mark - Object lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userDataSource = [DVSDemoUserDataSource new];
    
    NSString *emailTitle = [self localizedTitleForEmail];
    [self addFormWithTitleToDataSource:emailTitle];
    [self setValue:[DVSDemoUser localUser].email forTitle:emailTitle];
}

#pragma mark - UIControl events

- (IBAction)saveButtonTouched:(UIBarButtonItem *)sender {
    DVSDemoUser *localUser = [DVSDemoUser localUser];
    
    localUser.dataSource = self.userDataSource;
    localUser.email = [self getValueForTitle:[self localizedTitleForEmail]];
    
    [localUser updateWithSuccess:^{
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Profile updated", nil)
                                    message:NSLocalizedString(@"Your profile was updated.", nil)
                                   delegate:self
                          cancelButtonTitle:[self titleForProfileUpdatedAlertCancelButton]
                          otherButtonTitles:nil] show];
    } failure:^(NSError *error) {
        UIAlertView *errorAlert = [UIAlertView dvs_alertViewForError:error
                                        statusDescriptionsDictionary:@{ @422: NSLocalizedString(@"E-mail is already taken.", nil) }];
        [errorAlert show];
    }];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:[self titleForProfileUpdatedAlertCancelButton]]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (NSString *)titleForProfileUpdatedAlertCancelButton {
    return NSLocalizedString(@"Close", nil);
}

#pragma mark - Localized titles

- (NSString *)localizedTitleForEmail {
    return NSLocalizedString(@"E-mail address", nil);
}

@end
