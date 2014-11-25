//
//  SSKUser+Validation.h
//  
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSKUser.h"

@interface SSKUser (Validation)

/// Validates a user for login.
///
/// @param error An optional validation error.
///
/// @returns A boolean value representing the validation result.
- (BOOL)validateForLoginWithError:(NSError **)error;

/// Validates a user for registration.
///
/// @param error An optional validation error.
///
/// @returns A boolean value representing the validation result.
- (BOOL)validateForRegisterWithError:(NSError **)error;

/// Validates a user for forgot password.
///
/// @param error An optional validation error.
///
/// @returns A boolean value representing the validation result.
- (BOOL)validateForForgotPasswordWithError:(NSError **)error;

@end
