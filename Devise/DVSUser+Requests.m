//
//  DVSUser+Requests.m
//  Devise
//
//  Created by Adrian Kashivskyy on 17.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSHTTPClient+User.h"
#import "DVSUser+Requests.h"

@interface DVSUser ()

@property (strong, nonatomic) DVSHTTPClient *httpClient;

@end

@implementation DVSUser (Requests)

#pragma mark - Logging in

- (void)loginWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    NSArray *rules = @[
        DVSValidate(@"password").required(),
        DVSValidate(@"email").required().emailSyntax()
    ];
    [self validateUsingRules:rules forAction:DVSActionLogin success:^{
        [self.httpClient logInUser:self success:success failure:failure];
    } failure:failure];
}

- (void)loginWithExtraParams:(DVSExtraParamsBlock)params success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    [self setObjects:params() forAction:DVSActionLogin];
    [self loginWithSuccess:success failure:failure];
}

#pragma mark - Remind password

- (void)remindPasswordWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    NSArray *rules = @[DVSValidate(@"email").required().emailSyntax()];
    [self validateUsingRules:rules forAction:DVSActionRemindPassword success:^{
        [self.httpClient remindPasswordToUser:self success:success failure:failure];
    } failure:failure];
}

- (void)remindPasswordWithExtraParams:(DVSExtraParamsBlock)params success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    [self setObjects:params() forAction:DVSActionRemindPassword];
    [self remindPasswordWithSuccess:success failure:failure];
}

#pragma mark - Registration

- (void)registerWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    NSArray *rules = @[
        DVSValidate(@"password").required(),
        DVSValidate(@"email").required().emailSyntax()
    ];
    [self validateUsingRules:rules forAction:DVSActionRegistration success:^{
        [self.httpClient registerUser:self success:success failure:failure];
    } failure:failure];
}

- (void)registerWithExtraParams:(DVSExtraParamsBlock)params success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    [self setObjects:params() forAction:DVSActionRegistration];
    [self registerWithSuccess:success failure:failure];
}

#pragma mark - Change password

- (void)changePasswordWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    NSArray *rules = @[DVSValidate(@"password").required()];
    [self validateUsingRules:rules forAction:DVSActionChangePassword success:^{
        [self.httpClient changePasswordOfUser:self success:success failure:failure];
    } failure:failure];
}

- (void)changePasswordWithExtraParams:(DVSExtraParamsBlock)params success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    [self setObjects:params() forAction:DVSActionChangePassword];
    [self changePasswordWithSuccess:success failure:failure];
}

#pragma mark - Update methods

- (void)updateWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    NSArray *rules = @[DVSValidate(@"email").required().emailSyntax()];
    [self validateUsingRules:rules forAction:DVSActionUpdate success:^{
        [self.httpClient updateUser:self success:success failure:failure];
    } failure:failure];
}

- (void)updateWithExtraParams:(DVSExtraParamsBlock)params success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    [self setObjects:params() forAction:DVSActionUpdate];
    [self updateWithSuccess:success failure:failure];
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
    BOOL validated = [DVSValidator validateModel:self error:&error usingRules:^NSArray *{

        if (self.dataSource && [self.dataSource respondsToSelector:@selector(additionalValidationRulesForAction:)]) {
            NSArray *array = [self.dataSource additionalValidationRulesForAction:action];
            return [self mergeDefaultRules:rules withCustomRules:array];
        }
        return rules;
    }];
    validated ? success() : failure(error);
}

- (NSArray *)mergeDefaultRules:(NSArray *)defaultRules withCustomRules:(NSArray *)customRules {
    DVSWorkInProgress("Temporary quick fix -- has to be improved");
    NSMutableArray *array = [defaultRules mutableCopy];
    [array addObjectsFromArray:customRules];

    for (DVSPropertyValidator *validatorA in defaultRules) {
        for (DVSPropertyValidator *validatorB in customRules) {
            if ([validatorA.propertyName isEqualToString:validatorB.propertyName]) {
                [validatorA.validators addObjectsFromArray:validatorB.validators];
                validatorA.descriptions = validatorB.descriptions;
                [array removeObject:validatorB];
                break;
            }
        }
    }
    return array;
}

@end
