//
//  SSKHTTPReqeustOperationManager.h
//  SaasKit
//
//  Created by Patryk Kaczmarek on 19.11.2014.
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

#define SSKNetworkManager [SSKHTTPReqeustOperationManager sharedInstance]

@interface SSKHTTPReqeustOperationManager : AFHTTPRequestOperationManager

+ (instancetype)sharedInstance;

@end
