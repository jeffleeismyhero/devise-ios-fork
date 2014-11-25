//
//  SSKHTTPReqeustOperationManager.m
//  SaasKit
//
//  Created by Patryk Kaczmarek on 19.11.2014.
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import "SSKHTTPReqeustOperationManager.h"
#import "SSKConfiguration.h"
#import "SSKMacros.h"

@implementation SSKHTTPReqeustOperationManager

+ (instancetype)sharedInstance {
    static SSKHTTPReqeustOperationManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        SSKWorkInProgress("Configuration needed");
        
        SSKHTTPReqeustOperationManager *manager = [SSKHTTPReqeustOperationManager manager];
    
        //request serializer:
        AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
        [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Typxe"];
        [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [manager setRequestSerializer:requestSerializer];

        AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager setResponseSerializer:responseSerializer];
        
        sharedInstance = manager;
    });
    return sharedInstance;
}

- (void)requestWithPOST:(NSDictionary *)parameters path:(NSString *)path success:(SSKObjectBlock)success failure:(SSKErrorBlock)failure {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self POST:[self urlWithPath:path query:nil] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        failure(error);
    }];
}

- (void)requestWithGET:(NSString *)query path:(NSString *)path success:(SSKObjectBlock)success failure:(SSKErrorBlock)failure {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self GET:[self urlWithPath:path query:query] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        failure(error);
    }];
}

#pragma Private Methods

- (NSString *)urlWithPath:(NSString *)path query:(NSString *)query {
    
    BOOL hasInvalidSyntax = (query && !path);
    NSAssert2(!hasInvalidSyntax, @"Query (%@) cannot exists without specified path(%@)", query, path);
    NSAssert([SSKConfiguration sharedConfiguration].serverURL, @"You have to specify serverURLPath. Initialize SaasKit using [SaasKit initializeKitWithServerPath:#yourServerPath#]");
    
    NSMutableString *url = [[SSKConfiguration sharedConfiguration].serverURL.absoluteString mutableCopy];
    if (path) {
        [url appendFormat:@"/%@", path];
    }
    if (query) {
        [url appendFormat:@"?%@", query];
    }
    return [url copy]; //make it immutable
}

@end
