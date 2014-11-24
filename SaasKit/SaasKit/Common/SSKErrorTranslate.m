//
//  SSKErrorTranslate.m
//  SaasKit
//
//  Created by Patryk Kaczmarek on 19.11.2014.
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import "SSKErrorTranslate.h"

@implementation SSKErrorTranslate

#pragma mark - Public Methods

+ (NSString *)translateErrorCode:(SSKErrorCode)code {
    
    switch (code) {
        case SSKErrorInvalidSyntax:
            return NSLocalizedString(@"has invalid syntax",  @"error localized description");
        case SSKErrorParamEmpty:
            return NSLocalizedString(@"cannot be nil or empty",  @"error localized description");
    }
}

#pragma mark - Private Methods

@end
