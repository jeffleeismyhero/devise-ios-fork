//
//  SSKError.m
//  SaasKit
//
//  Created by Patryk Kaczmarek on 19.11.2014.
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import "SSKError.h"

#define SSKErrorDomain @"com.netguru.saaskit.error.domain"

@implementation SSKError

+ (instancetype)errorWithCode:(SSKErrorCode)code {
    return [self errorWithDomain:SSKErrorDomain code:code
                        userInfo:@{NSLocalizedDescriptionKey:[SSKErrorTranslate translateErrorCode:code]}];

}

@end
