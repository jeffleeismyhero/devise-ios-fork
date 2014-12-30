//
//  DVSPasswordReminderFormViewControllers.h
//  Devise
//
//  Created by Wojciech Trzasko on 30.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "XLFormViewController.h"

#import "DVSPasswordReminderFields.h"

@protocol DVSPasswordReminderFormViewControllerDelegate;

@interface DVSPasswordReminderFormViewController : XLFormViewController

@property (weak, nonatomic) id<DVSPasswordReminderFormViewControllerDelegate> delegate;

- (instancetype)initWithFields:(DVSPasswordReminderFields)fields;

@end

@protocol DVSPasswordReminderFormViewControllerDelegate <NSObject>

@optional
- (void)passwordReminderFormViewController:(DVSPasswordReminderFormViewController *)controller didSelectProceedRow:(XLFormRowDescriptor *)row;
- (void)passwordReminderFormViewController:(DVSPasswordReminderFormViewController *)controller didSelectDismissRow:(XLFormRowDescriptor *)row;

@end
