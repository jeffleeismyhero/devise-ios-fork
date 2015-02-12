//
//  DVSUserJSONSerializer.h
//  Devise
//
//  Created by Wojciech Trzasko on 12.02.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DVSUser.h"

@interface DVSUserJSONSerializer : NSObject

@property (strong, nonatomic) NSString *JSONKeyPathForEmail;
@property (strong, nonatomic) NSString *JSONKeyPathForPassword;
@property (strong, nonatomic) NSString *JSONKeyPathForPasswordConfirmation;

- (instancetype)init;

- (NSDictionary *)registerJSONFromUser:(DVSUser *)user;
- (NSDictionary *)loginJSONFromUser:(DVSUser *)user;
- (NSDictionary *)remindPasswordJSONFromUser:(DVSUser *)user;
- (NSDictionary *)changePasswordJSONFromUser:(DVSUser *)user;
- (NSDictionary *)updateJSONFromUser:(DVSUser *)user;

@end
