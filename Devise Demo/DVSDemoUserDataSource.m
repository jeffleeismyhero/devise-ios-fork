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

+ (instancetype)dataSource {
    return [[[self class] alloc] init];
}

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
             DVSValidate(DVSUserPasswordParameter).localizedPropertyName(@"Password")
             .minLength(5).tooShort(@"is wrong.")];
}

- (NSArray *)additionalValidationRulesForRegistration {
    return @[[self defaultDemoValidatorForEmail],
             [self defaultDemoValidatorForPassword],
             DVSValidate(DVSDemoUserUsernameParameter).localizedPropertyName(@"Username")
                                                      .required()
                                                      .minLength(5).tooShort(@"should has at least 5 characters."),
             DVSValidate(DVSDemoUserFirstNameParameter).localizedPropertyName(@"First name")
                                                       .required()
                                                       .minLength(1).tooShort(@"can't be empty."),
             DVSValidate(DVSDemoUserLastNameParameter).localizedPropertyName(@"Last name")
                                                      .required()
                                                      .minLength(1).tooShort(@"can't be empty.")
             ];
}

- (NSArray *)additionalValidationRulesForUpdateAndRemindPassword {
    return @[[self defaultDemoValidatorForEmail]];
}

- (NSArray *)additionalValidationRulesForPasswordChange {
    return @[DVSValidate(DVSUserPasswordParameter).localizedPropertyName(@"New password").minLength(5).tooShort(@"should has at least 5 characters.")];
}

#pragma mark - Default demo validators

- (DVSPropertyValidator *)defaultDemoValidatorForEmail {
    return DVSValidate(DVSUserEmailParameter).localizedPropertyName(@"E-mail");
}

- (DVSPropertyValidator *)defaultDemoValidatorForPassword {
    return DVSValidate(DVSUserPasswordParameter).localizedPropertyName(@"Password")
                                                .minLength(5).tooShort(@"should has at least 5 characters.");
}

@end
