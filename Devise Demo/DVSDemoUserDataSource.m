//
//  DVSDemoUserDataSource.m
//  Devise
//
//  Created by Wojciech Trzasko on 12.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSDemoUserDataSource.h"

#import "DVSDemoUser.h"

static NSString * const DVSUserPasswordParameter = @"password";
static NSString * const DVSUserEmailParameter = @"email";

@implementation DVSDemoUserDataSource

#pragma mark - DVSUserDataSource

- (NSArray *)additionalValidationRulesForAction:(DVSActionType)action {
    switch (action) {
        case DVSActionLogin:
            return [self additionalValidationRulesForLogin];
            
        case DVSActionRegistration:
            return [self additionalValidationRulesForRegistration];
            
        case DVSActionChangePassword:
            return [self additionalValidationRulesForPasswordChange];
        
        case DVSActionUpdate:
        case DVSActionRemindPassword:
            return [self additionalValidationRulesForUpdateAndRemindPassword];
    }
}

#pragma mark - Validators for specific actions

- (NSArray *)additionalValidationRulesForLogin {
    return @[[self defaultDemoValidatorForEmail],
             DVSValidate(DVSUserPasswordParameter).localizedPropertyName(NSLocalizedString(@"Password", nil))
             .minLength(5).tooShort(NSLocalizedString(@"is wrong.", nil))];
}

- (NSArray *)additionalValidationRulesForRegistration {
    return @[[self defaultDemoValidatorForEmail],
             [self defaultDemoValidatorForPassword],
             DVSValidate(DVSDemoUserUsernameParameter).localizedPropertyName(NSLocalizedString(@"Username", nil))
                                                      .required()
                                                      .minLength(5).tooShort(NSLocalizedString(@"should have at least 5 characters.", nil)),
             DVSValidate(DVSDemoUserFirstNameParameter).localizedPropertyName(NSLocalizedString(@"First name", nil))
                                                       .required()
                                                       .minLength(1).tooShort(NSLocalizedString(@"can't be empty.", nil)),
             DVSValidate(DVSDemoUserLastNameParameter).localizedPropertyName(NSLocalizedString(@"Last name", nil))
                                                      .required()
                                                      .minLength(1).tooShort(NSLocalizedString(@"can't be empty.", nil))
             ];
}

- (NSArray *)additionalValidationRulesForUpdateAndRemindPassword {
    return @[[self defaultDemoValidatorForEmail]];
}

- (NSArray *)additionalValidationRulesForPasswordChange {
    return @[DVSValidate(DVSUserPasswordParameter).localizedPropertyName(NSLocalizedString(@"New password", nil)).minLength(5).tooShort(NSLocalizedString(@"should have at least 5 characters.", nil))];
}

#pragma mark - Default demo validators

- (DVSPropertyValidator *)defaultDemoValidatorForEmail {
    return DVSValidate(DVSUserEmailParameter).localizedPropertyName(NSLocalizedString(@"E-mail", nil));
}

- (DVSPropertyValidator *)defaultDemoValidatorForPassword {
    return DVSValidate(DVSUserPasswordParameter).localizedPropertyName(NSLocalizedString(@"Password", nil))
                                                .minLength(5).tooShort(NSLocalizedString(@"should have at least 5 characters.", nil));
}

@end
