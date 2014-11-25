//
//  SSKAPIManager.h
//  
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSKTypedefs.h"

@class SSKUser;

@interface SSKAPIManager : NSObject

+ (void)registerUser:(SSKUser *)user withSuccess:(SSKVoidBlock)success failure:(SSKErrorBlock)failure;
+ (void)loginUser:(SSKUser *)user withSuccess:(SSKVoidBlock)success failure:(SSKErrorBlock)failure;
+ (void)remindPasswordForUser:(SSKUser *)user withSuccess:(SSKVoidBlock)success failure:(SSKErrorBlock)failure;

@end
