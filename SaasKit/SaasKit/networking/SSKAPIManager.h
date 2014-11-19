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

+ (void)loginUser:(SSKUser *)user withSuccess:(SSKUserBlock)success failure:(SSKErrorBlock)failure;

@end
