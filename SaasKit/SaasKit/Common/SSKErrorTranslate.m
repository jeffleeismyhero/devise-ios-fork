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
        case SSKErrorEmailEmpty:
            return NSLocalizedString(@"email cannot be empty", @"error localized description");
        case SSKErrorEmailSyntaxError:
            return NSLocalizedString(@"email has invalid syntax",  @"error localized description");
        case SSKErrorPasswordEmpty:
            return NSLocalizedString(@"password cannot be empty",  @"error localized description");
        case SSKErrorUsernameEmpty:
            return NSLocalizedString(@"username cannot be empty",  @"error localized description");
    }
}

#pragma mark - Private Methods

@end
