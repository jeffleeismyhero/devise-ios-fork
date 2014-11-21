//
//  SSKDefines.h
//  SaasKit
//
//  Created by Patryk Kaczmarek on 19.11.2014.
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

@class SSKUser;

#ifndef SaasKit_SSKDefines_h
#define SaasKit_SSKDefines_h

    #ifdef __OBJC__

    typedef void (^SSKUserBlock)(SSKUser *user);
    typedef void (^SSKErrorBlock)(NSError *error);
    typedef void (^SSKBooleanBlock)(BOOL success);
    typedef void (^SSKObjectBlock)(id object);
    typedef void (^SSKVoidBlock)(void);
    typedef NSDictionary *(^SSKExtraParamsBlock)(void);

    #endif

#endif
