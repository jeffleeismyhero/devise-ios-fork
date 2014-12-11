//
//  DVSUser.h
//
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DVSTypedefs.h"

typedef NS_ENUM(NSInteger, DVSActionType) {
    DVSActionLogin,
    DVSActionRegistration,
    DVSActionRemindPassword,
    DVSActionChangePassword,
    DVSActionUpdate
};

@protocol DVSUserDataSource;

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
 *  Designed initilizer. Creates a new DVSUser object.
 *
 *  @return Instance of a new DVSUser object.
 */
+ (DVSUser *)user;

/**
 *  Returns an object for key for given action type.
 *
 *  @param key        The key for requested object.
 *  @param actionType The pointer for appropriate action (request) type values.
 *  @return Instance of object for given key, stored for appropriate action.
 */
- (id)objectForKey:(NSString *)key action:(DVSActionType)actionType;

/**
 *  Returns bunch of key-value pairs for given action type.
 *
 *  @param actionType The pointer for appropriate request values.
 *  @return NSDictionary of parameters for given action.
 */
- (NSDictionary *)objectsForAction:(DVSActionType)actionType;

/**
 *  Set an object for key for given action. Objects are converted to parameters and used when request is sending.
 *
 *  @param object     The value for key.
 *  @param key        The key for value. If key already exists, object takes its place.
 *  @param actionType The action pointer used for stored key-value pair.
 */
- (void)setObject:(id)object forKey:(NSString *)key action:(DVSActionType)actionType;

/**
 *  Set bunch of key-value pairs for given action type. Objects are converted to parameters and used when request is sending.
 *
 *  @param objects    NSDictionary of objects and keys stored for given action
 *  @param actionType The action pointer used for stored dicionary.
 */
- (void)setObjects:(NSDictionary *)objects forAction:(DVSActionType)actionType;

/**
 *  Login user asynchronously. When succeed user will be stored locally so
 *  calls to currentUser will return the latest logged in user.
 */
- (void)loginWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;

/**
 *  Login user asynchronously with additional parameters given as an NSDictionary. When succeed user will be stored locally so
 *  calls to currentUser will return the latest logged in user.
 *  Additional parameters can also be provided by (use DVSActionLogin as an action parameter):
 *  - additionalRequestParametersForAction: method, available via DVSUserDataSource protocol.
 *  - setObject:forKey:action method, used to set one key-value pair.
 *  - setObjects:forKey:action method, used to set bunch of key-value pairs.
 */
- (void)loginWithExtraParams:(DVSExtraParamsBlock)params success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;

/**
 *  Reminds user password asynchronously.
 */
- (void)remindPasswordWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;

/**
 *  Reminds user password asynchronously.
 *  Additional parameters can also be provided by (use DVSActionRemindPassword as an action parameter):
 *  - additionalRequestParametersForAction: method, available via DVSUserDataSource protocol.
 *  - setObject:forKey:action method, used to set one key-value pair.
 *  - setObjects:forKey:action method, used to set bunch of key-value pairs.
 */
- (void)remindPasswordWithExtraParams:(DVSExtraParamsBlock)params success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;

/**
 *  Reminds user password asynchronously.
 *  @param email   Receiver of recovery password message.
 */
+ (void)remindPasswordWithEmail:(NSString *)email success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;

/**
 *  Registers user asynchronously.
 */
- (void)registerWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;

/**
 *  Registers user asynchronously with additional parameters given as an NSDictionary.
 *  Additional parameters can also be provided by (use DVSActionRegistration as an action parameter):
 *  - additionalRequestParametersForAction: method, available via DVSUserDataSource protocol.
 *  - setObject:forKey:action method, used to set one key-value pair.
 *  - setObjects:forKey:action method, used to set bunch of key-value pairs.
 */
- (void)registerWithExtraParams:(DVSExtraParamsBlock)params success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;

/**
 *  Changes user password asynchronously.
 *  @param newPassword Password which will become a new password on succeed.
 */
- (void)changePasswordWithNewPassword:(NSString *)newPassword success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;

/**
 *  Changes user password asynchronously with additional parameters given as an NSDictionary.
 *  Additional parameters can also be provided by (use DVSActionChangePassword as an action parameter):
 *  - additionalRequestParametersForAction: method, available via DVSUserDataSource protocol.
 *  - setObject:forKey:action method, used to set one key-value pair.
 *  - setObjects:forKey:action method, used to set bunch of key-value pairs.
 *
 *  @param newPassword Password which will become a new password on succeed
 */
- (void)changePasswordWithNewPassword:(NSString *)newPassword extraParams:(DVSExtraParamsBlock)params success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;

/**
 *  Update user info asynchronously.
 */
- (void)updateWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;

/**
 *  Update user info asynchronously with additional parameters given as an NSDictionary.
 *  Additional parameters can also be provided by (use DVSActionUpdate as an action parameter):
 *  - additionalRequestParametersForAction: method, available via DVSUserDataSource protocol.
 *  - setObject:forKey:action method, used to set one key-value pair.
 *  - setObjects:forKey:action method, used to set bunch of key-value pairs.
 */
- (void)updateWithExtraParams:(DVSExtraParamsBlock)params success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;

/**
 *  Deletes account associated with user asynchronously. When succeed removes also user related data from keychain.
 */
- (void)deleteAccountWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;

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