//
//  DVSLoginViewUserDataSource.m
//  Devise
//
//  Created by Wojciech Trzasko on 22.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSLoginViewUserDataSource.h"

#import "DVSValidator.h"

static NSString * const DVSUserPasswordParameter = @"password";
static NSString * const DVSUserEmailParameter = @"email";

@implementation DVSLoginViewUserDataSource

- (NSArray *)additionalValidationRulesForAction:(DVSActionType)action {
    switch (action) {
        case DVSActionLogin:
            return [self additionalValidationRulesForLogin];
            
        default:
            return @[];
    }
}

- (NSArray *)additionalValidationRulesForLogin {
    return @[DVSValidate(DVSUserEmailParameter).localizedPropertyName(NSLocalizedString(@"E-mail", nil)),
             DVSValidate(DVSUserPasswordParameter).localizedPropertyName(NSLocalizedString(@"Password", nil))
             .minLength(5).tooShort(NSLocalizedString(@"is wrong.", nil))];
}

@end
