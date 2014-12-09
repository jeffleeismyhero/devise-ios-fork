//
//  DVSDemoUserDataSource.m
//  Devise
//
//  Created by Wojciech Trzasko on 08.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSDemoUserDataSource.h"

#import "DVSDemoUser.h"

@implementation DVSDemoUserDataSource

- (NSArray *)additionalValidationRulesForRegistration:(DVSUser *)user {
    return @[ validate(DVSDemoUserUsernameParameter).required().minLength(5).tooShort(@"Username is too short."),
              validate(DVSDemoUserFirstNameParameter).required(),
              validate(DVSDemoUserLastNameParameter).required() ];
}

@end
