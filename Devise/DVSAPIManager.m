//
//  DVSAPIManager.m
//
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import "DVSAPIManager.h"
#import "DVSHTTPReqeustOperationManager.h"
#import "DVSConfiguration.h"
#import "DVSUser+Querying.h"
#import "DVSUser+Memorize.h"
#import "DVSMacros.h"
#import "NSError+Devise.h"
#import "NSDictionary+Devise.h"

NSString * const loginPath = @"sign_in";
NSString * const passwordPath = @"password";

@implementation DVSAPIManager

#pragma mark - Public Methods

+ (void)registerUser:(DVSUser *)user withSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    
    NSString *path = [self pathForRoute:DVSRouteUser param:nil];
    
    [DVSNetworkManager requestWithPOST:[user registerJSON] path:path success:^(NSDictionary *response, NSUInteger code)  {
        [user dvs_saveSensitiveData:response] ? success () : failure([NSError dvs_errorWithErrorResponse:response]);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)updateUser:(DVSUser *)user withSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    
    NSString *path = [self pathForRoute:DVSRouteUser param:nil];
    [DVSNetworkManager setupAuthorizationHeaderWithToken:[user dvs_token] email:[user dvs_email]];
    
    [DVSNetworkManager requestWithPUT:[user updateJSON] path:path success:^(NSDictionary *response, NSUInteger code) {
        [user dvs_saveSensitiveData:response] ? success () : failure([NSError dvs_errorWithErrorResponse:response]);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)loginUser:(DVSUser *)user withSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    
    NSString *path = [self pathForRoute:DVSRouteUser param:loginPath];
    
    [DVSNetworkManager requestWithPOST:[user loginJSON] path:path success:^(NSDictionary *response, NSUInteger code) {
        [user dvs_saveSensitiveData:response] ? success () : failure([NSError dvs_errorWithErrorResponse:response]);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)remindPasswordForUser:(DVSUser *)user withSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {

    NSString *path = [self pathForRoute:DVSRouteUser param:passwordPath];
    
    [DVSNetworkManager requestWithPOST:[user forgotPasswordJSON] path:path success:^(NSDictionary *response, NSUInteger code) {
        success();
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)changePasswordForUser:(DVSUser *)user withSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    
    NSString *path = [self pathForRoute:DVSRouteUser param:passwordPath];
    [DVSNetworkManager setupAuthorizationHeaderWithToken:[user dvs_token] email:[user dvs_email]];
    
    [DVSNetworkManager requestWithPUT:[user changePasswordJSON] path:path success:^(NSDictionary *response, NSUInteger code) {
        [user dvs_saveSensitiveData:response] ? success () : failure([NSError dvs_errorWithErrorResponse:response]);
        success();
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)deleteUser:(DVSUser *)user withSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    
    NSString *path = [self pathForRoute:DVSRouteUser param:nil];
    [DVSNetworkManager setupAuthorizationHeaderWithToken:[user dvs_token] email:[user dvs_email]];
    
    [DVSNetworkManager requestWithDELETE:nil path:path success:^(NSDictionary *response, NSUInteger code) {
        BOOL deleted = [[user dvs_identifier] isEqualToString:[response[@"user"] dvs_stringValueForKey:@"id"]];
        deleted ? success () : failure([NSError dvs_errorWithErrorResponse:response]);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark - Private Methods

+ (NSString *)pathForRoute:(DVSRoute)route param:(NSString *)param {
    DVSConfiguration *configuration = [DVSConfiguration sharedConfiguration];
    NSString *path = [NSString stringWithFormat:@"%@/%@", configuration.apiVersion, [configuration pathForRoute:route]];
    if (param) {
        path = [path stringByAppendingFormat:@"/%@", param];
    }
    return path;
}

@end
