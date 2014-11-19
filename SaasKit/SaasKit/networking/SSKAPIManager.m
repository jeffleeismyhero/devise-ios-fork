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

@implementation SSKAPIManager

#pragma mark - Public Methods

+ (void)registerUser:(SSKUser *)user withSuccess:(SSKVoidBlock)success failure:(SSKErrorBlock)failure {
    
    SSKWorkInProgress("Configuration needed - waiting for endpoints");
    
    [SSKNetworkManager GET:@"" parameters:@"" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

+ (void)loginUser:(SSKUser *)user withSuccess:(SSKVoidBlock)success failure:(SSKErrorBlock)failure {
    
    SSKWorkInProgress("Configuration needed - waiting for endpoints");
    
    [SSKNetworkManager GET:@"" parameters:@"" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

+ (void)remindPasswordForUser:(SSKUser *)user withSuccess:(SSKVoidBlock)success failure:(SSKErrorBlock)failure {
    
    SSKWorkInProgress("Configuration needed - waiting for endpoints");
    
    [SSKNetworkManager GET:@"" parameters:@"" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

#pragma mark - Private Methods

@end
