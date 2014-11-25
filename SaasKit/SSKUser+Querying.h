//
//  SSKUser+Querying.h
//  
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSKUser.h"

@interface SSKUser (Querying)

- (NSString *)loginQuery;
- (NSDictionary *)loginPOST;

- (NSString *)forgotPasswordQuery;
- (NSDictionary *)forgotPasswordPOST;

- (NSString *)registerQuery;
- (NSDictionary *)registerPOST;

- (SSKRequestType)requestTypeForSelector:(SEL)selector;

@end
