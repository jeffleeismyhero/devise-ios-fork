//
//  SSKHTTPReqeustOperationManager.h
//  SaasKit
//
//  Created by Patryk Kaczmarek on 19.11.2014.
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"
#import "SSKDefines.h"

#define SSKNetworkManager [SSKHTTPReqeustOperationManager sharedInstance]

@interface SSKHTTPReqeustOperationManager : AFHTTPRequestOperationManager

+ (instancetype)sharedInstance;

- (void)requestWithPOST:(NSDictionary *)parameters path:(NSString *)path success:(SSKObjectBlock)success failure:(SSKErrorBlock)failure;
- (void)requestWithGET:(NSString *)query path:(NSString *)path success:(SSKObjectBlock)success failure:(SSKErrorBlock)failure;

@end
