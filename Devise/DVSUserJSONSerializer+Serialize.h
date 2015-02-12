//
//  DVSUserJSONSerializer+Serialize.h
//  Devise
//
//  Created by Wojciech Trzasko on 12.02.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSUserJSONSerializer.h"

@interface DVSUserJSONSerializer (Serialize)

- (NSDictionary *)registerJSONFromUser:(DVSUser *)user;
- (NSDictionary *)loginJSONFromUser:(DVSUser *)user;
- (NSDictionary *)remindPasswordJSONFromUser:(DVSUser *)user;
- (NSDictionary *)changePasswordJSONFromUser:(DVSUser *)user;
- (NSDictionary *)updateJSONFromUser:(DVSUser *)user;

@end
