//
//  DVSHTTPClient+User.m
//  
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSConfiguration.h"
#import "DVSHTTPClient+User.h"
#import "DVSUser.h"
#import "DVSUser+Persistence.h"
#import "DVSUser+Querying.h"
#import "NSDictionary+Devise.h"
#import "NSObject+Devise.h"

NSString * const DVSDefaultRegisterPath = @"/";
NSString * const DVSDefaultLogInPath = @"/sign_in";
NSString * const DVSDefaultUpdatePath = @"/";
NSString * const DVSDefaultDeletePath = @"/";
NSString * const DVSDefaultChangePasswordPath = @"/password";
NSString * const DVSDefaultRemindPasswordPath = @"/password";

@interface DVSUser ()

@property (strong, nonatomic, readwrite) NSString *identifier;
@property (strong, nonatomic, readwrite) NSString *sessionToken;

@end

#pragma mark -

@implementation DVSHTTPClient (User)

#pragma mark - Standard methods

- (void)registerUser:(DVSUser *)user success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    [self POST:DVSDefaultRegisterPath parameters:[user registerJSON] completion:^(__unused id responseObject, NSError *error) {
        if (error != nil) {
            if (failure != NULL) failure(error);
        } else {
            [self fillUser:user withJSONRepresentation:responseObject[@"user"]];
            [[user class] setLocalUser:user];
            if (success != NULL) success();
        }
    }];
}

- (void)logInUser:(DVSUser *)user success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    [self POST:DVSDefaultLogInPath parameters:[user loginJSON] completion:^(id responseObject, NSError *error) {
        if (error != nil) {
            if (failure != NULL) failure(error);
        } else {
            [self fillUser:user withJSONRepresentation:responseObject[@"user"]];
            [[user class] setLocalUser:user];
            if (success != NULL) success();
        }
    }];
}

- (void)updateUser:(DVSUser *)user success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    [self setAuthorizationToken:user.sessionToken email:[[user class] persistentXUserEmail]];
    [self POST:DVSDefaultUpdatePath parameters:[user updateJSON] completion:^(__unused id responseObject, NSError *error) {
        if (error != nil) {
            if (failure != NULL) failure(error);
        } else {
            if (success != NULL) success();
        }
    }];
}

- (void)deleteUser:(DVSUser *)user success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    [self setAuthorizationToken:user.sessionToken email:[[user class] persistentXUserEmail]];
    [self DELETE:DVSDefaultDeletePath parameters:nil completion:^(__unused id responseObject, NSError *error) {
        if (error != nil) {
            if (failure != NULL) failure(error);
        } else {
            [[user class] removeLocalUser];
            if (success != NULL) success();
        }
    }];
}

- (void)changePasswordOfUser:(DVSUser *)user success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    [self setAuthorizationToken:user.sessionToken email:[[user class] persistentXUserEmail]];
    [self PUT:DVSDefaultChangePasswordPath parameters:[user changePasswordJSON] completion:^(__unused id responseObject, NSError *error) {
        if (error != nil) {
            if (failure != NULL) failure(error);
        } else {
            if (success != NULL) success();
        }
    }];
}

- (void)remindPasswordToUser:(DVSUser *)user success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    [self POST:DVSDefaultRemindPasswordPath parameters:[user forgotPasswordJSON] completion:^(__unused id responseObject, NSError *error) {
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

#pragma mark - Helper methods

- (void)fillUser:(DVSUser *)user withJSONRepresentation:(NSDictionary *)json {
    for (NSString *key in [user dvs_properties]) {
        if (json[key] != nil) {
            [user setValue:json[key] forKey:key];
        }
    }
    user.identifier = [json dvs_stringValueForKey:@"id"];
    user.email = [json dvs_stringValueForKey:@"email"];
    user.sessionToken = [json dvs_stringValueForKey:@"authenticationToken"];
}

@end
