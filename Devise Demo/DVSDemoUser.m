//
//  DVSDemoUser.m
//  Devise
//
//  Created by Wojciech Trzasko on 08.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSDemoUser.h"

NSString * const DVSDemoUserUsernameParameter = @"username";
NSString * const DVSDemoUserFirstNameParameter = @"firstName";
NSString * const DVSDemoUserLastNameParameter = @"lastName";
NSString * const DVSDemoUserPhoneParameter = @"phone";

@interface DVSDemoUser () <DVSUserDataSource>

@end

@implementation DVSDemoUser

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dataSource = self;
    }
    return self;
}

#pragma mark - Actions

- (void)registerWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    [self updateExtraParamsForAction:DVSRegistrationAction];
    [super registerWithSuccess:success failure:failure];
}

- (void)updateExtraParamsForAction:(DVSActionType)actionType {
    [self setObject:self.username forKey:DVSDemoUserUsernameParameter action:actionType];
    [self setObject:self.firstName forKey:DVSDemoUserFirstNameParameter action:actionType];
    [self setObject:self.lastName forKey:DVSDemoUserLastNameParameter action:actionType];
    [self setObject:self.phone forKey:DVSDemoUserPhoneParameter action:actionType];
}

#pragma mark - DVSUserDataSource

- (NSArray *)additionalValidationRulesForRegistration:(DVSUser *)user {
    return @[ validate(DVSDemoUserUsernameParameter).required().minLength(5).tooShort(@"is too short."),
              validate(DVSDemoUserFirstNameParameter).required().minLength(1),
              validate(DVSDemoUserLastNameParameter).required().minLength(1) ];
}

@end
