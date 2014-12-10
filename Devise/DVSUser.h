//
//  DVSUser.h
//
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DVSTypedefs.h"
#import "DVSValidator.h"

typedef NS_ENUM(NSInteger, DVSActionType) {
    DVSLoginAction,
    DVSRegistrationAction,
    DVSRemindPasswordAction,
    DVSChangePasswordAction
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

- (NSDictionary *)extraLoginParams;
- (NSDictionary *)extraRegistrationParams;
- (NSDictionary *)extraRemindPasswordParams;
- (NSDictionary *)extraChangePasswordParams;
- (NSDictionary *)extraUpdateParams;

- (id)objectForKey:(NSString *)key action:(DVSActionType)actionType;
- (void)setObject:(id)object forKey:(NSString *)key action:(DVSActionType)actionType;

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

/* Allows customization in validation during login process. Following rules are always used:
 * - validate(@"password").required(),
 * - validate(@"email").required().emailSyntax()
 */
- (NSArray *)additionalValidationRulesForLogin:(DVSUser *)user;

/* Allows customization in validation during remind password process. Following rules are always used:
 * - validate(@"email").required().emailSyntax()
 */
- (NSArray *)additionalValidationRulesForRemindPassword:(DVSUser *)user;

/* Allows customization in validation during remind password process. Following rules are always used:
 * - validate(@"password").required().match(newPassword)
 */
- (NSArray *)additionalValidationRulesForChangePassword:(DVSUser *)user;

/* Allows customization in validation during registration process. Following rules are always used:
 * - validate(@"password").required(),
 * - validate(@"email").required().emailSyntax()
 */
- (NSArray *)additionalValidationRulesForRegistration:(DVSUser *)user;

/* Allows customization in validation during update process. Following rules are always used:
 * - validate(@"email").required().emailSyntax()
 */
- (NSArray *)additionalValidationRulesForUpdate:(DVSUser *)user;

@end