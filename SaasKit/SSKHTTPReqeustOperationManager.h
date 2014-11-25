//
//  SSKHTTPReqeustOperationManager.h
//  
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "SSKTypedefs.h"

#define SSKNetworkManager [SSKHTTPReqeustOperationManager sharedInstance]

@interface SSKHTTPReqeustOperationManager : AFHTTPRequestOperationManager

+ (instancetype)sharedInstance;

- (void)requestWithPOST:(NSDictionary *)parameters path:(NSString *)path success:(SSKObjectBlock)success failure:(SSKErrorBlock)failure;
- (void)requestWithGET:(NSString *)query path:(NSString *)path success:(SSKObjectBlock)success failure:(SSKErrorBlock)failure;

@end
