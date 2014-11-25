//
//  SSKUser+Validation.m
//
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "SSKUser+Validation.h"
#import "NSString+SassKit.h"
#import "NSError+SassKit.h"
#import "SSKMacros.h"

SSKWorkInProgress("Improve validation to be more flexible and pro");

@implementation SSKUser (Validation)

- (BOOL)validateForLoginWithError:(NSError * __autoreleasing *)error {

    if (self.password.ssk_isEmpty) {
        if (error != NULL) *error = [NSError ssk_errorWithCode:SSKErrorParamEmpty parameter:@"password"];
        return NO;
    }

    switch (self.loginMethod) {

        case SSKLoginMethodEmail:
            if (self.email.ssk_isEmpty) {
                if (error != NULL) *error = [NSError ssk_errorWithCode:SSKErrorParamEmpty parameter:@"email"];
                return NO;
            } else if (!self.email.ssk_isEmail) {
                if (error != NULL) *error = [NSError ssk_errorWithCode:SSKErrorParamSyntaxInvalid parameter:@"email"];
                return NO;
            }
            break;

        case SSKLoginMethodUsername:
            if (self.username.ssk_isEmpty) {
                if (error != NULL) *error = [NSError ssk_errorWithCode:SSKErrorParamEmpty parameter:@"username"];
                return NO;
            }
            break;

        default:
            return NO;
    }

    return YES;

}

- (BOOL)validateForRegisterWithError:(NSError * __autoreleasing *)error {

    if (self.password.ssk_isEmpty) {
        if (error != NULL) *error = [NSError ssk_errorWithCode:SSKErrorParamEmpty parameter:@"password"];
        return NO;
    }

    return YES;
}

- (BOOL)validateForForgotPasswordWithError:(NSError * __autoreleasing *)error {

    if (self.email.ssk_isEmpty) {
        if (error != NULL) *error = [NSError ssk_errorWithCode:SSKErrorParamEmpty parameter:@"email"];
        return NO;
    } else if (!self.email.ssk_isEmail) {
        if (error != NULL) *error = [NSError ssk_errorWithCode:SSKErrorParamSyntaxInvalid parameter:@"email"];
        return NO;
    }

    return YES;

}

@end
