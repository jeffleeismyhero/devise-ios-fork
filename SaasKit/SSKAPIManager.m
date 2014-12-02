//
//  SSKAPIManager.m
//
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import "SSKAPIManager.h"
#import "SSKHTTPReqeustOperationManager.h"
#import "SSKConfiguration.h"
#import "SSKUser+Querying.h"
#import "SSKMacros.h"
#import "NSError+SassKit.h"

@implementation SSKAPIManager

#pragma mark - Public Methods

+ (void)registerUser:(SSKUser *)user withSuccess:(SSKVoidBlock)success failure:(SSKErrorBlock)failure {
    
    SSKDLog(@"\nRegistration:\n\nGET: %@\n\nPOST: %@", [user registerQuery], [user registerPOST]);
    
    SSKRequestType requestType = [user requestTypeForSelector:@selector(requestTypeForUserRegistration:)];
    NSString *path = [[SSKConfiguration sharedConfiguration] pathForRoute:SSKRouteRegister];
    
    if (requestType == SSKRequestPOST) {
        
        [SSKNetworkManager requestWithPOST:[user registerPOST] path:path success:^(id object) {
            success();
        } failure:^(NSError *error) {
            failure(error);
        }];
    } else {
        
        [SSKNetworkManager requestWithGET:[user registerQuery] path:path success:^(id object) {
            success();
        } failure:^(NSError *error) {
            failure(error);
        }];
    }
}

+ (void)loginUser:(SSKUser *)user withSuccess:(SSKVoidBlock)success failure:(SSKErrorBlock)failure {
    
    SSKDLog(@"\nLogin:\n\nGET: %@\n\nPOST: %@", [user loginQuery], [user loginPOST]);
    
    SSKRequestType requestType = [user requestTypeForSelector:@selector(requestTypeForUserLogin:)];
    NSString *path = [[SSKConfiguration sharedConfiguration] pathForRoute:SSKRouteLogin];
    
    if (requestType == SSKRequestPOST) {
        
        [SSKNetworkManager requestWithPOST:[user loginPOST] path:path success:^(NSDictionary *response) {
            
            if (response[@"error"]) {
                failure([NSError ssk_errorWithErrorResponse:response[@"error"]]);
                
            } else if (response[@"user"]) {
                [user setupWithDictionary:response[@"user"]];
                success();
                
            } else {
                NSError *error = [NSError ssk_errorForEmptyResponse];
                failure(error);
            }

        } failure:^(NSError *error) {
            failure(error);
        }];
    } else {
        
        [SSKNetworkManager requestWithGET:[user loginQuery] path:path success:^(NSDictionary *response) {
            success();
        } failure:^(NSError *error) {
            failure(error);
        }];
    }
}

+ (void)remindPasswordForUser:(SSKUser *)user withSuccess:(SSKVoidBlock)success failure:(SSKErrorBlock)failure {
    
    SSKDLog(@"\nRemind Password:\n\nGET: %@\n\nPOST: %@", [user forgotPasswordQuery], [user forgotPasswordPOST]);
    
    SSKRequestType requestType = [user requestTypeForSelector:@selector(requestTypeForUserRemindPassword:)];
    NSString *path = [[SSKConfiguration sharedConfiguration] pathForRoute:SSKRouteForgotPassword];
    
    if (requestType == SSKRequestPOST) {
        
        [SSKNetworkManager requestWithPOST:[user forgotPasswordPOST] path:[[SSKConfiguration sharedConfiguration] pathForRoute:SSKRouteForgotPassword] success:^(id object) {
            success();
        } failure:^(NSError *error) {
            failure(error);
        }];
    } else {
        
        [SSKNetworkManager requestWithGET:[user forgotPasswordQuery] path:path success:^(id object) {
            success();
        } failure:^(NSError *error) {
            failure(error);
        }];
    }
}
     
@end
