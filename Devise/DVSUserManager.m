//
//  DVSUserManager.m
//  Devise
//
//  Created by Wojciech Trzasko on 11.02.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSUserManager.h"

#import <ngrvalidator/NGRValidator.h>

#import "DVSConfiguration.h"
#import "DVSHTTPClient+User.h"
#import "DVSUserPersistenceManager.h"

@interface DVSUserManager ()

@property (strong, nonatomic, readwrite) DVSUser *user;

@end

@implementation DVSUserManager

#pragma mark - Object lifecycle

- (instancetype)initWithUser:(DVSUser *)user {
    return (self = [self initWithUser:user configuration:[DVSConfiguration sharedConfiguration]]);
}

- (instancetype)initWithUser:(DVSUser *)user configuration:(DVSConfiguration *)configuration {
    if (self = [super init]) {
        self.user = user;
        
        self.httpClient = [[DVSHTTPClient alloc] initWithConfiguration:configuration];
    }
    return self;
}

+ (instancetype)defaultManager {
    static DVSUserManager *sharedMyManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[DVSUserManager alloc] initWithUser:[DVSUserPersistenceManager sharedPersistenceManager].localUser configuration:[DVSConfiguration sharedConfiguration]];
    });
    return sharedMyManager;
}

#pragma mark - Logging in

- (void)loginWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    NSArray *rules = @[
                       NGRValidate(@"password").required(),
                       NGRValidate(@"email").required().syntax(NGRSyntaxEmail)
                       ];
    [self validateUsingRules:rules forAction:DVSActionLogin success:^{
        [self.httpClient logInUser:self.user success:success failure:failure];
    } failure:failure];
}

#pragma mark - Remind password

- (void)remindPasswordWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    NSArray *rules = @[NGRValidate(@"email").required().syntax(NGRSyntaxEmail)];
    
    [self validateUsingRules:rules forAction:DVSActionRemindPassword success:^{
        [self.httpClient remindPasswordToUser:self.user success:success failure:failure];
    } failure:failure];
}

#pragma mark - Registration

- (void)registerWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    NSArray *rules = @[
                       NGRValidate(@"password").required(),
                       NGRValidate(@"email").required().syntax(NGRSyntaxEmail)
                       ];
    [self validateUsingRules:rules forAction:DVSActionRegistration success:^{
        [self.httpClient registerUser:self.user success:success failure:failure];
    } failure:failure];
}

#pragma mark - Change password

- (void)changePasswordWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    NSArray *rules = @[NGRValidate(@"password").required()];
    [self validateUsingRules:rules forAction:DVSActionChangePassword success:^{
        [self.httpClient changePasswordOfUser:self.user success:success failure:failure];
    } failure:failure];
}

#pragma mark - Update methods

- (void)updateWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    NSArray *rules = @[NGRValidate(@"email").required().syntax(NGRSyntaxEmail)];
    [self validateUsingRules:rules forAction:DVSActionUpdate success:^{
        [self.httpClient updateUser:self.user success:success failure:failure];
    } failure:failure];
}

#pragma mark - Delete account

- (void)deleteAccountWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    [self.httpClient deleteUser:self.user success:^{
        [DVSUserPersistenceManager sharedPersistenceManager].localUser = nil;
        if (success != NULL) success();
    } failure:failure];
}

#pragma mark - Logout method
- (void)logout {
    [DVSUserPersistenceManager sharedPersistenceManager].localUser = nil;
}

#pragma mark - Validation

- (void)validateUsingRules:(NSArray *)rules forAction:(DVSActionType)action success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    NSError *error;

    BOOL validated = [NGRValidator validateModel:self.user error:&error usingRules:^NSArray *{
        
        NSMutableArray *currentValidationRules = [NSMutableArray arrayWithArray:rules];
        
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(additionalValidationRulesForAction:defaultRules:)]) {
            currentValidationRules = [NSMutableArray arrayWithArray:[currentValidationRules arrayByAddingObjectsFromArray:[self.dataSource additionalValidationRulesForAction:action defaultRules:rules]]];
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(userManager:didPrepareValidationRules:forAction:)]) {
            [self.delegate userManager:self didPrepareValidationRules:currentValidationRules forAction:action];
        }

        return [currentValidationRules copy];
    }];
    validated ? success() : failure(error);
}

- (NSArray *)mergeDefaultRules:(NSArray *)defaultRules withCustomRules:(NSArray *)customRules {
    NSMutableArray *array = [NSMutableArray arrayWithArray:defaultRules];
    [array addObjectsFromArray:customRules];
    return [array copy];
}

#pragma mark - Accessors

- (DVSUserJSONSerializer *)serializer {
    return self.httpClient.userSerializer;
}

@end
