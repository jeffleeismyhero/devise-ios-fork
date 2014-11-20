//
//  SSKUser+Query.m
//  SaasKit
//
//  Created by Patryk Kaczmarek on 20.11.2014.
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import "SSKUser+Query.h"

@implementation SSKUser (Query)

- (NSString *)loginQuery {
    
    NSMutableString *query = [[NSString stringWithFormat:@"password=%@", self.password] mutableCopy];
    switch (self.loginMethod) {
        case SSKLoginUsingEmail:
            [query appendFormat:@"&email=%@", self.email];
            break;
        case SSKLoginUsingUsername:
            [query appendFormat:@"&username=%@", self.username];
            break;
    }
    
    if ([self extraLoginParams]) {
        [query appendString:[self queryFromDictionary:[self extraLoginParams]]];
    }
    NSLog(@"\n\n%@\n\n", query);
    
    return query;
}

- (NSDictionary *)loginPOST {
    
    NSMutableDictionary *post = [@{@"password" : self.password} mutableCopy];
    
    switch (self.loginMethod) {
        case SSKLoginUsingEmail:
            [post addEntriesFromDictionary:@{@"email" : self.email}];
            break;
        case SSKLoginUsingUsername:
            [post addEntriesFromDictionary:@{@"username" : self.username}];
            break;
    }
    
    if ([self extraLoginParams]) {
        [post addEntriesFromDictionary:[self extraLoginParams]];
    }

    return post;
}

- (NSDictionary *)remindPasswordPOST {
    SSKBackendIssue("param 'callback' below isn't specified");
    return @{@"email" : self.email,
             @"callback" : @""};
}

- (NSDictionary *)registerPOST {
    return @{@"username" : self.username,
             @"password" : self.password,
             @"phone" : self.phone};
}

#pragma mark - private methods

- (NSString *)queryFromDictionary:(NSDictionary *)dictionary {
    
    NSMutableString *query = [NSMutableString string];
    for (NSString *key in dictionary.allKeys) {
        [query appendFormat:@"&%@=%@", key, dictionary[key]];
    }
    return [query copy];
}

@end
