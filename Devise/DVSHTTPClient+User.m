//
//  DVSHTTPClient+User.m
//  
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSHTTPClient+User.h"
#import <objc/runtime.h>
#import "DVSUser.h"
#import "DVSUser+Persistence.h"
#import "DVSUserJSONSerializer+Serialize.h"
#import "NSDictionary+Devise+Private.h"
#import "NSObject+Devise+Private.h"
#import "DVSUserPersistenceManager.h"
#import "DVSUserManager.h"
#import "DVSConfiguration.h"

NSString * const DVSHTTPClientDefaultRegisterPath = @"";
NSString * const DVSHTTPClientDefaultLogInPath = @"sign_in";
NSString * const DVSHTTPClientDefaultUpdatePath = @"";
NSString * const DVSHTTPClientDefaultDeletePath = @"";
NSString * const DVSHTTPClientDefaultChangePasswordPath = @"password";
NSString * const DVSHTTPClientDefaultRemindPasswordPath = @"password";
NSString * const DVSHTTPClientDefaultFacebookSigningPath = @"auth/facebook";
NSString * const DVSHTTPClientDefaultGoogleSigningPath = @"auth/google";

@interface DVSUser ()

@property (strong, nonatomic, readwrite) NSString *identifier;
@property (strong, nonatomic, readwrite) NSString *sessionToken;

@end

#pragma mark -

@implementation DVSHTTPClient (User)

#pragma mark - Standard methods

- (void)registerUser:(DVSUser *)user success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    NSString *path = DVSHTTPClientDefaultRegisterPath;
    
    NSDictionary *parameters = nil;
#if ENABLE_USER_JSON_SERIALIZER
    parameters = [self.userSerializer registerJSONDictionaryForUser:user];
#else
    parameters = [user registerJSON];
#endif
    
    [self POST:path parameters:parameters completion:^(id responseObject, NSError *error) {
        if (error != nil) {
            if (failure != NULL) failure(error);
        } else {
            [self fillUser:user withJSONRepresentation:responseObject[@"user"]];
            
#if ENABLE_PERSISTENCE_MANAGER
            [DVSUserPersistenceManager sharedPersistenceManager].localUser = user;
#else
            [[user class] setLocalUser:user];
#endif
            
            if (success != NULL) success();
        }
    }];
}

- (void)signInUsingFacebookUser:(DVSUser *)user parameters:(NSDictionary *)parameters success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    NSString *path = DVSHTTPClientDefaultFacebookSigningPath;
    
    [self POST:path parameters:parameters completion:^(id responseObject, NSError *error) {
        if (error != nil) {
            if (failure != NULL) failure(error);
        } else {
            [self fillUser:user withJSONRepresentation:responseObject[@"user"]];
            
#if ENABLE_PERSISTENCE_MANAGER
            [DVSUserPersistenceManager sharedPersistenceManager].localUser = user;
#else
            [[user class] setLocalUser:user];
#endif
            
            if (success != NULL) success();
        }
    }];
}

- (void)signInUsingGoogleUser:(DVSUser *)user parameters:(NSDictionary *)parameters success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    NSString *path = DVSHTTPClientDefaultGoogleSigningPath;
    
    [self POST:path parameters:parameters completion:^(id responseObject, NSError *error) {
        if (error != nil) {
            if (failure != NULL) failure(error);
        } else {
            [self fillUser:user withJSONRepresentation:responseObject[@"user"]];
            
#if ENABLE_PERSISTENCE_MANAGER
            [DVSUserPersistenceManager sharedPersistenceManager].localUser = user;
#else
            [[user class] setLocalUser:user];
#endif
            
            if (success != NULL) success();
        }
    }];
}

- (void)logInUser:(DVSUser *)user success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    NSString *path = DVSHTTPClientDefaultLogInPath;
    
    NSDictionary *parameters = nil;
 
#if ENABLE_USER_JSON_SERIALIZER
    parameters = [self.userSerializer loginJSONDictionaryForUser:user];
#else
    parameters = [user loginJSON];
#endif
    
    [self POST:path parameters:parameters completion:^(id responseObject, NSError *error) {
        if (error != nil) {
            if (failure != NULL) failure(error);
        } else {
            if (self.configuration.rootJSONInResponse) {
                [self fillUser:user withJSONRepresentation:responseObject[@"user"]];
            } else {
                [self fillUser:user withJSONRepresentation:responseObject];
            }
            
#if ENABLE_PERSISTENCE_MANAGER
            [DVSUserPersistenceManager sharedPersistenceManager].localUser = user;
#else
            [[user class] setLocalUser:user];
#endif
            if (success != NULL) success();
        }
    }];
}

- (void)updateUser:(DVSUser *)user success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    [self setAuthorizationToken:user.sessionToken email:[DVSUserManager defaultManager].userPreviousEmail];
    NSString *path = DVSHTTPClientDefaultUpdatePath;
    
    NSDictionary *parameters = nil;
#if ENABLE_USER_JSON_SERIALIZER
    parameters = [self.userSerializer updateJSONDictionaryForUser:user];
#else
    parameters = [user updateJSON];
#endif
    
    [self PUT:path parameters:parameters completion:^(__unused id responseObject, NSError *error) {
        if (error != nil) {
            if (failure != NULL) failure(error);
        } else {
            if (success != NULL) success();
        }
    }];
}

- (void)deleteUser:(DVSUser *)user success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    [self setAuthorizationToken:user.sessionToken email:[DVSUserPersistenceManager sharedPersistenceManager].localUser.email];
    NSString *path = DVSHTTPClientDefaultDeletePath;
    [self DELETE:path parameters:nil completion:^(__unused id responseObject, NSError *error) {
        if (error != nil) {
            if (failure != NULL) failure(error);
        } else {
#if ENABLE_PERSISTENCE_MANAGER
            [DVSUserPersistenceManager sharedPersistenceManager].localUser = nil;
#endif
            if (success != NULL) success();
        }
    }];
}

- (void)changePasswordOfUser:(DVSUser *)user success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    [self setAuthorizationToken:user.sessionToken email:[DVSUserPersistenceManager sharedPersistenceManager].localUser.email];
    NSString *path = DVSHTTPClientDefaultChangePasswordPath;
    
    NSDictionary *parameters = nil;
#if ENABLE_USER_JSON_SERIALIZER
    parameters = [self.userSerializer changePasswordJSONDictionaryForUser:user];
#else
    parameters = [user changePasswordJSON];
#endif
    
    [self PUT:path parameters:parameters completion:^(__unused id responseObject, NSError *error) {
        if (error != nil) {
            if (failure != NULL) failure(error);
        } else {
            if (success != NULL) success();
        }
    }];
}

- (void)remindPasswordToUser:(DVSUser *)user success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    NSString *path = DVSHTTPClientDefaultRemindPasswordPath;
    
    NSDictionary *parameters = nil;
#if ENABLE_USER_JSON_SERIALIZER
    parameters = [self.userSerializer remindPasswordJSONDictionaryForUser:user];
#else
    parameters = [user remindPasswordJSON];
#endif
    
    [self POST:path parameters:parameters completion:^(__unused id responseObject, NSError *error) {
        if (error != nil) {
            if (failure != NULL) failure(error);
        } else {
            if (success != NULL) success();
        }
    }];
}

#pragma mark - Authorization

- (void)setAuthorizationToken:(NSString *)token email:(NSString *)email {
    [self setValue:token forHTTPHeaderField:@"X-User-Token"];
    [self setValue:email forHTTPHeaderField:@"X-User-Email"];
}

#pragma mark - Accessors

- (DVSUserJSONSerializer *)userSerializer {
    DVSUserJSONSerializer *serializer = (DVSUserJSONSerializer *)objc_getAssociatedObject(self, @selector(userSerializer));
    if (!serializer) {
        serializer = [DVSUserJSONSerializer new];
        objc_setAssociatedObject(self, @selector(userSerializer), serializer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return serializer;
}

#pragma mark - Helper methods

- (void)fillUser:(DVSUser *)user withJSONRepresentation:(NSDictionary *)json {
    for (NSString *key in [user dvs_properties]) {
        if (json[key] != nil) {
            [user setValue:json[key] forKey:key];
        }
    }
    self.configuration = [DVSConfiguration sharedConfiguration];
    
    user.identifier = [json dvs_stringValueForKey:@"id"];
    user.email = [json dvs_stringValueForKey:@"email"];
    user.sessionToken = [json dvs_stringValueForKey:self.configuration.authenticationTokenName];
}

@end
