//
//  DVSPasswordReminderViewController.h
//  Devise
//
//  Created by Wojciech Trzasko on 29.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DVSPasswordReminderFields.h"

@protocol DVSPasswordReminderViewControllerDelegate;

@interface DVSPasswordReminderViewController : UIViewController

@property (weak, nonatomic) id<DVSPasswordReminderViewControllerDelegate> delegate;

- (instancetype)initWithFields:(DVSPasswordReminderFields)fields;

@end

@protocol DVSPasswordReminderViewControllerDelegate <NSObject>

- (void)passwordReminderViewControllerDidRemindPassword:(DVSPasswordReminderViewController *)controller;
- (void)passwordReminderViewController:(DVSPasswordReminderViewController *)controller didFailWithError:(NSError *)error;
- (void)passwordReminderViewControllerDidCancelRemindPassword:(DVSPasswordReminderViewController *)controller;

@end
