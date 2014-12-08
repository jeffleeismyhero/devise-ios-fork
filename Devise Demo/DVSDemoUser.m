//
//  DVSDemoUser.m
//  Devise
//
//  Created by Wojciech Trzasko on 08.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSDemoUser.h"

#import "DVSDemoUserDataSource.h"

NSString * const DVSDemoUserUsernameParameter = @"username";
NSString * const DVSDemoUserFirstNameParameter = @"firstName";
NSString * const DVSDemoUserLastNameParameter = @"lastName";
NSString * const DVSDemoUserPhoneParameter = @"phone";

@interface DVSDemoUser ()

@property (strong, nonatomic) DVSDemoUserDataSource *demoUserDataSource;

@end

@implementation DVSDemoUser

- (instancetype)init {
    self = [super init];
    if (self) {
        self.demoUserDataSource = [[DVSDemoUserDataSource alloc] init];
        self.dataSource = self.demoUserDataSource;
    }
    return self;
}

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


@end
