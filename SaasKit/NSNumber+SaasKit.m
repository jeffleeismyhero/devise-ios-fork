//
//  NSNumber+SaasKit.m
//  SaasKit
//
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "NSNumber+SaasKit.h"

@implementation NSNumber (SaasKit)

- (BOOL)ssk_isGreaterThanOrEqualTo:(NSNumber *)number {
    return !([self compare:number] == NSOrderedAscending);
}

- (BOOL)ssk_isLessThanOrEqualTo:(NSNumber *)number {
    return !([self compare:number] == NSOrderedDescending);
}

- (BOOL)ssk_isGreaterThan:(NSNumber *)number {
    return ([self compare:number] == NSOrderedDescending);
}

- (BOOL)ssk_isLessThan:(NSNumber *)number {
    return ([self compare:number] == NSOrderedAscending);
}

@end
