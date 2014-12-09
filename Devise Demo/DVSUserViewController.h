//
//  DVSUserViewController.h
//  Devise
//
//  Created by Wojciech Trzasko on 09.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DVSUserViewController : UIViewController

@property (weak, nonatomic, readonly) UITextField *usernameTextField;
@property (weak, nonatomic, readonly) UITextField *passwordTextField;
@property (weak, nonatomic, readonly) UITextField *emailTextField;
@property (weak, nonatomic, readonly) UITextField *firstNameTextField;
@property (weak, nonatomic, readonly) UITextField *lastNameTextField;
@property (weak, nonatomic, readonly) UITextField *phoneTextField;

@end
