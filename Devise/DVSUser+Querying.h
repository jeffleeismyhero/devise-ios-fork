//
//  DVSUser+Querying.h
//  
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DVSUser.h"

@interface DVSUser (Querying)

- (NSString *)loginQuery;
- (NSDictionary *)loginPOST;

/// Forgot password is available only via POST request
- (NSDictionary *)forgotPasswordPOST;

- (NSString *)registerQuery;
- (NSDictionary *)registerPOST;

- (DVSRequestType)requestTypeForSelector:(SEL)selector;

@end
