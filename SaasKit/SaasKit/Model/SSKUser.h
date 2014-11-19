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

@property (nonatomic, assign) SSKLoginMethod loginMethod; //default SSKLoginUsingEmail

///designed initializer
+ (instancetype)user;

#pragma mark - login methods:

- (void)signUpWithSuccess:(SSKVoidBlock)success failure:(SSKErrorBlock)failure;
- (void)loginWithSuccess:(SSKVoidBlock)success failure:(SSKErrorBlock)failure;

#pragma mark - remind password methods:

- (void)remindPasswordWithSuccess:(SSKVoidBlock)success failure:(SSKErrorBlock)failure;

+ (void)remindPasswordWithEmail:(NSString *)email success:(SSKVoidBlock)success failure:(SSKErrorBlock)failure;

#pragma mark - register methods:

@end
