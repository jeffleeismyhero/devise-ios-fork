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
    
    DVSWorkInProgress("Should add additional parameters for DVSActionRegistration");
    
    return [self userDeviseLikeJSONWithJSON:[json copy]];
}

- (NSDictionary *)loginJSONFromUser:(DVSUser *)user {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    
    if (user.password != nil) json[self.JSONKeyPathForPassword] = user.password;
    if (user.email != nil) json[self.JSONKeyPathForEmail] = user.email;
    
    DVSWorkInProgress("Should add additional parameters for DVSActionLogin");
    
    return [self userDeviseLikeJSONWithJSON:[json copy]];
}

- (NSDictionary *)remindPasswordJSONFromUser:(DVSUser *)user {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    
    if (user.email != nil) json[self.JSONKeyPathForEmail] = user.email;
    
    DVSWorkInProgress("Should add additional parameters for DVSActionRemindPassword");
    
    return [self userDeviseLikeJSONWithJSON:[json copy]];
}

- (NSDictionary *)changePasswordJSONFromUser:(DVSUser *)user {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    
    if (user.password != nil) json[self.JSONKeyPathForPassword] = user.password;
    if (user.password != nil) json[self.JSONKeyPathForPasswordConfirmation] = user.password;
    
    DVSWorkInProgress("Should add additional parameters for DVSActionChangePassword");
    
    return [self userDeviseLikeJSONWithJSON:json];
}

- (NSDictionary *)updateJSONFromUser:(DVSUser *)user {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    
    if (user.email != nil) json[self.JSONKeyPathForEmail] = user.email;
    
    DVSWorkInProgress("Should add additional parameters for DVSActionUpdate");
    
    return [self userDeviseLikeJSONWithJSON:json];
}

#pragma mark - Private Methods

- (NSDictionary *)userDeviseLikeJSONWithJSON:(NSDictionary *)json {
    return @{@"user" : json};
}

@end
