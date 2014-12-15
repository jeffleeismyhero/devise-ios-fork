//
//  DVSAPIManager.m
//
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import "DVSAPIManager.h"
#import "DVSConfiguration.h"
#import "NSDictionary+Devise.h"
#import "NSError+Devise.h"
#import "DVSHTTPReqeustOperationManager.h"
#import "DVSUser+Persistence.h"
#import "DVSUser+Querying.h"
#import "NSObject+Devise.h"

NSString * const DVSDefaultLoginPath = @"sign_in";
NSString * const DVSDefaultPasswordPath = @"password";

@interface DVSUser ()

@property (strong, nonatomic, readwrite) NSString *identifier;
@property (strong, nonatomic, readwrite) NSString *sessionToken;

@end

#pragma mark -

@implementation DVSAPIManager

#pragma mark - Public Methods

+ (void)registerUser:(DVSUser *)user withSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    NSString *path = [self pathForRoute:DVSRouteUser param:nil];
    [DVSNetworkManager requestWithPOST:[user registerJSON] path:path success:^(NSDictionary *response, NSUInteger code) {
        [self storeUser:user withResponse:response];
        if (success != NULL) success();
    } failure:^(NSError *error) {
        if (failure != NULL) failure(error);
    }];
}

+ (void)updateUser:(DVSUser *)user withSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    NSString *path = [self pathForRoute:DVSRouteUser param:nil];
    [DVSNetworkManager setupAuthorizationHeaderWithToken:user.sessionToken email:[DVSUser persistentXUserEmail]];
    [DVSNetworkManager requestWithPUT:[user updateJSON] path:path success:^(NSDictionary *response, NSUInteger code) {
        [self storeUser:user withResponse:response];
        if (success != NULL) success();
    } failure:^(NSError *error) {
        if (failure != NULL) failure(error);
    }];
}

+ (void)loginUser:(DVSUser *)user withSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    NSString *path = [self pathForRoute:DVSRouteUser param:DVSDefaultLoginPath];
    [DVSNetworkManager requestWithPOST:[user loginJSON] path:path success:^(NSDictionary *response, NSUInteger code) {
        [self storeUser:user withResponse:response];
        if (success != NULL) success();
    } failure:^(NSError *error) {
        if (failure != NULL) failure(error);
    }];
}

+ (void)remindPasswordForUser:(DVSUser *)user withSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    NSString *path = [self pathForRoute:DVSRouteUser param:DVSDefaultPasswordPath];
    [DVSNetworkManager requestWithPOST:[user forgotPasswordJSON] path:path success:^(NSDictionary *response, NSUInteger code) {
        if (success != NULL) success();
    } failure:^(NSError *error) {
        if (failure != NULL) failure(error);
    }];
}

+ (void)changePasswordForUser:(DVSUser *)user withSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    NSString *path = [self pathForRoute:DVSRouteUser param:DVSDefaultPasswordPath];
    [DVSNetworkManager setupAuthorizationHeaderWithToken:user.sessionToken email:[DVSUser persistentXUserEmail]];
    [DVSNetworkManager requestWithPUT:[user changePasswordJSON] path:path success:^(NSDictionary *response, NSUInteger code) {
        [self storeUser:user withResponse:response];
        if (success != NULL) success();
    } failure:^(NSError *error) {
        if (failure != NULL) failure(error);
    }];
}

+ (void)deleteUser:(DVSUser *)user withSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    NSString *path = [self pathForRoute:DVSRouteUser param:nil];
    [DVSNetworkManager setupAuthorizationHeaderWithToken:user.sessionToken email:[DVSUser persistentXUserEmail]];
    [DVSNetworkManager requestWithDELETE:nil path:path success:^(NSDictionary *response, NSUInteger code) {
        [[user class] removeLocalUser];
        if (success != NULL) success();
    } failure:^(NSError *error) {
        if (failure != NULL) failure(error);
    }];
}

#pragma mark - Private Methods

+ (NSString *)pathForRoute:(DVSRoute)route param:(NSString *)param {
    DVSConfiguration *configuration = [DVSConfiguration sharedConfiguration];
    NSString *versionPath = [NSString stringWithFormat:@"v%lu", (unsigned long)configuration.apiVersion];
    NSString *routePath = [configuration pathForRoute:route];
    NSString *fullPath = [versionPath stringByAppendingPathComponent:routePath];
    if (param) {
        fullPath = [fullPath stringByAppendingPathComponent:param];
    }
    return fullPath;
}

+ (void)storeUser:(DVSUser *)user withResponse:(NSDictionary *)response {
    [self mapUserProperties:user usingResponse:response[@"user"]];
    [[user class] setLocalUser:user];
}

+ (void)mapUserProperties:(DVSUser *)user usingResponse:(NSDictionary *)response {
    
    user.identifier = [response dvs_stringValueForKey:@"id"];
    user.sessionToken = response[@"authenticationToken"];
    
    NSArray *properties = [user dvs_properties];
    
    for (NSString *property in properties) {
        for (NSString *key in response.allKeys) {
            if ([property isEqualToString:key]) {
                [user setValue:response[key] forKey:property];
                break;
            }
        }
    }
}

@end