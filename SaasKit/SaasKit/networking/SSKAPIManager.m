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
    
    SSKWorkInProgress("Configuration needed - waiting for endpoints");
    
    [SSKNetworkManager requestWithPOST:[user registerPOST] path:[SaasKit pathForRoute:SSKRouteRegister] success:^(id object) {
        success();
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)loginUser:(SSKUser *)user withSuccess:(SSKVoidBlock)success failure:(SSKErrorBlock)failure {
    
    SSKWorkInProgress("Configuration needed - waiting for endpoints");
    
    [SSKNetworkManager requestWithGET:[user loginQuery] path:[SaasKit pathForRoute:SSKRouteLogin] success:^(id object) {
        success();
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)remindPasswordForUser:(SSKUser *)user withSuccess:(SSKVoidBlock)success failure:(SSKErrorBlock)failure {
    
    SSKWorkInProgress("Configuration needed - waiting for endpoints");
    
    [SSKNetworkManager requestWithPOST:[user remindPasswordPOST] path:[SaasKit pathForRoute:SSKRouteForgotPassword] success:^(id object) {
        success();
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark - Private Methods

@end
