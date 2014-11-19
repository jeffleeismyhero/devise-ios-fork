//
//  SSKUser.h
//  SaasKit
//
//  Created by Patryk Kaczmarek on 19.11.2014.
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import "SSKObject.h"

typedef NS_ENUM(NSInteger, SSKLoginMethod) {
    SSKLoginUsingEmail,
    SSKLoginUsingUsername
};

@interface SSKUser : SSKObject

@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *password;

@property (nonatomic, assign) SSKLoginMethod loginMethod; //default SSKLoginUsingEmail

///designed initializer
- (instancetype)user;

- (void)loginWithSuccessBlock:(SSKUserSuccessBlock)success
                 failureBlock:(SSKFailureBlock)failure;

@end
