//
//  DVSLoginSignUpViewController.h
//  Devise
//
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DVSLoginSignUpFields.h"
#import "DVSUser.h"

/**
 *  Enumeration specyfing for what type of action view controller should be customized
 */
typedef NS_ENUM(NSUInteger, DVSViewControllerType) {
    DVSViewControllerTypeUnknown    = 0,
    DVSViewControllerTypeLogIn      = 1,
    DVSViewControllerTypeSignUp     = 2
};


/**
 * Enumeration specyfing what action was performed
 */
typedef NS_ENUM(NSUInteger, DVSViewControllerAction) {
    DVSViewControllerActionLogIn,
    DVSViewControllerActionSignUp,
    DVSViewControllerActionPasswordRemind
};

@protocol DVSLogInSignUpViewControllerDelegate;


/**
 * The DVSLoginSignUpViewController class presents standard interface for logging or signing up DVSUser
 */
@interface DVSLoginSignUpViewController : UIViewController

/**
 * The delegate that responds to events of DVSLogInSignUpViewControllerDelegate
 */
@property (weak, nonatomic) id<DVSLogInSignUpViewControllerDelegate> delegate;

/**
 *  Returns an initialized instance of view controller and configured for log in action
 *
 *  @param fields Bitmask specifying elements which are enabled in the view
 *
 *  @return Instance of DVSLoginSignUpViewController class
 */
- (instancetype)initAsLogInWithFields:(DVSLogInSignUpFields)fields;

/**
 *  Returns an initialized instance of view controller and configured for sign up action
 *
 *  @param fields Bitmask specifying elements which are enabled in the view
 *
 *  @return Instance of DVSLoginSignUpViewController class
 */
- (instancetype)initAsSignUpWithFields:(DVSLogInSignUpFields)fields;

/**
 *  Returns an initialized instance of view controller
 *
 *  @param type Specyfies type of
 *  @param fields Bitmask specifying elements which are enabled in the view
 *
 *  @return Instance of DVSLoginSignUpViewController class
 */
- (instancetype)initWithType:(DVSViewControllerType)type andFields:(DVSLogInSignUpFields)fields;

@end

/**
 * The DVSLogInSignUpViewControllerDelegate protocol defines methods a delegate of DVSLoginSignUpViewController should implement
 */
@protocol DVSLogInSignUpViewControllerDelegate <NSObject>

/**
 *  Sent to delegate when controller action results with success
 *
 *  @param controller The controller where action finished
 *  @param action Type of finished action
 *  @param user DVSUser object that is result of action
 */
- (void)logInSingUpViewController:(DVSLoginSignUpViewController *)controller didSuccessForAction:(DVSViewControllerAction)action andUser:(DVSUser *)user;

/**
 *  Sent to delegate when controller action finishes with error
 *
 *  @param controller The controller where action finished with error
 *  @param error Object that represents error
 *  @param action Type of action
 */
- (void)logInSingUpViewController:(DVSLoginSignUpViewController *)controller didFailWithError:(NSError *)error forAction:(DVSViewControllerAction)action;

/**
 *  Sent to delegate when user tapps dismiss button on controller screen
 *
 *  @param controller The controller that was cancelled
 */
- (void)logInViewControllerDidCancel:(DVSLoginSignUpViewController *)controller;

@end

