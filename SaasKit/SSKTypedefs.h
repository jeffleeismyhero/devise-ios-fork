//
//  SSKTypedefs.h
//
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SSKUser;

typedef void (^SSKErrorBlock)(NSError *error);
typedef void (^SSKBooleanBlock)(BOOL success);
typedef void (^SSKObjectBlock)(id object);
typedef void (^SSKVoidBlock)(void);
typedef void (^SSKUserBlock)(SSKUser *user);

typedef NSError *(^SSKValidationBlock)(NSString *);
typedef NSDictionary *(^SSKExtraParamsBlock)(void);