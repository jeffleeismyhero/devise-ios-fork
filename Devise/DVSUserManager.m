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
#import "DVSOAuthJSONParameters.h"
#import "DVSGooglePlusAuthenticator.h"
#import "DVSFacebookSignInHelper.h"

@interface DVSUserManager ()

@property (strong, nonatomic, readwrite) DVSUser *user;
@property (strong, nonatomic) DVSFacebookSignInHelper *facebookSignInHelper;

@end

@implementation DVSUserManager

#pragma mark - Object lifecycle

- (instancetype)initWithUser:(DVSUser *)user {
    return (self = [self initWithUser:user configuration:[DVSConfiguration sharedConfiguration]]);
}

- (instancetype)initWithUser:(DVSUser *)user configuration:(DVSConfiguration *)configuration {
    if (self = [super init]) {
        self.user = user;
        self.facebookSignInHelper = [[DVSFacebookSignInHelper alloc] init];
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
    NSArray *rules = @[[self validationRulesForPassword],
                       [self validationRulesForEmail]];
    [self validateUsingRules:rules forAction:DVSActionLogin success:^{
        [self.httpClient logInUser:self.user success:success failure:failure];
    } failure:failure];
}

#pragma mark - Remind password

- (void)remindPasswordWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    NSArray *rules = @[[self validationRulesForEmail]];
    
    [self validateUsingRules:rules forAction:DVSActionRemindPassword success:^{
        [self.httpClient remindPasswordToUser:self.user success:success failure:failure];
    } failure:failure];
}

#pragma mark - Registration

- (void)registerWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    NSArray *rules = @[[self validationRulesForPassword],
                       [self validationRulesForEmail]];
    [self validateUsingRules:rules forAction:DVSActionRegistration success:^{
        [self.httpClient registerUser:self.user success:success failure:failure];
    } failure:failure];
}

#pragma mark - Signing via Facebook

- (void)signInUsingFacebookWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    [self.facebookSignInHelper signInUsingFacebookWithAppID:self.httpClient.configuration.facebookAppID completion:^(NSDictionary *parameters, NSError *error) {
        if (parameters) {
            [self.httpClient signInUsingFacebookUser:[DVSUserManager defaultManager].user parameters:parameters success:success failure:failure];
        } else if (failure != NULL) {
            failure(error);
        }
    }];
}

#pragma mark - Signing via Google+

- (void)signInUsingGoogleWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    NSString *clientID = self.httpClient.configuration.googleClientID;
    DVSGooglePlusAuthenticator *googlePlusAuthenticator = [[DVSGooglePlusAuthenticator alloc] initWithClientID:clientID];
    
    if (!self.googlePlusAuthenticator) {
        self.googlePlusAuthenticator = googlePlusAuthenticator;
        
        __weak typeof(self) weakSelf = self;
        [googlePlusAuthenticator authenticateWithSignIn:[GPPSignIn sharedInstance] success:^{
            weakSelf.googlePlusAuthenticator = nil;
            if (success != NULL) success();
        } failure:^(NSError *error) {
            weakSelf.googlePlusAuthenticator = nil;
            if (failure != NULL) failure(error);
        }];
    }
}

#pragma mark - Change password

- (void)changePasswordWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    NSArray *rules = @[[self validationRulesForPassword]];
    [self validateUsingRules:rules forAction:DVSActionChangePassword success:^{
        [self.httpClient changePasswordOfUser:self.user success:success failure:failure];
    } failure:failure];
}

#pragma mark - Update methods

- (void)updateWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    NSArray *rules = @[[self validationRulesForEmail]];
    [self validateUsingRules:rules forAction:DVSActionUpdate success:^{
        [self.httpClient updateUser:self.user success:success failure:failure];
    } failure:failure];
}

#pragma mark - Handle callback

- (BOOL)handleURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [self.googlePlusAuthenticator.signIn handleURL:url sourceApplication:sourceApplication annotation:annotation];
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
    if (validated) {
        if (success != NULL) success();
    } else if (failure != NULL) {
        failure(error);
    }
}

- (NSArray *)mergeDefaultRules:(NSArray *)defaultRules withCustomRules:(NSArray *)customRules {
    NSMutableArray *array = [NSMutableArray arrayWithArray:defaultRules];
    [array addObjectsFromArray:customRules];
    return [array copy];
}

#pragma mark - Validation Rules

- (NGRPropertyValidator *)validationRulesForPassword {
    return NGRValidate(@"password").required();
}

- (NGRPropertyValidator *)validationRulesForEmail {
    return NGRValidate(@"email").required().syntax(NGRSyntaxEmail);
}

#pragma mark - Accessors

- (DVSUserJSONSerializer *)serializer {
    return self.httpClient.userSerializer;
}

@end
