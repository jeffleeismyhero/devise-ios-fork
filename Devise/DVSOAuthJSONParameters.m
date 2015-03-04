//
//  DVSOAuthJSONParameters.m
//  Devise
//
//  Created by Pawel Bialecki on 04.03.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSOAuthJSONParameters.h"

@implementation DVSOAuthJSONParameters

+ (NSDictionary *)dictionaryForParametersWithProvider:(DVSOAuthProvider)provider oAuthToken:(NSString *)oAuthToken userID:(NSString *)userID userEmail:(NSString *)email {
    
    NSAssert(oAuthToken != nil, @"Token can not be nil!");
    NSAssert(userID != nil, @"User ID can not be nil!");
    NSAssert(email != nil, @"Email can not be nil!");
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    switch (provider) {
        case DVSOAuthProviderFacebook:
            [parameters setObject:@"facebook" forKey:@"provider"];
            break;
        case DVSOAuthProviderGoogle:
            [parameters setObject:@"google" forKey:@"provider"];
            break;
        default:
            NSAssert(true, @"Proper provider is needed!");
            break;
    }
    
    [parameters setObject:oAuthToken forKey:@"oauth_token"];
    [parameters setObject:userID forKey:@"uid"];
    [parameters setObject:email forKey:@"email"];
    
    return @{@"user" : parameters};
}

@end
