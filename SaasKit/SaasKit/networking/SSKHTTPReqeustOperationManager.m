//
//  SSKHTTPReqeustOperationManager.m
//  SaasKit
//
//  Created by Patryk Kaczmarek on 19.11.2014.
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import "SSKHTTPReqeustOperationManager.h"
#import "SSKMacros.h"

@implementation SSKHTTPReqeustOperationManager

+ (instancetype)sharedInstance {
    static SSKHTTPReqeustOperationManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        
        SSKHTTPReqeustOperationManager *manager = [SSKHTTPReqeustOperationManager manager];
    
//        //request serializer:
//        AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
//        [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Typxe"];
//        [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//        [manager setRequestSerializer:requestSerializer];
//
//        AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
//        [manager setResponseSerializer:responseSerializer];
        
        sharedInstance = manager;
    });
    
    return sharedInstance;
}

@end
