//
//  DVSLoginSignUpViewController.h
//  Devise
//
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DVSLoginSignUpFields.h"
#import "DVSUser.h"

typedef NS_ENUM(NSUInteger, DVSViewControllerType) {
    DVSViewControllerTypeUnknown    = 0,
    DVSViewControllerTypeLogIn      = 1,
    DVSViewControllerTypeSignUp     = 2
};

typedef NS_ENUM(NSUInteger, DVSViewControllerAction) {
    DVSViewControllerActionLogIn,
    DVSViewControllerActionSignUp,
    DVSViewControllerActionPasswordRemind
};

@protocol DVSLogInSignUpViewControllerDelegate;

@interface DVSLoginSignUpViewController : UIViewController

@property (weak, nonatomic) id<DVSLogInSignUpViewControllerDelegate> delegate;

- (instancetype)initAsLogInWithFields:(DVSLogInSignUpFields)fields;
- (instancetype)initAsSignUpWithFields:(DVSLogInSignUpFields)fields;
- (instancetype)initWithType:(DVSViewControllerType)type andFields:(DVSLogInSignUpFields)fields;

@end


@protocol DVSLogInSignUpViewControllerDelegate <NSObject>

- (void)logInSingUpViewController:(DVSLoginSignUpViewController *)controller didSuccessForAction:(DVSViewControllerAction)action andUser:(DVSUser *)user;
- (void)logInSingUpViewController:(DVSLoginSignUpViewController *)controller didFailWithError:(NSError *)error forAction:(DVSViewControllerAction)action;
- (void)logInViewControllerDidCancel:(DVSLoginSignUpViewController *)controller;

@end

