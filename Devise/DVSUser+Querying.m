//
//  DVSUser+Querying.m
//  
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSUser+Querying.h"
#import "NSString+Devise.h"

@implementation DVSUser (Querying)

#pragma mark - Public Methods

- (NSDictionary *)registerJSON {
    
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    
    NSString *email = [self paramNameForSelector:@selector(JSONKeyPathForEmail) withDefaultName:@"email"];
    if (self.email != nil) json[email] = self.email;
    
    NSString *password = [self paramNameForSelector:@selector(JSONKeyPathForPassword) withDefaultName:@"password"];
    if (self.password != nil) json[password] = self.password;
    
    [json addEntriesFromDictionary:[self additionalParametersForAction:DVSActionRegistration]];
    return [self userDeviseLikeJSONWithJSON:[json copy]];
}

- (NSDictionary *)loginJSON {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    
    NSString *password = [self paramNameForSelector:@selector(JSONKeyPathForPassword) withDefaultName:@"password"];
    if (self.password != nil) json[password] = self.password;
    
    NSString *email = [self paramNameForSelector:@selector(JSONKeyPathForEmail) withDefaultName:@"email"];
    if (self.email != nil) json[email] = self.email;

    [json addEntriesFromDictionary:[self additionalParametersForAction:DVSActionLogin]];
    return [self userDeviseLikeJSONWithJSON:[json copy]];
}

- (NSDictionary *)forgotPasswordJSON {
    
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    NSString *email = [self paramNameForSelector:@selector(JSONKeyPathForEmail) withDefaultName:@"email"];
    if (self.email != nil) json[email] = self.email;
    
    [json addEntriesFromDictionary:[self additionalParametersForAction:DVSActionRemindPassword]];
    return [self userDeviseLikeJSONWithJSON:[json copy]];
}

- (NSDictionary *)changePasswordJSON {

    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    NSString *password = [self paramNameForSelector:@selector(JSONKeyPathForPassword) withDefaultName:@"password"];
    if (self.password != nil) json[password] = self.password;
    
    NSString *passwordConfirmation = [self paramNameForSelector:@selector(JSONKeyPathForPasswordConfirmation) withDefaultName:@"passwordConfirmation"];
    if (self.password != nil) json[passwordConfirmation] = self.password;

    [json addEntriesFromDictionary:[self additionalParametersForAction:DVSActionChangePassword]];
    return [self userDeviseLikeJSONWithJSON:json];
}

- (NSDictionary *)updateJSON {
    
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    NSString *email = [self paramNameForSelector:@selector(JSONKeyPathForEmail) withDefaultName:@"email"];
    if (self.email != nil) json[email] = self.email;

    [json addEntriesFromDictionary:[self additionalParametersForAction:DVSActionUpdate]];
    return [self userDeviseLikeJSONWithJSON:json];
}

#pragma mark - Private Methods

- (NSDictionary *)userDeviseLikeJSONWithJSON:(NSDictionary *)json {
    return @{@"user" : json};
}

- (NSString *)paramNameForSelector:(SEL)selector withDefaultName:(NSString *)name {

    if (self.dataSource && [self.dataSource respondsToSelector:selector]) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        name = [self.dataSource performSelector:selector];
        #pragma clang diagnostic pop
    }
    return name;
}

- (NSDictionary *)additionalParametersForAction:(DVSActionType)action {
    
    NSMutableDictionary *dictionary = [[self objectsForAction:action] mutableCopy];
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(additionalRequestParametersForAction:)]) {
        [dictionary addEntriesFromDictionary:[self.dataSource additionalRequestParametersForAction:action]];
    }
    return [dictionary copy];
}

@end
