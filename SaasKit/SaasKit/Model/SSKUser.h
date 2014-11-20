//
//  SSKUser.h
//  SaasKit
//
//  Created by Patryk Kaczmarek on 19.11.2014.
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import "SSKObject.h"

typedef NS_ENUM(NSInteger, SSKLoginMethod) {
    SSKLoginUsingEmail,
    SSKLoginUsingUsername
};

@interface SSKUser : SSKObject

@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *password;

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *phone;

@property (assign, nonatomic) SSKLoginMethod loginMethod; //default SSKLoginUsingEmail

/*!
 Designed initializer for SSKUser class. Sets whole bunch of defaulft behaviours. Use it instead of [[alloc] init] method
 */
+ (SSKUser *)user;

/*!
 Additional parameters provided to improve configurability
 */
- (NSDictionary *)extraLoginParams;
- (NSDictionary *)extraRegistrationParams;
- (NSDictionary *)extraRemindPasswordParams;

#pragma mark - Login methods:

- (void)loginWithSuccess:(SSKVoidBlock)success failure:(SSKErrorBlock)failure;
- (void)loginWithExtraParams:(SSKExtraParamsBlock)params success:(SSKVoidBlock)success failure:(SSKErrorBlock)failure;

#pragma mark - Remind password methods:

- (void)remindPasswordWithSuccess:(SSKVoidBlock)success failure:(SSKErrorBlock)failure;
- (void)remindPasswordWithExtraParams:(SSKExtraParamsBlock)params success:(SSKVoidBlock)success failure:(SSKErrorBlock)failure;
+ (void)remindPasswordWithEmail:(NSString *)email success:(SSKVoidBlock)success failure:(SSKErrorBlock)failure;

#pragma mark - Register methods:

- (void)registerWithSuccess:(SSKVoidBlock)success failure:(SSKErrorBlock)failure;
- (void)registerWithExtraParams:(SSKExtraParamsBlock)params success:(SSKVoidBlock)success failure:(SSKErrorBlock)failure;

@end
