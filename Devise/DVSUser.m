//
//  DVSUser.m
//  
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSUser.h"
#import "DVSAPIManager.h"
#import "DVSUser+Memorize.h"

@interface DVSUser ()

@property (strong, nonatomic) NSMutableDictionary *localExtraLoginParams;
@property (strong, nonatomic) NSMutableDictionary *localExtraRegistrationParams;
@property (strong, nonatomic) NSMutableDictionary *localExtraRemindPasswordParams;

@end

@implementation DVSUser

#pragma mark - Public Methods

+ (instancetype)user {
    return [[[self class] alloc] init];
}

+ (DVSUser *)currentUser {
    DVSUser *user = [self user];
    NSString *email = [user dvs_email];
    NSString *token = [user dvs_token];

    if (email && token) {
        user.email = email;
        user.sessionToken = token;
        return user;
    }
    return nil;
}

- (NSDictionary *)extraLoginParams {
    return [self.localExtraLoginParams copy];
}

- (NSDictionary *)extraRegistrationParams {
    return [self.localExtraRegistrationParams copy];
}

- (NSDictionary *)extraRemindPasswordParams {
    return [self.localExtraRemindPasswordParams copy];
}

- (void)logout {
    [self dvs_deleteSensitiveData];
}

#pragma mark - Login methods:

- (void)loginWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    
    NSError *error;
    BOOL validated = [DVSValidator validateModel:self error:&error usingRules:^NSArray *{
        
        NSMutableArray *rules = [@[validate(@"password").required(),
                                   validate(@"email").required().emailSyntax()] mutableCopy];
        
        if (_dataSource && [_dataSource respondsToSelector:@selector(additionalValidationRulesForLogin:)]) {
            [rules addObjectsFromArray:[_dataSource additionalValidationRulesForLogin:self]];
        }
        return [rules copy];
    }];
    
    if (!validated) {
        failure(error);
        return;
    }
    
    [DVSAPIManager loginUser:self withSuccess:success failure:failure];
}

- (void)loginWithExtraParams:(DVSExtraParamsBlock)params success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    
    self.localExtraLoginParams = [NSMutableDictionary dictionaryWithDictionary:params()];
    [self loginWithSuccess:success failure:failure];
}

#pragma mark - Remind password methods:

- (void)remindPasswordWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {

    NSError *error;
    BOOL validated = [DVSValidator validateModel:self error:&error usingRules:^NSArray *{
        
        NSMutableArray *rules = [@[validate(@"email").required().emailSyntax()] mutableCopy];
        
        if (_dataSource && [_dataSource respondsToSelector:@selector(additionalValidationRulesForRemindPassword:)]) {
            [rules addObjectsFromArray:[_dataSource additionalValidationRulesForRemindPassword:self]];
        }
        return [rules copy];
    }];
    
    if (!validated) {
        failure(error);
        return;
    }
    
    [DVSAPIManager remindPasswordForUser:self withSuccess:success failure:failure];
}

- (void)remindPasswordWithExtraParams:(DVSExtraParamsBlock)params success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {

    self.localExtraRemindPasswordParams = [NSMutableDictionary dictionaryWithDictionary:params];
    [self remindPasswordWithSuccess:success failure:failure];
}

+ (void)remindPasswordWithEmail:(NSString *)email success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {

    DVSUser *user = [DVSUser user];
    user.email = email;
    [user remindPasswordWithSuccess:success failure:failure];
}

#pragma mark - Register methods:

- (void)registerWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {

    NSError *error;
    BOOL validated = [DVSValidator validateModel:self error:&error usingRules:^NSArray *{
        
        NSMutableArray *rules = [@[validate(@"password").required(),
                                   validate(@"email").required().emailSyntax()] mutableCopy];
        
        if (_dataSource && [_dataSource respondsToSelector:@selector(additionalValidationRulesForRegistration:)]) {
            [rules addObjectsFromArray:[_dataSource additionalValidationRulesForRegistration:self]];
        }
        return [rules copy];
    }];
    
    if (!validated) {
        failure(error);
        return;
    }
    [DVSAPIManager registerUser:self withSuccess:success failure:failure];
}

- (void)registerWithExtraParams:(DVSExtraParamsBlock)params success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {

    self.localExtraRegistrationParams = [NSMutableDictionary dictionaryWithDictionary:params()];
    [self registerWithSuccess:success failure:failure];
}

- (void)deleteAccount {
    [self deleteAccountWithSuccess:^{} failure:^(NSError *error){}];
}

- (void)deleteAccountWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    
    [DVSAPIManager deleteUser:self withSuccess:^{
        [self logout];
        success();
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark - Accessors

- (id)objectForKey:(NSString *)key action:(DVSActionType)actionType {
    switch (actionType) {
        case DVSLoginAction:
            return self.localExtraLoginParams[key];
            
        case DVSRegistrationAction:
            return self.localExtraRegistrationParams[key];
            
        case DVSRemindPasswordAction:
            return self.localExtraRemindPasswordParams[key];
    }
}

- (void)setObject:(id)object forKey:(NSString *)key action:(DVSActionType)actionType {
    switch (actionType) {
        case DVSLoginAction:
            self.localExtraLoginParams[key] = object;
            break;
            
        case DVSRegistrationAction:
            self.localExtraRegistrationParams[key] = object;
            break;
            
        case DVSRemindPasswordAction:
            self.localExtraRemindPasswordParams[key] = object;
            break;
    }
}

- (NSMutableDictionary *)localExtraLoginParams {
    if (!_localExtraLoginParams) {
        _localExtraLoginParams = [NSMutableDictionary dictionary];
    }
    return _localExtraLoginParams;
}

- (NSMutableDictionary *)localExtraRegistrationParams {
    if (!_localExtraRegistrationParams) {
        _localExtraRegistrationParams = [NSMutableDictionary dictionary];
    }
    return _localExtraRegistrationParams;
}

- (NSMutableDictionary *)localExtraRemindPasswordParams {
    if (!_localExtraRemindPasswordParams) {
        _localExtraRemindPasswordParams = [NSMutableDictionary dictionary];
    }
    return _localExtraRemindPasswordParams;
}

@end
