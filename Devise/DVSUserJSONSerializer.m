//
//  DVSUserJSONSerializer.m
//  Devise
//
//  Created by Wojciech Trzasko on 12.02.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSUserJSONSerializer.h"

@interface DVSUserJSONSerializer ()

@property (strong, nonatomic, readwrite) DVSUser *user;

@end

@implementation DVSUserJSONSerializer

- (instancetype)initWithUser:(DVSUser *)user {
    if (self = [super init]) {
        self.user = user;
        
        // Defaults
        self.JSONKeyPathForEmail = @"email";
        self.JSONKeyPathForPassword = @"password";
        self.JSONKeyPathForPasswordConfirmation = @"passwordConfirmation";
    }
    return self;
}

#pragma mark - Public Methods

- (NSDictionary *)registerJSON {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    
    if (self.user.email != nil) json[self.JSONKeyPathForEmail] = self.user.email;
    if (self.user.password != nil) json[self.JSONKeyPathForPassword] = self.user.password;
    
    DVSWorkInProgress("Should add additional parameters for DVSActionRegistration");

    return [self userDeviseLikeJSONWithJSON:[json copy]];
}

- (NSDictionary *)loginJSON {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    
    if (self.user.password != nil) json[self.JSONKeyPathForPassword] = self.user.password;
    if (self.user.email != nil) json[self.JSONKeyPathForEmail] = self.user.email;
    
    DVSWorkInProgress("Should add additional parameters for DVSActionLogin");
    
    return [self userDeviseLikeJSONWithJSON:[json copy]];
}

- (NSDictionary *)remindPasswordJSON {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    
    if (self.user.email != nil) json[self.JSONKeyPathForEmail] = self.user.email;
    
    DVSWorkInProgress("Should add additional parameters for DVSActionRemindPassword");

    return [self userDeviseLikeJSONWithJSON:[json copy]];
}

- (NSDictionary *)changePasswordJSON {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    
    if (self.user.password != nil) json[self.JSONKeyPathForPassword] = self.user.password;
    if (self.user.password != nil) json[self.JSONKeyPathForPasswordConfirmation] = self.user.password;
    
    DVSWorkInProgress("Should add additional parameters for DVSActionChangePassword");
    
    return [self userDeviseLikeJSONWithJSON:json];
}

- (NSDictionary *)updateJSON {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    
    if (self.user.email != nil) json[self.JSONKeyPathForEmail] = self.user.email;
    
    DVSWorkInProgress("Should add additional parameters for DVSActionUpdate");
    
    return [self userDeviseLikeJSONWithJSON:json];
}

#pragma mark - Private Methods

- (NSDictionary *)userDeviseLikeJSONWithJSON:(NSDictionary *)json {
    return @{@"user" : json};
}

@end
