//
//  NSError+Devise.m
//  Devise
//
//  Created by Wojciech Trzasko on 12.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "NSError+Devise.h"

@implementation NSError (Devise)

typedef NS_ENUM(NSInteger, DVSErrorCode) {
    DVSErrorPasswordConfirmNotMatch = 101,
    DVSErrorNewPasswordNotMatch = 102
};

+ (NSError *)dvs_passwordConfirmError {
    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey: NSLocalizedString(@"Password confirm and current password do not match.", nil) };
    
    return [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                               code:DVSErrorPasswordConfirmNotMatch
                           userInfo:userInfo];
}

+ (NSError *)dvs_newPasswordConfirmError {
    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey: NSLocalizedString(@"New password and its confirm do not match.", nil) };
    
    return [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                               code:DVSErrorNewPasswordNotMatch
                           userInfo:userInfo];
}

@end
