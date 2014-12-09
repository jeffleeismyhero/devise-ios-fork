//
//  DVSHTTPReqeustOperationManager.m
//  Devise
//
//  Created by Patryk Kaczmarek on 19.11.2014.
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import "DVSHTTPReqeustOperationManager.h"
#import "DVSConfiguration.h"
#import "DVSMacros.h"
#import "NSError+Devise.h"

@implementation DVSHTTPReqeustOperationManager

#pragma mark - Pubic Methods

+ (instancetype)sharedInstance {
    static DVSHTTPReqeustOperationManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        DVSWorkInProgress("Configuration needed");
        
        DVSHTTPReqeustOperationManager *manager = [DVSHTTPReqeustOperationManager manager];
    
        //request serializer:
        AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
        [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [manager setRequestSerializer:requestSerializer];

        AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
        [manager setResponseSerializer:responseSerializer];
        
        sharedInstance = manager;
    });
    return sharedInstance;
}

- (void)requestWithPOST:(NSDictionary *)parameters path:(NSString *)path success:(DVSResponseBlock)success failure:(DVSErrorBlock)failure {
    
    DVSDLog(@"path: %@\n\nPOST: %@", path, parameters);
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self POST:[self urlWithPath:path] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self invokeSuccessBlock:success withOperation:operation response:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self invokeFailureBlock:failure withOperation:operation error:error];
    }];
}

- (void)requestWithGET:(id)parameters path:(NSString *)path success:(DVSResponseBlock)success failure:(DVSErrorBlock)failure {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self GET:[self urlWithPath:path] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self invokeSuccessBlock:success withOperation:operation response:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self invokeFailureBlock:failure withOperation:operation error:error];
    }];
}

- (void)requestWithDELETE:(id)parameters path:(NSString *)path success:(DVSResponseBlock)success failure:(DVSErrorBlock)failure {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self DELETE:[self urlWithPath:path] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self invokeSuccessBlock:success withOperation:operation response:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self invokeFailureBlock:failure withOperation:operation error:error];
    }];
}

- (void)requestWithPUT:(id)parameters path:(NSString *)path success:(DVSResponseBlock)success failure:(DVSErrorBlock)failure {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self PUT:[self urlWithPath:path] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self invokeSuccessBlock:success withOperation:operation response:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self invokeFailureBlock:failure withOperation:operation error:error];
    }];
}

- (void)setupAuthorizationHeaderWithToken:(NSString *)token email:(NSString *)email {
    [self.requestSerializer setValue:token forHTTPHeaderField:@"X-User-Token"];
    [self.requestSerializer setValue:email forHTTPHeaderField:@"X-User-Email"];
}

#pragma mark - Private Methods

- (void)invokeFailureBlock:(DVSErrorBlock)failure withOperation:(AFHTTPRequestOperation *)operation error:(NSError *)error {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    if (operation.responseObject) {
        error = [NSError dvs_errorWithErrorResponse:operation.responseObject];
    }
    failure(error);
}

- (void)invokeSuccessBlock:(DVSResponseBlock)success withOperation:(AFHTTPRequestOperation *)operation response:(id)response {
    DVSDLog(@"reponse: %@", response);
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    success(response, operation.response.statusCode);
}


- (NSString *)urlWithPath:(NSString *)path {
    
    NSAssert([DVSConfiguration sharedConfiguration].serverURL, @"Server URL path missing. Use DVSCongiuration class to configure connection.");
    
    NSMutableString *url = [[DVSConfiguration sharedConfiguration].serverURL.absoluteString mutableCopy];
    if (path) {
        [url appendFormat:@"/%@", path];
    }
    return [url copy]; //make it immutable
}

@end
