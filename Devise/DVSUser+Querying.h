//
//  DVSUser+Querying.h
//  
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DVSUser.h"

@interface DVSUser (Querying)

- (NSDictionary *)loginPOST;
- (NSDictionary *)forgotPasswordPOST;
- (NSDictionary *)registerPOST;

@end
