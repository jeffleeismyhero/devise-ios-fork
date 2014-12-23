//
//  DVSSignUpViewController.h
//  Devise
//
//  Created by Wojciech Trzasko on 23.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "XLFormViewController.h"

#import "DVSUser.h"

@protocol DVSSignUpViewControllerDelegate;

@interface DVSSignUpViewController : XLFormViewController

@property (weak, nonatomic) id<DVSSignUpViewControllerDelegate> delegate;

@end

@protocol DVSSignUpViewControllerDelegate <NSObject>

- (void)signUpViewController:(DVSSignUpViewController *)controller didSignUpUser:(DVSUser *)user;
- (void)signUpViewController:(DVSSignUpViewController *)controller didFailedWithError:(NSError *)error;

@end
