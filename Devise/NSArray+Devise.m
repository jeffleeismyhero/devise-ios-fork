//
//  NSArray+Devise.m
//  Devise
//
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "NSArray+Devise.h"

@implementation NSArray (Devise)

- (BOOL)dvs_containsString:(NSString *)string {
    for (NSString *str in self) {
        if ([str isEqualToString:string]) {
            return YES;
        }
    }
    return NO;
}

@end
