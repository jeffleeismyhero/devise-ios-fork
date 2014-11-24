//
//  SSKUser+Validation.m
//  SaasKit
//
//  Created by Patryk Kaczmarek on 19.11.2014.
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import "SSKUser+Validation.h"
#import "NSString+SSKAdditions.h"

#import "SSKDefines.h"
#import "SSKMacros.h"

@implementation SSKUser (Validation)


SSKWorkInProgress("Improve validation to be more flexible and pro");

#pragma mark - Public Methods

- (BOOL)loginValidationWithError:(SSKError *__autoreleasing*)error {
    
    if (![self.password isNotEmpty]) {
        *error = [SSKError errorWithCode:SSKErrorParamEmpty param:self.password];
        return NO;
    }
    
    switch (self.loginMethod) {
        case SSKLoginUsingEmail:
            if (![self.email isNotEmpty]) {
                *error = [SSKError errorWithCode:SSKErrorParamEmpty param:self.email];
                return NO;
            } else if (![self.email hasValidEmailSyntax]) {
                *error = [SSKError errorWithCode:SSKErrorInvalidSyntax param:self.email];
                return NO;
            }
            break;
            
        case SSKLoginUsingUsername:
            if (![self.username isNotEmpty]) {
                *error = [SSKError errorWithCode:SSKErrorParamEmpty param:self.username];
                return NO;
            }
            break;
    }
    return YES;
}

- (BOOL)remindPasswordValidationWithError:(SSKError *__autoreleasing*)error {
    
    if (![self.email hasValidEmailSyntax]) {
        *error = [SSKError errorWithCode:SSKErrorInvalidSyntax param:self.email];
        return NO;
    }
    return YES;
}

- (BOOL)registrationValidationWithError:(SSKError *__autoreleasing *)error {
    
    if (![self.password isNotEmpty]) {
        *error = [SSKError errorWithCode:SSKErrorParamEmpty param:self.password];
        return NO;
    }
    return YES;
}

#pragma mark - Private Methods

@end