//
//  DVSLogInViewController.h
//  Devise
//
//  Created by Wojciech Trzasko on 22.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSBaseViewController.h"

#import "DVSUser.h"

typedef NS_OPTIONS(NSInteger, DVSLogInFields) {
    DVSLogInFieldEmailAndPassword           = 1 << 0,
    DVSLogInFieldLogInButton                = 1 << 1,
    DVSLogInFieldDismissButton              = 1 << 2,
    DVSLogInFieldNavigationLogInButton      = 1 << 3,
    DVSLogInFieldNavigationDismissButton    = 1 << 4,
    DVSLogInFieldPasswordReminder           = 1 << 5
};

@protocol DVSLogInViewControllerDelegate;

@interface DVSLogInViewController : DVSBaseViewController

@property (weak, nonatomic) id<DVSLogInViewControllerDelegate> delegate;

- (instancetype)initWithFields:(DVSLogInFields)fields;

@end

@protocol DVSLogInViewControllerDelegate <NSObject>

- (void)logInViewController:(DVSLogInViewController *)controller didLogInUser:(DVSUser *)user;
- (void)logInViewController:(DVSLogInViewController *)controller didFailWithError:(NSError *)error;

@optional
- (void)logInViewController:(DVSLogInViewController *)controller didFailRemindPasswordWithError:(NSError *)error;

@end
