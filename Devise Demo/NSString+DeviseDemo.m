//
//  NSString+DeviseDemo.m
//  Devise
//
//  Created by Wojciech Trzasko on 18.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "NSString+DeviseDemo.h"

@implementation NSString (DeviseDemo)

- (NSNumber *)dvs_numberValue {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    return [formatter numberFromString:self];
}

@end
