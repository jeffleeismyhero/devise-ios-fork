//
//  SSKUser.m
//  SaasKit
//
//  Created by Patryk Kaczmarek on 19.11.2014.
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import "SSKUser.h"
#import "SSKAPIManager.h"
#import "SSKUser+Validation.h"


@interface SSKUser ()

@property (strong, nonatomic) NSDictionary *extraLoginParameters;

@end

@implementation SSKUser

#pragma mark - Public Methods

- (instancetype)init {
    self = [super init];
    if (self) {
        self.loginMethod = SSKLoginUsingEmail;
    }
    return self;
}

+ (instancetype)user {
    return [[[self class] alloc] init];
}

- (void)signUpWithSuccess:(SSKVoidBlock)success failure:(SSKErrorBlock)failure {
    [SSKAPIManager registerUser:self withSuccess: success failure: failure];
}

- (void)loginWithSuccess:(SSKVoidBlock)success failure:(SSKErrorBlock)failure {
    
    NSError *error;
    if (![self loginValidationWithError:&error]) {
        failure(error);
        return;
    }
    
    [SSKAPIManager loginUser:self withSuccess:success failure:failure];
}

- (void)loginWithExtraParams:(SSKExtraParamsBlock)params success:(SSKVoidBlock)success failure:(SSKErrorBlock)failure {
    
    self.extraLoginParameters = params();
    [self loginWithSuccess:success failure:failure];
}

- (void)remindPasswordWithSuccess:(SSKVoidBlock)success failure:(SSKErrorBlock)failure {
    
    NSError *error;
    if (![self remindPasswordValidationWithError:&error]) {
        failure(error);
        return;
    }
    [SSKAPIManager remindPasswordForUser:self withSuccess:success failure:failure];
}

+ (void)remindPasswordWithEmail:(NSString *)email success:(SSKVoidBlock)success failure:(SSKErrorBlock)failure {
    
    SSKUser *user = [SSKUser user];
    user.email = email;
    [user remindPasswordWithSuccess:success failure:failure];
}

- (NSDictionary *)extraLoginParams {
    return self.extraLoginParameters;
}

#pragma mark - Private Methods

@end
