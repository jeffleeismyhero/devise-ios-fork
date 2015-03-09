//
//  DVSUser.h
//
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DVSTypedefs.h"

@class DVSConfiguration, DVSHTTPClient;

typedef NS_ENUM(NSInteger, DVSActionType) {
    DVSActionLogin,
    DVSActionRegistration,
    DVSActionRemindPassword,
    DVSActionChangePassword,
    DVSActionUpdate
};

@interface DVSUser : NSObject

/**
 *  User's unique identifier, set by the server-side database.
 */
@property (strong, nonatomic, readonly) NSString *identifier;

/**
 *  User's email. Stored in keychain.
 */
@property (strong, nonatomic) NSString *email;

/**
 *  User's password. Used only in user authentication. Will be not saved at all.
 */
@property (strong, nonatomic) NSString *password;

/**
 *  User's session token. Is set by the server upon successful authentication.
 *  Stored in keychain. Is automatically added for every request which requires it.
 */
@property (strong, nonatomic, readonly) NSString *sessionToken;

/**
 *  Set an object for given key and action. Objects are converted to parameters and used in query.
 *
 *  @param object     The value for key.
 *  @param key        The key for value. If other value for key already exists, object will replace that value.
 *  @param action     The action for which additional parameter will be added to query.
 */
- (void)setRequestParameter:(id)parameter forKey:(NSString *)key action:(DVSActionType)action;

@end
