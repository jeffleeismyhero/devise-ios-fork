//
//  DVSUser.h
//
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DVSTypedefs.h"
#import "DVSValidator.h"

typedef NS_ENUM(NSInteger, DVSActionType) {
    DVSActionLogin,
    DVSActionRegistration,
    DVSActionRemindPassword,
    DVSActionChangePassword,
    DVSActionUpdate
};

@protocol DVSUserDataSource;

@interface DVSUser : NSObject

/// User's email. Stored in keychain.
@property (strong, nonatomic) NSString *email;

/// User's password. Used only in user authentication. Will be not saved at all.
@property (strong, nonatomic) NSString *password;

/// User's session token. Is set by the server upon successful authentication.
/// Stored in keychain. Is automatically added for every request which requires it.
@property (nonatomic, strong) NSString *sessionToken;

/// User's data source.
@property (weak, nonatomic) id <DVSUserDataSource> dataSource;

+ (DVSUser *)user;

/// Gets the currently logged in user from disk and returns an instance of it. If there is none, returns nil.
+ (DVSUser *)currentUser;

/// Returns an object for key in given request type.
- (id)objectForKey:(NSString *)key action:(DVSActionType)actionType;

/// Returns dictionary of parameters for given request.
- (NSDictionary *)objectsForAction:(DVSActionType)actionType;

/// Sets an object for key in given request. Used in request sending.
- (void)setObject:(id)object forKey:(NSString *)key action:(DVSActionType)actionType;

/// Sets a dictionary for given request. Used in request sending.
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
 *  * additionalRequestParametersForAction: method, available via DVSUserDataSource protocol.
 *  * setObject:forKey:action method, used to set one key-value pair.
 *  * setObjects:forKey:action method, used to set bunch of key-value pairs.
 */
- (void)loginWithExtraParams:(DVSExtraParamsBlock)params success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;

/**
 *  Reminds user password asynchronously.
 */
- (void)remindPasswordWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;

/**
 *  Reminds user password asynchronously.
 *  Additional parameters can also be provided by (use DVSActionRemindPassword as an action parameter):
 *  * additionalRequestParametersForAction: method, available via DVSUserDataSource protocol.
 *  * setObject:forKey:action method, used to set one key-value pair.
 *  * setObjects:forKey:action method, used to set bunch of key-value pairs.
 */
- (void)remindPasswordWithExtraParams:(DVSExtraParamsBlock)params success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;

/**
 *  Reminds user password asynchronously.
 *
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
 *  * additionalRequestParametersForAction: method, available via DVSUserDataSource protocol.
 *  * setObject:forKey:action method, used to set one key-value pair.
 *  * setObjects:forKey:action method, used to set bunch of key-value pairs.
 */
- (void)registerWithExtraParams:(DVSExtraParamsBlock)params success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;

/**
 *  Changes user password asynchronously.
 *
 *  @param newPassword Password which will become a new password on succeed.
 */
- (void)changePasswordWithNewPassword:(NSString *)newPassword success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;

/**
 *  Changes user password asynchronously with additional parameters given as an NSDictionary.
 *  Additional parameters can also be provided by (use DVSActionChangePassword as an action parameter):
 *  * additionalRequestParametersForAction: method, available via DVSUserDataSource protocol.
 *  * setObject:forKey:action method, used to set one key-value pair.
 *  * setObjects:forKey:action method, used to set bunch of key-value pairs.
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
 *  * additionalRequestParametersForAction: method, available via DVSUserDataSource protocol.
 *  * setObject:forKey:action method, used to set one key-value pair.
 *  * setObjects:forKey:action method, used to set bunch of key-value pairs.
 */
- (void)updateWithExtraParams:(DVSExtraParamsBlock)params success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;

/**
 *  Deletes account associated with user asynchronously. When succeed removes also user related data from keychain.
 */
- (void)deleteAccountWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;

/**
 *   Logs out the currently logged in user and removes user related data from keychain.
 */
- (void)logout;

@end

@protocol DVSUserDataSource <NSObject>

@optional

/// Email parameter in every request which contains email field (default: "email").
- (NSString *)JSONKeyPathForEmail;

/// Password parameter in every request which contains password field (default: "password").
- (NSString *)JSONKeyPathForPassword;

/// Password parameter in every request which contains passwordConfirmation field (default: "passwordConfirmation").
- (NSString *)JSONKeyPathForPasswordConfirmation;

/// Allows customization in validation during process declared in DVSActionType.
- (NSArray *)additionalValidationRulesForAction:(DVSActionType)action;

/// Allows to specify additional parameters for action via protocol.
- (NSDictionary *)additionalRequestParametersForAction:(DVSActionType)action;

@end