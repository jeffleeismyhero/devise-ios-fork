//
//  DVSDemoUser.h
//  Devise
//
//  Created by Patryk Kaczmarek on 15.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <Devise/Devise.h>

extern NSString * const DVSDemoUserUsernameParameter;
extern NSString * const DVSDemoUserFirstNameParameter;
extern NSString * const DVSDemoUserLastNameParameter;
extern NSString * const DVSDemoUserPhoneParameter;

@interface DVSDemoUser : DVSUser <DVSUserPersisting>

/// User's username.
@property (strong, nonatomic) NSString *username;

/// User's first name.
@property (strong, nonatomic) NSString *firstName;

/// User's last name.
@property (strong, nonatomic) NSString *lastName;

/// User's phone number.
@property (strong, nonatomic) NSString *phone;

@end
