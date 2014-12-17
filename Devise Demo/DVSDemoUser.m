//
//  DVSDemoUser.m
//  Devise
//
//  Created by Patryk Kaczmarek on 15.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSDemoUser.h"

NSString * const DVSDemoUserUsernameParameter = @"username";
NSString * const DVSDemoUserFirstNameParameter = @"firstName";
NSString * const DVSDemoUserLastNameParameter = @"lastName";
NSString * const DVSDemoUserPhoneParameter = @"phone";

@implementation DVSDemoUser

#pragma mark - Accessors

- (void)setUsername:(NSString *)username {
    _username = username;
    [self setProperty:username forKey:DVSDemoUserUsernameParameter];
}

- (void)setFirstName:(NSString *)firstName {
    _firstName = firstName;
    [self setProperty:firstName forKey:DVSDemoUserFirstNameParameter];
}

- (void)setLastName:(NSString *)lastName {
    _lastName = lastName;
    [self setProperty:lastName forKey:DVSDemoUserLastNameParameter];
}

- (void)setPhone:(NSNumber *)phone {
    _phone = phone;
    [self setProperty:phone forKey:DVSDemoUserPhoneParameter];
}

#pragma mark - General accessors

- (void)setProperty:(id)property forKey:(NSString *)aKey {
    [self setRequestParameter:property forKey:aKey action:DVSActionRegistration];
}

@end
