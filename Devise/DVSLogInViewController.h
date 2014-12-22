//
//  DVSLogInViewController.h
//  Devise
//
//  Created by Wojciech Trzasko on 22.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSFormViewController.h"

#import <XLForm/XLForm.h>

#import "DVSUser.h"

@protocol DVSLogInViewControllerDelegate;

@interface DVSLogInViewController : XLFormViewController

@property (assign, nonatomic) id<DVSLogInViewControllerDelegate> delegate;

@end

@protocol DVSLogInViewControllerDelegate <NSObject>

- (void)logInViewController:(DVSLogInViewController *)controller didLogInUser:(DVSUser *)user;
- (void)logInViewController:(DVSLogInViewController *)controller didFailedWithError:(NSError *)error;

@end
