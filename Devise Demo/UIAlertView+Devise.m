//
//  UIAlertView+Devise.m
//  Devise
//
//  Created by Wojciech Trzasko on 09.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "UIAlertView+Devise.h"

@implementation UIAlertView (Devise)

+ (UIAlertView *)dvs_alertViewForError:(NSError *)error {
    return [[UIAlertView alloc] initWithTitle:@"Error"
                                      message:error.localizedDescription
                                     delegate:nil
                            cancelButtonTitle:@"Close"
                            otherButtonTitles:nil];
}

@end
