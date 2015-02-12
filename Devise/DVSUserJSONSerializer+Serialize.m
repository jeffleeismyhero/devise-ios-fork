//
//  DVSUserJSONSerializer+FrameworkPrivate.m
//  Devise
//
//  Created by Wojciech Trzasko on 12.02.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSUserJSONSerializer+Serialize.h"

@implementation DVSUserJSONSerializer (Serialize)

#pragma mark - Public Methods

- (NSDictionary *)registerJSONFromUser:(DVSUser *)user {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    
    if (user.email != nil) json[self.JSONKeyPathForEmail] = user.email;
    if (user.password != nil) json[self.JSONKeyPathForPassword] = user.password;
    [json addEntriesFromDictionary:[self additionalParametersForAction:DVSActionRegistration]];
    
    return [self userDeviseLikeJSONWithJSON:[json copy]];
}

- (NSDictionary *)loginJSONFromUser:(DVSUser *)user {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    
    if (user.password != nil) json[self.JSONKeyPathForPassword] = user.password;
    if (user.email != nil) json[self.JSONKeyPathForEmail] = user.email;
    [json addEntriesFromDictionary:[self additionalParametersForAction:DVSActionLogin]];
    
    return [self userDeviseLikeJSONWithJSON:[json copy]];
}

- (NSDictionary *)remindPasswordJSONFromUser:(DVSUser *)user {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    
    if (user.email != nil) json[self.JSONKeyPathForEmail] = user.email;
    [json addEntriesFromDictionary:[self additionalParametersForAction:DVSActionRemindPassword]];
    
    return [self userDeviseLikeJSONWithJSON:[json copy]];
}

- (NSDictionary *)changePasswordJSONFromUser:(DVSUser *)user {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    
    if (user.password != nil) json[self.JSONKeyPathForPassword] = user.password;
    if (user.password != nil) json[self.JSONKeyPathForPasswordConfirmation] = user.password;
    [json addEntriesFromDictionary:[self additionalParametersForAction:DVSActionChangePassword]];
    
    return [self userDeviseLikeJSONWithJSON:json];
}

- (NSDictionary *)updateJSONFromUser:(DVSUser *)user {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    
    if (user.email != nil) json[self.JSONKeyPathForEmail] = user.email;
    [json addEntriesFromDictionary:[self additionalParametersForAction:DVSActionUpdate]];
    
    return [self userDeviseLikeJSONWithJSON:json];
}

#pragma mark - Private Methods

- (NSDictionary *)additionalParametersForAction:(DVSActionType)action {
    
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(additionalRequestParametersForAction:)]) {
        [dictionary addEntriesFromDictionary:[self.dataSource additionalRequestParametersForAction:action]];
    }
    return [dictionary copy];
}

- (NSDictionary *)userDeviseLikeJSONWithJSON:(NSDictionary *)json {
    return @{@"user" : json};
}

@end
