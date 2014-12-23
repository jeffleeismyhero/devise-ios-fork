//
//  XLFormRowDescriptor+Devise.m
//  Devise
//
//  Created by Wojciech Trzasko on 23.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "XLFormRowDescriptor+Devise.h"

@implementation XLFormRowDescriptor (Devise)

- (void)dvs_customizeTextWithColor:(UIColor *)color alignment:(NSTextAlignment)alignment {
    [self.cellConfig setObject:color forKey:@"textLabel.textColor"];
    [self.cellConfig setObject:@(alignment) forKey:@"textLabel.textAlignment"];
}

@end
