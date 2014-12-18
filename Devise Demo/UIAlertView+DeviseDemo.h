//
//  UIAlertView+DeviseDemo.h
//  Devise
//
//  Created by Wojciech Trzasko on 09.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (DeviseDemo)

+ (UIAlertView *)dvs_alertViewForError:(NSError *)error;
+ (UIAlertView *)dvs_alertViewForError:(NSError *)error statusDescriptionsDictionary:(NSDictionary *)dictionary;

@end
