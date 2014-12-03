//
//  NSDate+Devise.m
//  Devise
//
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "NSDate+Devise.h"

@implementation NSDate (Devise)

- (BOOL)dvs_isBetweenFirstDate:(NSDate *)firstDate lastDate:(NSDate *)lastDate inclusive:(BOOL)inclusive {
    if (inclusive) {
        return !([self compare:firstDate] == NSOrderedAscending) && !([self compare:lastDate] == NSOrderedDescending);
    }
    return [self compare:firstDate] == NSOrderedDescending && [self compare:lastDate]  == NSOrderedAscending;
}

- (BOOL)dvs_isLaterThanOrEqualTo:(NSDate *)date {
    return !([self compare:date] == NSOrderedAscending);
}

- (BOOL)dvs_isEarlierThanOrEqualTo:(NSDate *)date {
    return !([self compare:date] == NSOrderedDescending);
}

- (BOOL)dvs_isLaterThan:(NSDate *)date {
    return ([self compare:date] == NSOrderedDescending);
    
}
- (BOOL)dvs_isEarlierThan:(NSDate *)date {
    return ([self compare:date] == NSOrderedAscending);
}

@end
