//
//  DVSSignUpFormViewController.h
//  Devise
//
//  Created by Wojciech Trzasko on 30.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "XLFormViewController.h"

#import "DVSSignUpFields.h"

@protocol DVSSignUpFormViewControllerDelegate;

@interface DVSSignUpFormViewController : XLFormViewController

@property (weak, nonatomic) id<DVSSignUpFormViewControllerDelegate> delegate;

- (instancetype)initWithFields:(DVSSignUpFields)fields;

@end

@protocol DVSSignUpFormViewControllerDelegate <NSObject>

@optional
- (void)signUpFormViewController:(DVSSignUpFormViewController *)controller didSelectProceedRow:(XLFormRowDescriptor *)row;
- (void)signUpFormViewController:(DVSSignUpFormViewController *)controller didSelectDismissRow:(XLFormRowDescriptor *)row;

@end
