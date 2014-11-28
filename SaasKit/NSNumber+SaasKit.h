//
//  NSNumber+SaasKit.h
//  SaasKit
//
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (SaasKit)

- (BOOL)ssk_isGreaterThanOrEqualTo:(NSNumber *)number;
- (BOOL)ssk_isLessThanOrEqualTo:(NSNumber *)number;
- (BOOL)ssk_isGreaterThan:(NSNumber *)number;
- (BOOL)ssk_isLessThan:(NSNumber *)number;

@end
