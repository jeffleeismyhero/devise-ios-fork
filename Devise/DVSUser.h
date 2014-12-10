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

/// User's email. Stored in keychain
@property (strong, nonatomic) NSString *email;

/// User's password. Used only in user authentication. Will be not saved at all
@property (strong, nonatomic) NSString *password;

/// User's session token. Is set by the server upon successful authentication.
/// Stored in keychain. Is automatically added for every request which requires it.
@property (nonatomic, strong) NSString *sessionToken;

/// User's data source.
@property (weak, nonatomic) id <DVSUserDataSource> dataSource;

+ (DVSUser *)user;

/// Gets the currently logged in user from disk and returns an instance of it. If there is none, returns nil.
+ (DVSUser *)currentUser;

/// Returns an object for key in given request type
- (id)objectForKey:(NSString *)key action:(DVSActionType)actionType;

/// Returns dictionary of parameters for given request
- (NSDictionary *)objectsForAction:(DVSActionType)actionType;

/// Sets an object for key in given request. Used in request sending.
- (void)setObject:(id)object forKey:(NSString *)key action:(DVSActionType)actionType;

/// Sets a dictionary for given request. Used in request sending.
- (void)setObjects:(NSDictionary *)objects forAction:(DVSActionType)actionType;

- (void)loginWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;
- (void)loginWithExtraParams:(DVSExtraParamsBlock)params success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;

- (void)remindPasswordWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;
- (void)remindPasswordWithExtraParams:(DVSExtraParamsBlock)params success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;
+ (void)remindPasswordWithEmail:(NSString *)email success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;

- (void)registerWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;
- (void)registerWithExtraParams:(DVSExtraParamsBlock)params success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;

- (void)changePasswordWithNewPassword:(NSString *)newPassword success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;
- (void)changePasswordWithNewPassword:(NSString *)newPassword extraParams:(DVSExtraParamsBlock)params success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;

- (void)updateWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;
- (void)updateWithExtraParams:(DVSExtraParamsBlock)params success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;

- (void)deleteAccountWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;

- (void)logout;

@end

@protocol DVSUserDataSource <NSObject>

@optional

/// Email parameter in login route (default: "email").
- (NSString *)JSONKeyPathForEmail;

/// Password parameter in login route (default: "password").
- (NSString *)JSONKeyPathForPassword;

/// Password parameter in login route (default: "passwordConfirmation").
- (NSString *)JSONKeyPathForPasswordConfirmation;

/// Allows customization in validation during process declared in DVSActionType.
- (NSArray *)additionalValidationRulesForAction:(DVSActionType)action;

/// Allows to specify additional parameters for action via protocol. Remember to set paramter only once: via this protocol or setObject:forKey:action: method
- (NSDictionary *)additionalRequestParametersForAction:(DVSActionType)action;

@end