//
//  NSDate+Devise.h
//  Devise
//
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Devise)

- (BOOL)dvs_isBetweenFirstDate:(NSDate *)firstDate lastDate:(NSDate *)lastDate inclusive:(BOOL)inclusive;
- (BOOL)dvs_isLaterThanOrEqualTo:(NSDate *)date;
- (BOOL)dvs_isEarlierThanOrEqualTo:(NSDate *)date;
- (BOOL)dvs_isLaterThan:(NSDate *)date;
- (BOOL)dvs_isEarlierThan:(NSDate *)date;

@end
