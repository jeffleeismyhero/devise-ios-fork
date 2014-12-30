//
//  DVSSignUpViewController.h
//  Devise
//
//  Created by Wojciech Trzasko on 23.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DVSUser.h"
#import "DVSSignUpFields.h"

@protocol DVSSignUpViewControllerDelegate;

@interface DVSSignUpViewController : UIViewController

@property (weak, nonatomic) id<DVSSignUpViewControllerDelegate> delegate;

- (instancetype)initWithFields:(DVSSignUpFields)fields;

@end

@protocol DVSSignUpViewControllerDelegate <NSObject>

- (void)signUpViewController:(DVSSignUpViewController *)controller didSignUpUser:(DVSUser *)user;
- (void)signUpViewController:(DVSSignUpViewController *)controller didFailWithError:(NSError *)error;
- (void)signUpViewControllerDidCancelSignUp:(DVSSignUpViewController *)controller;

@end
