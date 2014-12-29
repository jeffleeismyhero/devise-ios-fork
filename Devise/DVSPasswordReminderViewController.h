//
//  DVSPasswordReminderViewController.h
//  Devise
//
//  Created by Wojciech Trzasko on 29.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSBaseViewController.h"

@protocol DVSPasswordReminderViewControllerDelegate;

@interface DVSPasswordReminderViewController : DVSBaseViewController

@property (weak, nonatomic) id<DVSPasswordReminderViewControllerDelegate> delegate;

@end

@protocol DVSPasswordReminderViewControllerDelegate <NSObject>

- (void)passwordReminderViewControllerDidRemindPassword:(DVSPasswordReminderViewController *)controller;
- (void)passwordReminderViewController:(DVSPasswordReminderViewController *)controller didFailWithError:(NSError *)error;

@end
