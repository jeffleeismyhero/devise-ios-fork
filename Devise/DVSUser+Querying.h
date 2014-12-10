//
//  DVSUser+Querying.h
//  
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DVSUser.h"

@interface DVSUser (Querying)

- (NSDictionary *)registerJSON;
- (NSDictionary *)loginJSON;
- (NSDictionary *)forgotPasswordJSON;
- (NSDictionary *)changePasswordJSON;
- (NSDictionary *)updateJSON;

@end
