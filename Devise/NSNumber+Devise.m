//
//  NSNumber+Devise.m
//  Devise
//
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "NSNumber+Devise.h"

@implementation NSNumber (Devise)

- (BOOL)dvs_isGreaterThanOrEqualTo:(NSNumber *)number {
    return !([self compare:number] == NSOrderedAscending);
}

- (BOOL)dvs_isLessThanOrEqualTo:(NSNumber *)number {
    return !([self compare:number] == NSOrderedDescending);
}

- (BOOL)dvs_isGreaterThan:(NSNumber *)number {
    return ([self compare:number] == NSOrderedDescending);
}

- (BOOL)dvs_isLessThan:(NSNumber *)number {
    return ([self compare:number] == NSOrderedAscending);
}

@end
