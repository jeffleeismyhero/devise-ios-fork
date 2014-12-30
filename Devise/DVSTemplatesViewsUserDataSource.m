//
//  DVSLoginViewUserDataSource.m
//  Devise
//
//  Created by Wojciech Trzasko on 22.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSTemplatesViewsUserDataSource.h"

#import "DVSValidator.h"

static NSString * const DVSUserPasswordParameter = @"password";
static NSString * const DVSUserEmailParameter = @"email";

static NSString * const DVSUserPasswordPropertyName = @"Password";
static NSUInteger const DVSUserPasswordMinLength = 5;

@implementation DVSTemplatesViewsUserDataSource

#pragma mark - Validation for actions

- (NSArray *)additionalValidationRulesForAction:(DVSActionType)action {
    switch (action) {
        case DVSActionLogin:
            return [self additionalValidationRulesForLogin];
            
        case DVSActionRegistration:
            return [self additionalValidationRulesForRegistration];
            
        case DVSActionRemindPassword:
            return [self additionalValidationRulesForRemindPassword];
            
        default:
            return nil;
    }
}

- (NSArray *)additionalValidationRulesForLogin {
    return @[[self defaultEmailValidator],
             DVSValidate(DVSUserPasswordParameter).localizedPropertyName(NSLocalizedString(DVSUserPasswordPropertyName, nil))
                                                  .minLength(DVSUserPasswordMinLength).tooShort(NSLocalizedString(@"is wrong.", nil))];
}

- (NSArray *)additionalValidationRulesForRegistration {
    return @[[self defaultEmailValidator],
             DVSValidate(DVSUserPasswordParameter).localizedPropertyName(NSLocalizedString(DVSUserPasswordPropertyName, nil))
                                                  .minLength(DVSUserPasswordMinLength).tooShort(NSLocalizedFormatString(@"should have at least %ld characters.", DVSUserPasswordMinLength))];
}

- (NSArray *)additionalValidationRulesForRemindPassword {
    return @[[self defaultEmailValidator]];
}

#pragma mark - Default validators

- (DVSPropertyValidator *)defaultEmailValidator {
    return DVSValidate(DVSUserEmailParameter).localizedPropertyName(NSLocalizedString(@"E-mail", nil));
}

@end
