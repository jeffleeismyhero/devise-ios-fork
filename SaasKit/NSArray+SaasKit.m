//
//  NSArray+SaasKit.m
//  SaasKit
//
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "NSArray+SaasKit.h"

@implementation NSArray (SaasKit)

- (BOOL)ssk_containsString:(NSString *)string {
    for (NSString *str in self) {
        if ([str isEqualToString:string]) {
            return YES;
        }
    }
    return NO;
}

@end
