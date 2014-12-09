//
//  UIAlertView+Devise.h
//  Devise
//
//  Created by Wojciech Trzasko on 09.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (Devise)

+ (UIAlertView *)dvs_alertViewForError:(NSError *)error;

@end
