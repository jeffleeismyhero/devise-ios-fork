//
//  DVSHTTPReqeustOperationManager.h
//  
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "DVSTypedefs.h"

#define DVSNetworkManager [DVSHTTPReqeustOperationManager sharedInstance]

@interface DVSHTTPReqeustOperationManager : AFHTTPRequestOperationManager

+ (instancetype)sharedInstance;

- (void)requestWithGET:(id)parameters path:(NSString *)path success:(DVSResponseBlock)success failure:(DVSErrorBlock)failure;
- (void)requestWithDELETE:(id)parameters path:(NSString *)path success:(DVSResponseBlock)success failure:(DVSErrorBlock)failure;
- (void)requestWithPUT:(id)parameters path:(NSString *)path success:(DVSResponseBlock)success failure:(DVSErrorBlock)failure;
- (void)requestWithPOST:(NSDictionary *)parameters path:(NSString *)path success:(DVSResponseBlock)success failure:(DVSErrorBlock)failure;

- (void)setupAuthorizationHeaderWithToken:(NSString *)token email:(NSString *)email;

@end
