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

@interface DVSUserManager ()

@property (strong, nonatomic, readwrite) DVSUser *user;

@end

@implementation DVSUserManager

#pragma mark - Object lifecycle

- (instancetype)initWithUser:(DVSUser *)user {
    if (self = [super init]) {
        self.user = user;
        self.httpClient = [[DVSHTTPClient alloc] initWithConfiguration:[DVSConfiguration sharedConfiguration]];
    }
    return self;
}

#pragma mark - Logging in

- (void)loginWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    NSArray *rules = @[
                       NGRValidate(@"password").required(),
                       NGRValidate(@"email").required().syntax(NGRSyntaxEmail)
                       ];
    
    DVSWorkInProgress("Additional params will be added in delegate methods");
    
    [self validateUsingRules:rules forAction:DVSActionLogin success:^{
        [self.httpClient logInUser:self.user success:success failure:failure];
    } failure:failure];
}

#pragma mark - Remind password

- (void)remindPasswordWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    NSArray *rules = @[NGRValidate(@"email").required().syntax(NGRSyntaxEmail)];
    
    DVSWorkInProgress("Additional params will be added in delegate methods");
    
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
    
    DVSWorkInProgress("Additional params will be added in delegate methods");
    
    [self validateUsingRules:rules forAction:DVSActionRegistration success:^{
        [self.httpClient registerUser:self.user success:success failure:failure];
    } failure:failure];
}

#pragma mark - Change password

- (void)changePasswordWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    NSArray *rules = @[NGRValidate(@"password").required()];
    
    DVSWorkInProgress("Additional params will be added in delegate methods");
    
    [self validateUsingRules:rules forAction:DVSActionChangePassword success:^{
        [self.httpClient changePasswordOfUser:self.user success:success failure:failure];
    } failure:failure];
}

#pragma mark - Update methods

- (void)updateWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    NSArray *rules = @[NGRValidate(@"email").required().syntax(NGRSyntaxEmail)];
    
    DVSWorkInProgress("Additional params will be added in delegate methods");
    
    [self validateUsingRules:rules forAction:DVSActionUpdate success:^{
        [self.httpClient updateUser:self.user success:success failure:failure];
    } failure:failure];
}

#pragma mark - Delete account

- (void)deleteAccountWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    [self.httpClient deleteUser:self success:^{
        [[self class] removeLocalUser];
        if (success != NULL) success();
    } failure:failure];
}

#pragma mark - Validation

- (void)validateUsingRules:(NSArray *)rules forAction:(DVSActionType)action success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    NSError *error;
    BOOL validated = [NGRValidator validateModel:self error:&error usingRules:^NSArray *{
        return rules;
    }];
    validated ? success() : failure(error);
}

- (NSArray *)mergeDefaultRules:(NSArray *)defaultRules withCustomRules:(NSArray *)customRules {
    NSMutableArray *array = [NSMutableArray arrayWithArray:defaultRules];
    [array addObjectsFromArray:customRules];
    return [array copy];
}

@end
