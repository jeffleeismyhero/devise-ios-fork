//
//  DVSUserJSONSerializer.h
//  Devise
//
//  Created by Wojciech Trzasko on 12.02.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DVSUser.h"

@protocol DVSUserJSONSerializerDataSource;

@interface DVSUserJSONSerializer : NSObject

@property (strong, nonatomic) NSString *JSONKeyPathForEmail;
@property (strong, nonatomic) NSString *JSONKeyPathForPassword;
@property (strong, nonatomic) NSString *JSONKeyPathForPasswordConfirmation;
@property (weak, nonatomic) id<DVSUserJSONSerializerDataSource> dataSource;

- (instancetype)init;

@end

@protocol DVSUserJSONSerializerDataSource <NSObject>

@optional
- (NSDictionary *)additionalRequestParametersForAction:(DVSActionType)action;;

@end
