//
//  SSKUser.m
//  
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "SSKUser.h"
#import "SSKAPIManager.h"

@interface SSKUser ()

@property (strong, nonatomic) NSDictionary *localExtraLoginParams;
@property (strong, nonatomic) NSDictionary *localExtraRegistrationParams;
@property (strong, nonatomic) NSDictionary *localExtraRemindPasswordParams;

@end

@implementation SSKUser

static SSKUser *_currentUser;

#pragma mark - Public Methods

+ (instancetype)user {
    return [[[self class] alloc] init];
}

+ (SSKUser *)currentUser {
    return _currentUser;
}

- (void)setupWithDictionary:(NSDictionary *)dictionary {
     self.password = nil;
    
    if (dictionary) {
        if (dictionary[@"email"]) {
            self.email = dictionary[@"email"];
        }
        _currentUser = self;
    }
}

- (NSDictionary *)extraLoginParams {
    return self.localExtraLoginParams;
}

- (NSDictionary *)extraRegistrationParams {
    return self.localExtraRegistrationParams;
}

- (NSDictionary *)extraRemindPasswordParams {
    return self.localExtraRemindPasswordParams;
}

#pragma mark - Login methods:

- (void)loginWithSuccess:(SSKVoidBlock)success failure:(SSKErrorBlock)failure {
    
    NSError *error;
    BOOL validated = [SSKValidator validateModel:self error:&error usingRules:^NSArray *{
        
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
    
    [SSKAPIManager loginUser:self withSuccess:success failure:failure];
}

- (void)loginWithExtraParams:(SSKExtraParamsBlock)params success:(SSKVoidBlock)success failure:(SSKErrorBlock)failure {

    self.localExtraLoginParams = params();
    [self loginWithSuccess:success failure:failure];
}

#pragma mark - Remind password methods:

- (void)remindPasswordWithSuccess:(SSKVoidBlock)success failure:(SSKErrorBlock)failure {

    NSError *error;
    BOOL validated = [SSKValidator validateModel:self error:&error usingRules:^NSArray *{
        
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
    
    [SSKAPIManager remindPasswordForUser:self withSuccess:success failure:failure];
}

- (void)remindPasswordWithExtraParams:(SSKExtraParamsBlock)params success:(SSKVoidBlock)success failure:(SSKErrorBlock)failure {

    self.localExtraRemindPasswordParams = params;
    [self remindPasswordWithSuccess:success failure:failure];
}

+ (void)remindPasswordWithEmail:(NSString *)email success:(SSKVoidBlock)success failure:(SSKErrorBlock)failure {

    SSKUser *user = [SSKUser user];
    user.email = email;
    [user remindPasswordWithSuccess:success failure:failure];
}

#pragma mark - Register methods:

- (void)registerWithSuccess:(SSKVoidBlock)success failure:(SSKErrorBlock)failure {

    NSError *error;
    BOOL validated = [SSKValidator validateModel:self error:&error usingRules:^NSArray *{
        
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
    [SSKAPIManager registerUser:self withSuccess:success failure:failure];
}

- (void)registerWithExtraParams:(SSKExtraParamsBlock)params success:(SSKVoidBlock)success failure:(SSKErrorBlock)failure {

    self.localExtraRegistrationParams = params();
    [self registerWithSuccess:success failure:failure];
}


@end
