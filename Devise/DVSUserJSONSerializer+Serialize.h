//
//  DVSUserJSONSerializer+Serialize.h
//  Devise
//
//  Created by Wojciech Trzasko on 12.02.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSUserJSONSerializer.h"

@interface DVSUserJSONSerializer (Serialize)

- (NSDictionary *)registerJSONDictionaryForUser:(DVSUser *)user;
- (NSDictionary *)loginJSONDictionaryForUser:(DVSUser *)user;
- (NSDictionary *)remindPasswordJSONDictionaryForUser:(DVSUser *)user;
- (NSDictionary *)changePasswordJSONDictionaryForUser:(DVSUser *)user;
- (NSDictionary *)updateJSONDictionaryForUser:(DVSUser *)user;

@end
