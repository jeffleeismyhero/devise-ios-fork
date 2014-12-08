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

@implementation DVSAPIManager

#pragma mark - Public Methods

+ (void)registerUser:(DVSUser *)user withSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    
    DVSDLog(@"\nRegistration:\n\nPOST: %@", [user registerPOST]);
    
    NSString *path = [[DVSConfiguration sharedConfiguration] pathForRoute:DVSRouteRegister];
    [DVSNetworkManager setAuthorizationToken:[user dvs_token]];
    
    [DVSNetworkManager requestWithPOST:[user registerPOST] path:path success:^(NSDictionary *response, NSUInteger code)  {
        [user dvs_saveSensitiveData:response] ? success () : failure([NSError dvs_errorWithErrorResponse:response]);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)loginUser:(DVSUser *)user withSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    
    DVSDLog(@"\nLogin:\n\nGET: %@\n\nPOST: %@", [user loginQuery], [user loginPOST]);
    
    DVSRequestType requestType = [user requestTypeForSelector:@selector(requestTypeForUserLogin:)];
    NSString *path = [[DVSConfiguration sharedConfiguration] pathForRoute:DVSRouteLogin];
    
    if (requestType == DVSRequestPOST) {
        
        [DVSNetworkManager requestWithPOST:[user loginPOST] path:path success:^(NSDictionary *response, NSUInteger code) {
            [user dvs_saveSensitiveData:response] ? success () : failure([NSError dvs_errorWithErrorResponse:response]);
        } failure:^(NSError *error) {
            failure(error);
        }];
    } else {
        
        [DVSNetworkManager requestWithGET:[user loginQuery] path:path success:^(NSDictionary *response, NSUInteger code) {
            [user dvs_saveSensitiveData:response] ? success () : failure([NSError dvs_errorWithErrorResponse:response]);
        } failure:^(NSError *error) {
            failure(error);
        }];
    }
}

+ (void)remindPasswordForUser:(DVSUser *)user withSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    
    DVSDLog(@"\nRemind Password:\n\nPOST: %@", [user forgotPasswordPOST]);
    
    NSString *path = [[DVSConfiguration sharedConfiguration] pathForRoute:DVSRouteForgotPassword];
    [DVSNetworkManager setAuthorizationToken:[user dvs_token]];
    
    [DVSNetworkManager requestWithPOST:[user forgotPasswordPOST] path:path success:^(NSDictionary *response, NSUInteger code) {
        success();
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)deleteUser:(DVSUser *)user withSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    
    DVSTemporary("server paths will change soon. Take care of it. Temporary hardcoded below");
    
    NSString *path = [NSString stringWithFormat:@"v1/users/%@", [user dvs_identifier]];
    [DVSNetworkManager setAuthorizationToken:[user dvs_token]];
    
    [DVSNetworkManager requestWithDELETE:path success:^(NSDictionary *response, NSUInteger code) {
        BOOL deleted = [[user dvs_identifier] isEqualToString:[response[@"user"] dvs_stringValueForKey:@"id"]];
        deleted ? success () : failure([NSError dvs_errorWithErrorResponse:response]);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

@end
