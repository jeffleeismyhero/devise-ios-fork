//
//  SSKAPIManager.m
//  SaasKit
//
//  Created by Patryk Kaczmarek on 19.11.2014.
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import "SSKAPIManager.h"
#import "SSKHTTPReqeustOperationManager.h"
#import "SSKMacros.h"
#import "SSKUser+Query.h"
#import "SaasKit.h"

@implementation SSKAPIManager

#pragma mark - Public Methods

+ (void)registerUser:(SSKUser *)user withSuccess:(SSKVoidBlock)success failure:(SSKErrorBlock)failure {
    
    DLog(@"\nRegistration:\n\nGET: %@\n\nPOST: %@", [user registerQuery], [user registerPOST]);
    
    SSKRequestType requestType = [user requestTypeForSelector:@selector(requestTypeForUserRegistration:)];
    NSString *path = [SaasKit pathForRoute:SSKRouteRegister];
    
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
    
    DLog(@"\nLogin:\n\nGET: %@\n\nPOST: %@", [user loginQuery], [user loginPOST]);
    
    SSKRequestType requestType = [user requestTypeForSelector:@selector(requestTypeForUserLogin:)];
    NSString *path = [SaasKit pathForRoute:SSKRouteLogin];
    
    if (requestType == SSKRequestPOST) {
        
        [SSKNetworkManager requestWithPOST:[user loginPOST] path:path success:^(id object) {
            success();
        } failure:^(NSError *error) {
            failure(error);
        }];
    } else {
        
        [SSKNetworkManager requestWithGET:[user loginQuery] path:path success:^(id object) {
            success();
        } failure:^(NSError *error) {
            failure(error);
        }];
    }
}

+ (void)remindPasswordForUser:(SSKUser *)user withSuccess:(SSKVoidBlock)success failure:(SSKErrorBlock)failure {
    
    DLog(@"\nRemind Password:\n\nGET: %@\n\nPOST: %@", [user remindPasswordQuery], [user remindPasswordPOST]);
    
    SSKRequestType requestType = [user requestTypeForSelector:@selector(requestTypeForUserRemindPassword:)];
    NSString *path = [SaasKit pathForRoute:SSKRouteForgotPassword];
    
    if (requestType == SSKRequestPOST) {
        
        [SSKNetworkManager requestWithPOST:[user remindPasswordPOST] path:[SaasKit pathForRoute:SSKRouteForgotPassword] success:^(id object) {
            success();
        } failure:^(NSError *error) {
            failure(error);
        }];
    } else {
        
        [SSKNetworkManager requestWithGET:[user remindPasswordQuery] path:path success:^(id object) {
            success();
        } failure:^(NSError *error) {
            failure(error);
        }];
    }
}
     
@end
