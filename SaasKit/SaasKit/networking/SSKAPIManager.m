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


+ (void)loginUser:(SSKUser *)user withSuccess:(SSKUserBlock)success failure:(SSKErrorBlock)failure {
    
    SSKWorkInProgress("Configuration needed - waiting for endpoints");
    
    [SSKNetworkManager GET:@"" parameters:@"" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(user);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

@end
