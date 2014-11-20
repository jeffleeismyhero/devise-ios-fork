//
//  SSKAPIManager.h
//  SaasKit
//
//  Created by Patryk Kaczmarek on 19.11.2014.
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSKDefines.h"

@class SSKUser;

@interface SSKAPIManager : NSObject

@property (strong, nonatomic) NSString *lol;

+ (void)registerUser:(SSKUser *)user withSuccess:(SSKVoidBlock)success failure:(SSKErrorBlock)failure;
+ (void)loginUser:(SSKUser *)user withSuccess:(SSKVoidBlock)success failure:(SSKErrorBlock)failure;
+ (void)remindPasswordForUser:(SSKUser *)user withSuccess:(SSKVoidBlock)success failure:(SSKErrorBlock)failure;

@end
