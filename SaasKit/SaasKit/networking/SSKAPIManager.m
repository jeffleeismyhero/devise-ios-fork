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


+ (void)loginUser:(SSKUser *)user withSuccess:(SSKUserSuccessBlock)success failure:(SSKFailureBlock)failure {
    
    SSKWorkInProgress("Configuration needed");
    
    [SSKNetworkManager GET:@"" parameters:@"" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(user);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

@end
