//
//  DVSUserJSONSerializer.m
//  Devise
//
//  Created by Wojciech Trzasko on 12.02.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSUserJSONSerializer.h"

@implementation DVSUserJSONSerializer

- (instancetype)init {
    if (self = [super init]) {
        // Defaults
        _JSONKeyPathForEmail = @"email";
        _JSONKeyPathForUsername = @"username";
        _JSONKeyPathForLogin = @"login";
        _JSONKeyPathForPassword = @"password";
        _JSONKeyPathForPasswordConfirmation = @"passwordConfirmation";
        _JSONKeyPathForAuthenticationToken = @"authenticationToken";
        _JSONKeyPathForRemoteRoot = @"user";
    }
    return self;
}

@end
