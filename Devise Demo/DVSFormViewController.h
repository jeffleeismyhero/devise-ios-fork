//
//  DVSFormTableViewController.h
//  Devise
//
//  Created by Wojciech Trzasko on 11.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DVSMacros.h"

@interface DVSFormViewController : UITableViewController

- (void)addFormWithTitleToDataSource:(NSString *)title accessibilityLabel:(NSString *)accessibilityLabel secured:(BOOL)secured;
- (void)addFormWithTitleToDataSource:(NSString *)title accessibilityLabel:(NSString *)accessibilityLabel keyboardType:(UIKeyboardType)keyboardType;

- (void)setValue:(NSString *)value forTitle:(NSString *)title;
- (NSString *)valueForTitle:(NSString *)title;

@end
