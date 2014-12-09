//
//  DVSDemoUser.h
//  Devise
//
//  Created by Wojciech Trzasko on 08.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <Devise/Devise.h>

@interface DVSDemoUser : DVSUser

/// User's username.
@property (strong, nonatomic) NSString *username;

/// User's first name.
@property (strong, nonatomic) NSString *firstName;

/// User's last name.
@property (strong, nonatomic) NSString *lastName;

/// User's phone number.
@property (strong, nonatomic) NSString *phone;

@end
