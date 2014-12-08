//
//  DVSTypedefs.h
//
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DVSUser;

typedef void (^DVSErrorBlock)(NSError *error);
typedef void (^DVSBooleanBlock)(BOOL success);
typedef void (^DVSResponseBlock)(id object, NSUInteger code);
typedef void (^DVSVoidBlock)(void);
typedef void (^DVSUserBlock)(DVSUser *user);

typedef NSError *(^DVSValidationBlock)(NSString *);
typedef NSDictionary *(^DVSExtraParamsBlock)(void);