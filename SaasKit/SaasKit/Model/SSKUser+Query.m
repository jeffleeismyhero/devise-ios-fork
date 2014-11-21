//
//  SSKUser+Query.m
//  SaasKit
//
//  Created by Patryk Kaczmarek on 20.11.2014.
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import "SSKUser+Query.h"
#import "SaasKit.h"
#import "NSString+SSKAdditions.h"

@implementation SSKUser (Query)

#pragma mark - Login

- (NSString *)loginQuery {
    return [self queryFromDictionary:[self loginPOST]];
}

- (NSDictionary *)loginPOST {
    
    NSString *password = [self paramNameForSelector:@selector(nameForPasswordInUserLogin:) withDefaultName:@"password"];
    NSMutableDictionary *post = [@{password : self.password} mutableCopy];
    
    switch (self.loginMethod) {
        case SSKLoginUsingEmail: {
            NSString *email = [self paramNameForSelector:@selector(nameForEmailInUserLogin:) withDefaultName:@"email"];
            [post addEntriesFromDictionary:@{email : self.email}];
            break;
        }
        case SSKLoginUsingUsername: {
            NSString *username = [self paramNameForSelector:@selector(nameForUsernameInUserLogin:) withDefaultName:@"username"];
            [post addEntriesFromDictionary:@{username : self.username}];
            break;
        }
    }
    
    if ([self extraLoginParams]) {
        [post addEntriesFromDictionary:[self extraLoginParams]];
    }
    return [post copy];
}

#pragma mark - Remind Passwords

- (NSDictionary *)remindPasswordPOST {
    
    NSMutableDictionary *post = [NSMutableDictionary dictionary];
    NSString *email = [self paramNameForSelector:@selector(nameForEmailInUserRemindPassword:) withDefaultName:@"email"];
    [post addEntriesFromDictionary:@{email : self.email}];
    
    if ([self extraRemindPasswordParams]) {
        [post addEntriesFromDictionary:[self extraRegistrationParams]];
    }
    return [post copy];
}

- (NSString *)remindPasswordQuery {
    return [self queryFromDictionary:[self remindPasswordPOST]];
}

#pragma mark - Register

- (NSDictionary *)registerPOST {
    
    NSMutableDictionary *post = [NSMutableDictionary dictionary];
    
    NSString *email = [self paramNameForSelector:@selector(nameForEmailInUserRegistration:) withDefaultName:@"email"];
    [post addEntriesFromDictionary:@{email : self.email}];
    
    NSString *username = [self paramNameForSelector:@selector(nameForUsernameInUserLogin:) withDefaultName:@"username"];
    [post addEntriesFromDictionary:@{username : self.username}];
    
    NSString *password = [self paramNameForSelector:@selector(nameForPasswordInUserLogin:) withDefaultName:@"password"];
    [post addEntriesFromDictionary:@{password : self.password}];
    
    if ([self extraRegistrationParams]) {
        [post addEntriesFromDictionary:[self extraRegistrationParams]];
    }
    return post;
}

- (NSString *)registerQuery {
    return [self queryFromDictionary:[self registerPOST]];
}

#pragma mark - private methods

- (NSString *)queryFromDictionary:(NSDictionary *)dictionary {
    
    NSMutableString *query = [NSMutableString string];
    [dictionary.allKeys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx != 0) {
            [query appendString:@"&"];
        }
        id key = [self validatedValue:obj];
        id value = [self validatedValue:dictionary[obj]];
        [query appendFormat:@"%@=%@", key, value];
    }];
    return [query copy];
}

- (id)validatedValue:(id)value {
    
    BOOL isValidClass = ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]);
    NSAssert(isValidClass, @"Value is kind of %@ class which is not allowed when using GET request. Allowed classes: NSNumber or NSString", NSStringFromClass([value class]));
    
    if ([value isKindOfClass:[NSString class]]) {
        value = [(NSString *)value stringByEscapingDiacritics];
    }
    return value;
}

- (NSString *)paramNameForSelector:(SEL)selector withDefaultName:(NSString *)name {
    
    if (self.dataSource && [self.dataSource respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        name = [self.dataSource performSelector:selector withObject:self];
#pragma clang diagnostic pop
    }
    return name;
}

#pragma mark - Private Methods
- (SSKRequestType)requestTypeForSelector:(SEL)selector {
    
    SSKRequestType requestType = SSKRequestPOST;
    if (self.dataSource && [self.dataSource respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        requestType = (NSInteger)[self.dataSource performSelector:selector withObject:self];
#pragma clang diagnostic pop
    }
    return requestType;
}

@end
