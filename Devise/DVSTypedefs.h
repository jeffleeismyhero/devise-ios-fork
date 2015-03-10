//
//  DVSTypedefs.h
//
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DVSUser;

typedef void (^DVSErrorBlock)(NSError *error);
typedef void (^DVSVoidBlock)(void);
typedef void (^DVSFacebookParametersBlock)(BOOL obtained, NSDictionary *parameters, NSError *error);

typedef NSDictionary *(^DVSExtraParamsBlock)(void);
