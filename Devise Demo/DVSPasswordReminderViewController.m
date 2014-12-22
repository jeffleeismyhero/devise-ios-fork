//
//  PasswordReminderViewController.m
//  Devise
//
//  Created by Grzegorz Lesiak on 20/11/14.
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import "DVSPasswordReminderViewController.h"
#import <Devise/Devise.h>

#import "UIAlertView+DeviseDemo.h"
#import "DVSDemoUser.h"

@interface DVSPasswordReminderViewController () <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@end

@implementation DVSPasswordReminderViewController

#pragma mark - UIControl events

- (IBAction)sendButtonTapped:(UIBarButtonItem *)sender {
    DVSDemoUser *user = [DVSDemoUser new];
    
    user.email = self.emailTextField.text;
    
    [user remindPasswordWithSuccess:^{
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Remind successful", nil)
                                    message:NSLocalizedString(@"You will receive e-mail with instructions how to reset your password.", nil)
                                   delegate:self
                          cancelButtonTitle:[self titleForPasswordRemindAlertCancelButton]
                          otherButtonTitles:nil] show];
     } failure:^(NSError *error) {
         UIAlertView *errorAlert = [UIAlertView dvs_alertViewForError:error
                                         statusDescriptionsDictionary:@{ @404: NSLocalizedString(@"User for current e-mail does not exist.", nil) }];
         [errorAlert show];
     }];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:[self titleForPasswordRemindAlertCancelButton]]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (NSString *)titleForPasswordRemindAlertCancelButton {
    return NSLocalizedString(@"Close", nil);
}

@end
