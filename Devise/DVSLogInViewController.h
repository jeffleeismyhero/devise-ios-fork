//
//  DVSLogInViewController.h
//  Devise
//
//  Created by Wojciech Trzasko on 22.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DVSUser.h"
#import "DVSLogInFields.h"

@protocol DVSLogInViewControllerDelegate;

@interface DVSLogInViewController : UIViewController

@property (weak, nonatomic) id<DVSLogInViewControllerDelegate> delegate;

- (instancetype)initWithFields:(DVSLogInFields)fields;

@end

@protocol DVSLogInViewControllerDelegate <NSObject>

- (void)logInViewController:(DVSLogInViewController *)controller didLogInUser:(DVSUser *)user;
- (void)logInViewController:(DVSLogInViewController *)controller didFailWithError:(NSError *)error;
- (void)logInViewControllerDidCancelLogIn:(DVSLogInViewController *)controller;

@optional
- (void)logInViewControllerDidRemindPassword:(DVSLogInViewController *)controller;
- (void)logInViewController:(DVSLogInViewController *)controller didFailRemindPasswordWithError:(NSError *)error;

@end
