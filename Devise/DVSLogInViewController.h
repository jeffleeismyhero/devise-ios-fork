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

typedef NS_OPTIONS(NSInteger, DVSLogInViewsOptions) {
    DVSLogInViewsEmailAndPassword   = 1 << 0,
    DVSLogInViewsLogInButton        = 1 << 1,
    DVSLogInViewsDismissButton      = 1 << 2
};

@protocol DVSLogInViewControllerDelegate;

@interface DVSLogInViewController : XLFormViewController

@property (assign, nonatomic) id<DVSLogInViewControllerDelegate> delegate;

- (instancetype)initWithViewsOptions:(DVSLogInViewsOptions)viewsOptions;

@end

@protocol DVSLogInViewControllerDelegate <NSObject>

- (void)logInViewController:(DVSLogInViewController *)controller didLogInUser:(DVSUser *)user;
- (void)logInViewController:(DVSLogInViewController *)controller didFailedWithError:(NSError *)error;

@end
