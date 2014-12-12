//
//  DVSDemoUserDataSource.m
//  Devise
//
//  Created by Wojciech Trzasko on 12.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSDemoUserDataSource.h"

#import "DVSUser+Demo.h"

static NSString * const DVSUserPasswordParameter = @"password";

@implementation DVSDemoUserDataSource

+ (instancetype)dataSource {
    return [[[self class] alloc] init];
}

#pragma mark - DVSUserDataSource

- (NSArray *)additionalValidationRulesForAction:(DVSActionType)action {
    switch (action) {
        case DVSActionRegistration:
            return [self additionalValidationRulesForRegistration];
            
        case DVSActionChangePassword:
            return [self additionalValidationRulesForPasswordChange];
        
        default:
            return nil;
    }
}

- (NSArray *)additionalValidationRulesForRegistration {
    return @[DVSValidate(DVSDemoUserUsernameParameter).required().minLength(5).tooShort(@"is too short."),
             DVSValidate(DVSDemoUserFirstNameParameter).required().minLength(1),
             DVSValidate(DVSDemoUserLastNameParameter).required().minLength(1),
             DVSValidate(DVSUserPasswordParameter).minLength(5)];
}

- (NSArray *)additionalValidationRulesForPasswordChange {
    return @[DVSValidate(DVSUserPasswordParameter).minLength(5)];
}

@end
