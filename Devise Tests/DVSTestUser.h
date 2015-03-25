//
//  DVSTestUser.h
//
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <Devise/Devise.h>
#import <Foundation/Foundation.h>

@interface DVSTestUser : DVSUser

/**
 *  User's unique identifier, set by the server-side database.
 *
 *  This property is read-write in the test class.
 */
@property (strong, nonatomic, readwrite) NSString *identifier;

/**
 *  User's session token. Is set by the server upon successful authentication.
 *  Stored in keychain. Is automatically added for every request which requires it.
 *
 *  This property is read-write in the test class.
 */
@property (strong, nonatomic, readwrite) NSString *sessionToken;

/**
 *  User's name.
 *
 *  This property should be used for test requests with additional parameters.
 */
@property (strong, nonatomic) NSString *name;

@end
