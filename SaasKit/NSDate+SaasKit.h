//
//  NSDate+SaasKit.h
//  SaasKit
//
//  Created by Patryk Kaczmarek on 27.11.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (SaasKit)

- (BOOL)ssk_isBetweenFirstDate:(NSDate *)firstDate lastDate:(NSDate *)lastDate inclusive:(BOOL)inclusive;
- (BOOL)ssk_isLaterThanOrEqualTo:(NSDate *)date;
- (BOOL)ssk_isEarlierThanOrEqualTo:(NSDate *)date;
- (BOOL)ssk_isLaterThan:(NSDate *)date;
- (BOOL)ssk_isEarlierThan:(NSDate *)date;

@end
