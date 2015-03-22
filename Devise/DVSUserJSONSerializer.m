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
        self.JSONKeyPathForEmail = @"email";
        self.JSONKeyPathForPassword = @"password";
        self.JSONKeyPathForPasswordConfirmation = @"passwordConfirmation";
    }
    return self;
}

@end
