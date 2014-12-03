//
//  NSNumber+Devise.h
//  Devise
//
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (Devise)

- (BOOL)dvs_isGreaterThanOrEqualTo:(NSNumber *)number;
- (BOOL)dvs_isLessThanOrEqualTo:(NSNumber *)number;
- (BOOL)dvs_isGreaterThan:(NSNumber *)number;
- (BOOL)dvs_isLessThan:(NSNumber *)number;

@end
