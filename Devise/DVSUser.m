//
//  DVSUser.m
//  
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSUser.h"
#import "DVSAPIManager.h"
#import "DVSUser+Memorize.h"

@interface DVSUser ()

@property (strong, nonatomic) NSDictionary *localExtraLoginParams;
@property (strong, nonatomic) NSDictionary *localExtraRegistrationParams;
@property (strong, nonatomic) NSDictionary *localExtraRemindPasswordParams;

@end

@implementation DVSUser

static DVSUser *_currentUser;

#pragma mark - Public Methods

+ (instancetype)user {
    return [[[self class] alloc] init];
}

+ (DVSUser *)currentUser {
    return _currentUser;
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

    self.localExtraLoginParams = params();
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

    self.localExtraRemindPasswordParams = params;
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

    self.localExtraRegistrationParams = params();
    [self registerWithSuccess:success failure:failure];
}

@end
