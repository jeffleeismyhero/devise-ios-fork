//
//  NSDate+SaasKit.m
//  SaasKit
//
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "NSDate+SaasKit.h"

@implementation NSDate (SaasKit)

- (BOOL)ssk_isBetweenFirstDate:(NSDate *)firstDate lastDate:(NSDate *)lastDate inclusive:(BOOL)inclusive {
    if (inclusive) {
        return !([self compare:firstDate] == NSOrderedAscending) && !([self compare:lastDate] == NSOrderedDescending);
    }
    return [self compare:firstDate] == NSOrderedDescending && [self compare:lastDate]  == NSOrderedAscending;
}

- (BOOL)ssk_isLaterThanOrEqualTo:(NSDate *)date {
    return !([self compare:date] == NSOrderedAscending);
}

- (BOOL)ssk_isEarlierThanOrEqualTo:(NSDate *)date {
    return !([self compare:date] == NSOrderedDescending);
}

- (BOOL)ssk_isLaterThan:(NSDate *)date {
    return ([self compare:date] == NSOrderedDescending);
    
}
- (BOOL)ssk_isEarlierThan:(NSDate *)date {
    return ([self compare:date] == NSOrderedAscending);
}

@end
