//
//  DVSViewController.m
//  Devise
//
//  Created by Wojciech Trzasko on 23.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSBaseViewController.h"

@implementation DVSBaseViewController

#pragma mark - Helpers

- (BOOL)shouldShow:(NSUInteger)option basedOn:(NSUInteger)value {
    return (value & option) == option;
}

@end
