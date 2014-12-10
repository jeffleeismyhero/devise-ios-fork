//
//  DVSDemoUser.m
//  Devise
//
//  Created by Wojciech Trzasko on 08.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSDemoUser.h"

#import "DVSUser+Demo.h"

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

#pragma mark - DVSUserDataSource

- (NSArray *)additionalValidationRulesForAction:(DVSActionType)action {
    
    if (action == DVSActionRegistration) {
        return @[validate(DVSDemoUserUsernameParameter).required().minLength(5).tooShort(@"is too short."),
                 validate(DVSDemoUserFirstNameParameter).required().minLength(1),
                 validate(DVSDemoUserLastNameParameter).required().minLength(1)];
    }
    return nil;
}

@end
