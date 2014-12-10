//
//  DVSUser.m
//  
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSUser.h"
#import "DVSAPIManager.h"
#import "DVSUser+Memorize.h"

@interface DVSUser ()

@property (strong, nonatomic) NSMutableArray *additionalRequestParameters;

@end

static DVSUser *dvs_currentUser;

@implementation DVSUser

#pragma mark - Public Methods

- (instancetype)init {
    self = [super init];
    if (self) {
        self.additionalRequestParameters = [NSMutableArray array];
        for (int i = 0; i <= DVSActionUpdate; i++) {
            self.additionalRequestParameters[i] = [NSMutableDictionary dictionary];
        }
    }
    return self;
}

+ (instancetype)user {
    return [[[self class] alloc] init];
}

+ (DVSUser *)currentUser {
    
    DVSUser *user = [self user];
    NSString *email = [user dvs_email];
    NSString *token = [user dvs_token];

    if (email && token) {
        if (!dvs_currentUser) dvs_currentUser = user;
        dvs_currentUser.email = email;
        dvs_currentUser.sessionToken = token;
    }
    return dvs_currentUser;
}

- (void)logout {
    dvs_currentUser = nil;
    [self dvs_deleteSensitiveData];
}

#pragma mark - Login Methods:

- (void)loginWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    
    NSArray *rules = @[validate(@"password").required(),
                       validate(@"email").required().emailSyntax()];
    
    [self validateUsingRules:rules forAction:DVSActionLogin success:^{
        [DVSAPIManager loginUser:self withSuccess:success failure:failure];
    } failure:failure];
}

- (void)loginWithExtraParams:(DVSExtraParamsBlock)params success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    
    [self setObjects:params() forAction:DVSActionLogin];
    [self loginWithSuccess:success failure:failure];
}

#pragma mark - Remind Password Methods:

- (void)remindPasswordWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {

    NSArray *rules = @[validate(@"email").required().emailSyntax()];
    
    [self validateUsingRules:rules forAction:DVSActionRemindPassword success:^{
        [DVSAPIManager remindPasswordForUser:self withSuccess:success failure:failure];
    } failure:failure];
}

- (void)remindPasswordWithExtraParams:(DVSExtraParamsBlock)params success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {

    [self setObjects:params() forAction:DVSActionRemindPassword];
    [self remindPasswordWithSuccess:success failure:failure];
}

+ (void)remindPasswordWithEmail:(NSString *)email success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {

    DVSUser *user = [DVSUser user];
    user.email = email;
    [user remindPasswordWithSuccess:success failure:failure];
}

#pragma mark - Register Methods:

- (void)registerWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    
    NSArray *rules = @[validate(@"password").required(),
                       validate(@"email").required().emailSyntax()];
    
    [self validateUsingRules:rules forAction:DVSActionRegistration success:^{
        [DVSAPIManager registerUser:self withSuccess:success failure:failure];
    } failure:failure];
}

- (void)registerWithExtraParams:(DVSExtraParamsBlock)params success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {

    [self setObjects:params() forAction:DVSActionRegistration];
    [self registerWithSuccess:success failure:failure];
}

#pragma mark - Change Password Methods:

- (void)changePasswordWithNewPassword:(NSString *)newPassword success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    
    NSArray *rules = @[validate(@"password").required().match(newPassword)];
    
    [self validateUsingRules:rules forAction:DVSActionChangePassword success:^{
        [DVSAPIManager changePasswordForUser:self withSuccess:success failure:failure];
    } failure:failure];
}

- (void)changePasswordWithNewPassword:(NSString *)newPassword extraParams:(DVSExtraParamsBlock)params success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    [self setObjects:params() forAction:DVSActionChangePassword];
    [self changePasswordWithNewPassword:newPassword success:success failure:failure];
}

#pragma mark - Update Methods

- (void)updateWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    
    NSArray *rules = @[validate(@"email").required().emailSyntax()];
    
    [self validateUsingRules:rules forAction:DVSActionUpdate success:^{
        [DVSAPIManager updateUser:self withSuccess:success failure:failure];
    } failure:failure];
}

- (void)updateWithExtraParams:(DVSExtraParamsBlock)params success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    [self setObjects:params() forAction:DVSActionUpdate];
    [self updateWithSuccess:success failure:failure];
}

#pragma mark - Delete Account Methods:

- (void)deleteAccountWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    
    [DVSAPIManager deleteUser:self withSuccess:^{
        [self logout];
        success();
    } failure:failure];
}

#pragma mark - Private Methods

- (void)validateUsingRules:(NSArray *)rules forAction:(DVSActionType)action success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    
    NSError *error;
    BOOL validated = [DVSValidator validateModel:self error:&error usingRules:^NSArray *{
        
        NSMutableArray *array = [rules mutableCopy];
        
        if (_dataSource && [_dataSource respondsToSelector:@selector(additionalValidationRulesForAction:)]) {
            [array addObjectsFromArray:[_dataSource additionalValidationRulesForAction:action]];
        }
        return [array copy];
    }];
    validated ? success() : failure(error);
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
    self.additionalRequestParameters[actionType] = objects;
}

@end