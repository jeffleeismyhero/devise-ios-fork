//
//  DVSUser.h
//
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DVSTypedefs.h"

@class DVSConfiguration;
@protocol DVSUserDataSource;

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
 *  User's data source.
 */
@property (weak, nonatomic) id <DVSUserDataSource> dataSource;

/**
 *  The HTTP client used by the model for networking purposes.
 */
@property (strong, nonatomic) DVSHTTPClient *httpClient;

/**
 *  The model's configuration object.
 */
+ (DVSConfiguration *)configuration;

/**
 *  Returns a parameter for given key and action.
 *
 *  @param key        The key for requested object.
 *  @param action     The action specifying where to search for the object for the given key.
 *  @return Instance of object for given key, stored for appropriate action.
 */
- (id)requestParameterForKey:(NSString *)key action:(DVSActionType)action;

/**
 *  Returns bunch of key-value pairs for given action.
 *
 *  @param action The action for which request parameters are stored.
 *  @return NSDictionary of parameters for given action.
 */
- (NSDictionary *)requestParametersForAction:(DVSActionType)action;

/**
 *  Set an object for given key and action. Objects are converted to parameters and used in query.
 *
 *  @param object     The value for key.
 *  @param key        The key for value. If other value for key already exists, object will replace that value.
 *  @param action     The action for which additional parameter will be added to query.
 */
- (void)setRequestParameter:(id)parameter forKey:(NSString *)key action:(DVSActionType)action;

/**
 *  Set bunch of key-value pairs for given action. Objects are converted to parameters and used when request is sending.
 *
 *  @param objects    NSDictionary of objects and keys stored for given action
 *  @param action     The action for which additional parameters will be added to query.
 */
- (void)setRequestParameters:(NSDictionary *)parameters forAction:(DVSActionType)action;

@end

@protocol DVSUserDataSource <NSObject>

@optional

/**
 *  Key for email parameter used in every request containing email field (default: "email").
 */
- (NSString *)JSONKeyPathForEmail;

/**
 *  Key for password parameter used in every request containing password field (default: "password").
 */
- (NSString *)JSONKeyPathForPassword;

/**
 *  Key for passwordConfirmation parameter used in every request containing passwordConfirmation field (default: "passwordConfirmation").
 */
- (NSString *)JSONKeyPathForPasswordConfirmation;

/**
 *  Allows to inject own customize validation rules. Used for validation when performing an action.
 */
- (NSArray *)additionalValidationRulesForAction:(DVSActionType)action;

/**
 *  Allows to inject own request parameters (key-value pairs). Used when performing an action.
 */
- (NSDictionary *)additionalRequestParametersForAction:(DVSActionType)action;

@end
