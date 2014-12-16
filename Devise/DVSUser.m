//
//  DVSUser.m
//  
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSConfiguration.h"
#import "DVSHTTPClient.h"
#import "DVSHTTPClient+User.h"
#import "DVSUser.h"
#import "DVSUser+Persistence.h"
#import "DVSValidator.h"

@interface DVSUser ()

@property (strong, nonatomic) DVSHTTPClient *httpClient;

@property (strong, nonatomic) NSArray *additionalRequestParameters;
- (void)setUpDefaultAdditionalRequestParameters;

@property (strong, nonatomic, readwrite) NSString *identifier;
@property (strong, nonatomic, readwrite) NSString *sessionToken;

@end

@implementation DVSUser

#pragma mark - Object lifecycle

- (instancetype)init {
    self = [super init];
    if (self == nil) return nil;
    [self setUpDefaultAdditionalRequestParameters];
    self.httpClient = [[DVSHTTPClient alloc] initWithConfiguration:[[self class] configuration]];
    return self;
}

#pragma mark - Additional parameters management

- (void)setUpDefaultAdditionalRequestParameters {
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:5];
    for (int i = 0; i <= DVSActionUpdate; i++) {
        array[i] = [NSMutableDictionary dictionary];
    }
    self.additionalRequestParameters = [array copy];
}

- (id)objectForKey:(NSString *)key action:(DVSActionType)actionType {
    return self.additionalRequestParameters[actionType][key];
}

- (NSDictionary *)objectsForAction:(DVSActionType)actionType {
    return self.additionalRequestParameters[actionType];
}

- (void)setObject:(id)object forKey:(NSString *)key action:(DVSActionType)actionType {
    self.additionalRequestParameters[actionType][key] = object;
}

- (void)setObjects:(NSDictionary *)objects forAction:(DVSActionType)actionType {
    [self.additionalRequestParameters[actionType] addEntriesFromDictionary:objects];
}

#pragma mark - Configuration

+ (DVSConfiguration *)configuration {
    return [DVSConfiguration sharedConfiguration];
}

#pragma mark - Login Methods

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

#pragma mark - Remind Password Methods

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

#pragma mark - Register Methods

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

#pragma mark - Change Password Methods

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

#pragma mark - Update Methods

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

#pragma mark - Delete Account Methods

- (void)deleteAccountWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    [self.httpClient deleteUser:self success:^{
        [[self class] removeLocalUser];
        if (success != NULL) success();
    } failure:failure];
}

#pragma mark - Private Methods

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