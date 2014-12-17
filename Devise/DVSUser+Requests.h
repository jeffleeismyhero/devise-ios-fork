//
//  DVSUser+Requests.h
//  Devise
//
//  Created by Adrian Kashivskyy on 17.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <Devise/Devise.h>

@interface DVSUser (Requests)

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
 */
- (void)changePasswordWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;

/**
 *  Changes user password asynchronously with additional parameters given as an NSDictionary.
 *  Additional parameters can also be provided by (use DVSActionChangePassword as an action parameter):
 *  - additionalRequestParametersForAction: method, available via DVSUserDataSource protocol.
 *  - setObject:forKey:action method, used to set one key-value pair.
 *  - setObjects:forKey:action method, used to set bunch of key-value pairs.
 */
- (void)changePasswordWithExtraParams:(DVSExtraParamsBlock)params success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;

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

/**
 *  Deletes locally stored user.
 */
- (void)logout;

@end
