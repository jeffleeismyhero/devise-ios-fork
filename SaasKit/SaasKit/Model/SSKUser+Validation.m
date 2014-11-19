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

- (BOOL)validateWithError:(NSError *__autoreleasing*)error {
    
    SSKWorkInProgress("sublass nserror to improve performance");
    
    if ([self.password isEmpty]) {
        *error = [self errorWithMessage:@"password empty"];
        return NO;
    }
    
    switch (self.loginMethod) {
        case SSKLoginUsingEmail:
            if ([self.email isEmpty] || [self.email hasValidEmailSyntax]) {
                *error = [self errorWithMessage:@"wrong email"];
                return NO;
            }
            break;
            
        case SSKLoginUsingUsername:
            if ([self.username isEmpty]) {
                *error = [self errorWithMessage:@"username empty"];
                return NO;
            }
            break;
    }
    
    return YES;
}

- (NSError *)errorWithMessage:(NSString *)message {
    return [NSError errorWithDomain:SSKErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey : message}];
}

@end
