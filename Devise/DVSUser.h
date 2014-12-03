//
//  DVSUser.h
//
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DVSTypedefs.h"
#import "DVSValidator.h"

typedef NS_ENUM(NSInteger, DVSRequestType) {
    DVSRequestGET,
    DVSRequestPOST
};

@protocol DVSUserDataSource;

@interface DVSUser : NSObject

/// User's email.
@property (strong, nonatomic) NSString *email;

/// User's password.
@property (strong, nonatomic) NSString *password;

/// User's data source.
@property (weak, nonatomic) id <DVSUserDataSource> dataSource;

+ (DVSUser *)user;
+ (DVSUser *)currentUser;

/* Configures user with data from server and sets the user as the current user */
- (void)setupWithDictionary:(NSDictionary *)dictionary;

- (NSDictionary *)extraLoginParams;
- (NSDictionary *)extraRegistrationParams;
- (NSDictionary *)extraRemindPasswordParams;

- (void)loginWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;
- (void)loginWithExtraParams:(DVSExtraParamsBlock)params success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;

- (void)remindPasswordWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;
- (void)remindPasswordWithExtraParams:(DVSExtraParamsBlock)params success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;
+ (void)remindPasswordWithEmail:(NSString *)email success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;

- (void)registerWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;
- (void)registerWithExtraParams:(DVSExtraParamsBlock)params success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;

@end

@protocol DVSUserDataSource <NSObject>

@optional

/// Request type for login route (default: POST).
- (DVSRequestType)requestTypeForUserLogin:(DVSUser *)user;

/// Email parameter in login route (default: "email").
- (NSString *)nameForEmailInUserLogin:(DVSUser *)user;

/// Password parameter in login route (default: "password").
- (NSString *)nameForPasswordInUserLogin:(DVSUser *)user;

/// Request type for forgot password route (default: POST).
- (DVSRequestType)requestTypeForUserRemindPassword:(DVSUser *)user;

/// Email parameter in forgot password route (default: "email").
- (NSString *)nameForEmailInUserRemindPassword:(DVSUser *)user;

/// Password parameter in forgot password route (default: "password").
- (NSString *)nameForPasswordInRemindPassword:(DVSUser *)user;

/// Request type for register route (default: POST).
- (DVSRequestType)requestTypeForUserRegistration:(DVSUser *)user;

/// Email  parameter in register route (default: "email").
- (NSString *)nameForEmailInUserRegistration:(DVSUser *)user;

/// Password  parameter in register route (default: "password").
- (NSString *)nameForPasswordInRegistration:(DVSUser *)user;

/* Allows customization in validation during login process. Following rules are always used:
 * - validate(@"password").required(),
 * - validate(@"email").required().emailSyntax()
 */
- (NSArray *)additionalValidationRulesForLogin:(DVSUser *)user;

/* Allows customization in validation during remind password process. Following rules are always used:
 * - validate(@"email").required().emailSyntax()
 */
- (NSArray *)additionalValidationRulesForRemindPassword:(DVSUser *)user;

/* Allows customization in validation during registration process. Following rules are always used:
 * - validate(@"password").required(),
 * - validate(@"email").required().emailSyntax()
 */
- (NSArray *)additionalValidationRulesForRegistration:(DVSUser *)user;

@end