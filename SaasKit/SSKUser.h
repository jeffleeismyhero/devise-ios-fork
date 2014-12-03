//
//  SSKUser.h
//
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSKTypedefs.h"
#import "SSKValidator.h"

typedef NS_ENUM(NSInteger, SSKRequestType) {
    SSKRequestGET,
    SSKRequestPOST
};

@protocol SSKUserDataSource;

@interface SSKUser : NSObject

/// User's email.
@property (strong, nonatomic) NSString *email;

/// User's password.
@property (strong, nonatomic) NSString *password;

/// User's data source.
@property (weak, nonatomic) id <SSKUserDataSource> dataSource;

+ (SSKUser *)user;
+ (SSKUser *)currentUser;

/* Configures user with data from server and sets the user as the current user */
- (void)setupWithDictionary:(NSDictionary *)dictionary;

- (NSDictionary *)extraLoginParams;
- (NSDictionary *)extraRegistrationParams;
- (NSDictionary *)extraRemindPasswordParams;

- (void)loginWithSuccess:(SSKVoidBlock)success failure:(SSKErrorBlock)failure;
- (void)loginWithExtraParams:(SSKExtraParamsBlock)params success:(SSKVoidBlock)success failure:(SSKErrorBlock)failure;

- (void)remindPasswordWithSuccess:(SSKVoidBlock)success failure:(SSKErrorBlock)failure;
- (void)remindPasswordWithExtraParams:(SSKExtraParamsBlock)params success:(SSKVoidBlock)success failure:(SSKErrorBlock)failure;
+ (void)remindPasswordWithEmail:(NSString *)email success:(SSKVoidBlock)success failure:(SSKErrorBlock)failure;

- (void)registerWithSuccess:(SSKVoidBlock)success failure:(SSKErrorBlock)failure;
- (void)registerWithExtraParams:(SSKExtraParamsBlock)params success:(SSKVoidBlock)success failure:(SSKErrorBlock)failure;

@end

@protocol SSKUserDataSource <NSObject>

@optional

/// Request type for login route (default: POST).
- (SSKRequestType)requestTypeForUserLogin:(SSKUser *)user;

/// Email parameter in login route (default: "email").
- (NSString *)nameForEmailInUserLogin:(SSKUser *)user;

/// Password parameter in login route (default: "password").
- (NSString *)nameForPasswordInUserLogin:(SSKUser *)user;

/// Request type for forgot password route (default: POST).
- (SSKRequestType)requestTypeForUserRemindPassword:(SSKUser *)user;

/// Email parameter in forgot password route (default: "email").
- (NSString *)nameForEmailInUserRemindPassword:(SSKUser *)user;

/// Password parameter in forgot password route (default: "password").
- (NSString *)nameForPasswordInRemindPassword:(SSKUser *)user;

/// Request type for register route (default: POST).
- (SSKRequestType)requestTypeForUserRegistration:(SSKUser *)user;

/// Email  parameter in register route (default: "email").
- (NSString *)nameForEmailInUserRegistration:(SSKUser *)user;

/// Password  parameter in register route (default: "password").
- (NSString *)nameForPasswordInRegistration:(SSKUser *)user;

/* Allows customization in validation during login process. Following rules are always used:
 * - validate(@"password").required(),
 * - validate(@"email").required().emailSyntax()
 */
- (NSArray *)additionalValidationRulesForLogin:(SSKUser *)user;

/* Allows customization in validation during remind password process. Following rules are always used:
 * - validate(@"email").required().emailSyntax()
 */
- (NSArray *)additionalValidationRulesForRemindPassword:(SSKUser *)user;

/* Allows customization in validation during registration process. Following rules are always used:
 * - validate(@"password").required(),
 * - validate(@"email").required().emailSyntax()
 */
- (NSArray *)additionalValidationRulesForRegistration:(SSKUser *)user;

@end