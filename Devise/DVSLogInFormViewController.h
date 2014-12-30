//
//  DVSLogInFormViewController.h
//  Devise
//
//  Created by Wojciech Trzasko on 30.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "XLFormViewController.h"

#import "DVSLogInFields.h"

@protocol DVSLogInFormViewControllerDelegate;

@interface DVSLogInFormViewController : XLFormViewController

@property (weak, nonatomic) id<DVSLogInFormViewControllerDelegate> delegate;

- (instancetype)initWithFields:(DVSLogInFields)fields;

@end

@protocol DVSLogInFormViewControllerDelegate <NSObject>

@optional
- (void)logInFormViewController:(DVSLogInFormViewController *)formController didSelectProceedRow:(XLFormRowDescriptor *)row;
- (void)logInFormViewController:(DVSLogInFormViewController *)formController didSelectDismissRow:(XLFormRowDescriptor *)row;
- (void)logInFormViewController:(DVSLogInFormViewController *)formController didSelectPresentRow:(XLFormRowDescriptor *)row;

@end
