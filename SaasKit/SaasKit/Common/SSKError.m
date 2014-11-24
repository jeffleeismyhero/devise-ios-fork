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

#pragma mark - Public Methods

+ (instancetype)errorWithCode:(SSKErrorCode)code param:(NSString *)param {
    NSString *description = [NSString stringWithFormat:@"Param '%@' %@", param, [SSKErrorTranslate translateErrorCode:code]];
    return [self errorWithDomain:SSKErrorDomain code:code
                        userInfo:@{NSLocalizedDescriptionKey:description}];

}

#pragma mark - Private Methods

@end
