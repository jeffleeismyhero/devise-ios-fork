//
//  NSError+Devise.m
//  Devise
//
//  Created by Wojciech Trzasko on 12.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "NSError+DeviseDemo.h"

#import <AFNetworking/AFNetworking.h>

@implementation NSError (DeviseDemo)

NSString * const DVSDemoErrorDomain = @"co.netguru.lib.devise.demo.error";

typedef NS_ENUM(NSInteger, DVSErrorCode) {
    DVSErrorPasswordConfirmNotMatch = 101,
    DVSErrorNewPasswordConfirmNotMatch = 102,
    DVSErrorPasswordRequired = 103,
    DVSErrorNewPasswordRequired = 104,
    DVSErrorNewPasswordConfirmRequired = 105,
    
};

+ (NSError *)dvs_passwordConfirmError {
    return [NSError dvs_errorForCode:DVSErrorPasswordConfirmNotMatch
                localizedDescription:NSLocalizedString(@"Password confirm and current password do not match.", nil)];
}

+ (NSError *)dvs_newPasswordRequiredError {
    return [NSError dvs_errorForCode:DVSErrorNewPasswordRequired
                localizedDescription:NSLocalizedString(@"New password is required.", nil)];
}

+ (NSError *)dvs_newPasswordConfirmMatchError {
    return [self dvs_errorForCode:DVSErrorNewPasswordRequired
             localizedDescription:NSLocalizedString(@"Passwords do not match.", nil)];
}

+ (NSError *)dvs_newPasswordConfirmRequiredError {
    return [self dvs_errorForCode:DVSErrorNewPasswordConfirmNotMatch
             localizedDescription:NSLocalizedString(@"New password confirm is required.", nil)];
}

+ (NSError *)dvs_currentPasswordRequiredError {
    return [NSError dvs_errorForCode:DVSErrorPasswordRequired
                localizedDescription:NSLocalizedString(@"Current password is required.", nil)];
}

+ (NSError *)dvs_errorForCode:(NSInteger)code localizedDescription:(NSString *)localizedDescription {
    return [NSError errorWithDomain:DVSDemoErrorDomain
                               code:code
                           userInfo:@{ NSLocalizedDescriptionKey: localizedDescription}];
}

- (NSInteger)dvs_urlStatusCode {
    return [self.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
}

@end
