//
//  SSKUser+Query.h
//  SaasKit
//
//  Created by Patryk Kaczmarek on 20.11.2014.
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import "SSKUser.h"

@interface SSKUser (Query)

- (NSString *)loginQuery;
- (NSDictionary *)loginPOST;

- (NSDictionary *)remindPasswordPOST;

- (NSDictionary *)registerPOST;

@end
