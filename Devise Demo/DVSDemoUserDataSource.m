//
//  DVSDemoUserDataSource.m
//  Devise
//
//  Created by Wojciech Trzasko on 12.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSDemoUserDataSource.h"
#import "DVSDemoUser.h"
#import "NGRValidator.h"

static NSString * const DVSUserPasswordParameter = @"password";
static NSString * const DVSUserEmailParameter = @"email";

@implementation DVSDemoUserDataSource

#pragma mark - DVSUserDataSource

- (NSArray *)additionalValidationRulesForAction:(DVSActionType)action defaultRules:(NSArray *)defaultRules {

    for (NGRPropertyValidator *validator in defaultRules) {
        if ([validator.property isEqualToString:DVSUserEmailParameter]) {
            validator.localizedName(@"E-mail");
            
        } else if ([validator.property isEqualToString:DVSUserPasswordParameter]) {
            validator.localizedName(NSLocalizedString(@"Password", nil)).minLength(5);
            
            switch (action) {
                case DVSActionLogin:
                    validator.msgTooShort(NSLocalizedString(@"is wrong.", nil));
                    break;
                case DVSActionRegistration:
                    validator.msgTooShort(NSLocalizedString(@"should have at least 5 characters.", nil));
                    break;
                    
                default:
                    break;
            }
        }
    }
    
    switch (action) {
        case DVSActionRegistration:
            return [self additionalValidationRulesForRegistration];
            
        case DVSActionChangePassword:
            return [self additionalValidationRulesForPasswordChange];

        default:
            return nil;
    }
}

#pragma mark - Validators for specific actions

- (NSArray *)additionalValidationRulesForRegistration {
    return @[NGRValidate(DVSDemoUserUsernameParameter).localizedName(NSLocalizedString(@"Username", nil))
                                                      .required()
                                                      .minLength(5).msgTooShort(NSLocalizedString(@"should have at least 5 characters.", nil)),
             NGRValidate(DVSDemoUserFirstNameParameter).localizedName(NSLocalizedString(@"First name", nil))
                                                       .required()
                                                       .minLength(1).msgTooShort(NSLocalizedString(@"can't be empty.", nil)),
             NGRValidate(DVSDemoUserLastNameParameter).localizedName(NSLocalizedString(@"Last name", nil))
                                                      .required()
                                                      .minLength(1).msgTooShort(NSLocalizedString(@"can't be empty.", nil))
             ];
}

- (NSArray *)additionalValidationRulesForPasswordChange {
    return @[NGRValidate(DVSUserPasswordParameter).localizedName(NSLocalizedString(@"New password", nil)).minLength(5).msgTooShort(NSLocalizedString(@"should have at least 5 characters.", nil))];
}

@end
