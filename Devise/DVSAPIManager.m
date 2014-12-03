//
//  DVSAPIManager.m
//
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import "DVSAPIManager.h"
#import "DVSHTTPReqeustOperationManager.h"
#import "DVSConfiguration.h"
#import "DVSUser+Querying.h"
#import "DVSMacros.h"
#import "NSError+Devise.h"

@implementation DVSAPIManager

#pragma mark - Public Methods

+ (void)registerUser:(DVSUser *)user withSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    
    DVSDLog(@"\nRegistration:\n\nGET: %@\n\nPOST: %@", [user registerQuery], [user registerPOST]);
    
    DVSRequestType requestType = [user requestTypeForSelector:@selector(requestTypeForUserRegistration:)];
    NSString *path = [[DVSConfiguration sharedConfiguration] pathForRoute:DVSRouteRegister];
    
    if (requestType == DVSRequestPOST) {
        
        [DVSNetworkManager requestWithPOST:[user registerPOST] path:path success:^(id object) {
            success();
        } failure:^(NSError *error) {
            failure(error);
        }];
    } else {
        
        [DVSNetworkManager requestWithGET:[user registerQuery] path:path success:^(id object) {
            success();
        } failure:^(NSError *error) {
            failure(error);
        }];
    }
}

+ (void)loginUser:(DVSUser *)user withSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    
    DVSDLog(@"\nLogin:\n\nGET: %@\n\nPOST: %@", [user loginQuery], [user loginPOST]);
    
    DVSRequestType requestType = [user requestTypeForSelector:@selector(requestTypeForUserLogin:)];
    NSString *path = [[DVSConfiguration sharedConfiguration] pathForRoute:DVSRouteLogin];
    
    if (requestType == DVSRequestPOST) {
        
        [DVSNetworkManager requestWithPOST:[user loginPOST] path:path success:^(NSDictionary *response) {
            
            if (response[@"user"]) {
                [user setupWithDictionary:response[@"user"]];
                success();
                
            } else {
                failure([NSError dvs_errorWithErrorResponse:response]);
            }

        } failure:^(NSError *error) {
            failure(error);
        }];
    } else {
        
        [DVSNetworkManager requestWithGET:[user loginQuery] path:path success:^(NSDictionary *response) {
            success();
        } failure:^(NSError *error) {
            failure(error);
        }];
    }
}

+ (void)remindPasswordForUser:(DVSUser *)user withSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    
    DVSDLog(@"\nRemind Password:\n\nGET: %@\n\nPOST: %@", [user forgotPasswordQuery], [user forgotPasswordPOST]);
    
    DVSRequestType requestType = [user requestTypeForSelector:@selector(requestTypeForUserRemindPassword:)];
    NSString *path = [[DVSConfiguration sharedConfiguration] pathForRoute:DVSRouteForgotPassword];
    
    if (requestType == DVSRequestPOST) {
        
        [DVSNetworkManager requestWithPOST:[user forgotPasswordPOST] path:[[DVSConfiguration sharedConfiguration] pathForRoute:DVSRouteForgotPassword] success:^(id object) {
            success();
        } failure:^(NSError *error) {
            failure(error);
        }];
    } else {
        
        [DVSNetworkManager requestWithGET:[user forgotPasswordQuery] path:path success:^(id object) {
            success();
        } failure:^(NSError *error) {
            failure(error);
        }];
    }
}
     
@end
