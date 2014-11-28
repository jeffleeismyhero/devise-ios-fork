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

static SSKUser * _currentUser;

#pragma mark - Public Methods

- (instancetype)init {
    self = [super init];
    if (self) {
        _loginMethod = SSKLoginMethodEmail;
    }
    return self;
}

+ (instancetype)user {
    return [[[self class] alloc] init];
}

+ (SSKUser *)currentUser {
    return _currentUser;
}

- (void) setupWithDictionary: (NSDictionary*) dictionary
{
    if (dictionary) {
        
        NSString * usernameValue = dictionary[@"username"];
        if (usernameValue) {
            self.username = usernameValue;
        }
        
        NSString * emailValue = dictionary[@"email"];
        if (emailValue) {
            self.email = emailValue;
        }
        
        NSString * firstNameValue = dictionary[@"firstName"];
        if (firstNameValue) {
            self.firstName = firstNameValue;
        }
        
        NSString * lastNameValue = dictionary[@"lastName"];
        if (lastNameValue) {
            self.lastName = lastNameValue;
        }
        
        NSString * phoneNumberValue = dictionary[@"phoneNumber"];
        if (phoneNumberValue) {
            self.phoneNumber = phoneNumberValue;
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
    BOOL validated = NO;
    
    if (self.loginMethod == SSKLoginMethodUsername) {
        validated = [SSKValidator validateModel:self error:&error usingRules:^NSArray *{
            return @[
                validate(@"username").required().lengthRange(2, 50),
                validate(@"password").required()
            ];
        }];
    } else if (self.loginMethod == SSKLoginMethodEmail) {
        validated = [SSKValidator validateModel:self error:&error usingRules:^NSArray *{
            return @[
                validate(@"email").required().emailSyntax().lengthRange(2, 100),
                validate(@"password").required()
            ];
        }];
    }
    
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
        return @[validate(@"email").required().emailSyntax()];
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
        return @[validate(@"password").required(),
                 validate(@"firstName").required().lengthRange(2, 50),
                 validate(@"lastName").required().lengthRange(2, 50),
                 validate(@"username").required().lengthRange(2, 50),
                 validate(@"email").required().lengthRange(2, 100).emailSyntax()];
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
