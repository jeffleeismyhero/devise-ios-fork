//
//  SSKUser+Querying.m
//  
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "SSKUser+Querying.h"
#import "NSString+SassKit.h"

@implementation SSKUser (Querying)

#pragma mark Login

- (NSString *)loginQuery {
    return [self queryFromDictionary:[self loginPOST]];
}

- (NSDictionary *)loginPOST {
    NSMutableDictionary *post = [NSMutableDictionary dictionaryWithCapacity:2];
    
    NSString *password = [self paramNameForSelector:@selector(nameForPasswordInUserLogin:) withDefaultName:@"password"];
    if (self.password != nil) post[password] = self.password;
    
    NSString *email = [self paramNameForSelector:@selector(nameForEmailInUserLogin:) withDefaultName:@"email"];
    if (self.email != nil) post[email] = self.email;

    if ([self extraLoginParams]) {
        [post addEntriesFromDictionary:[self extraLoginParams]];
    }

    return [post copy];
}

#pragma mark Forgot Password

- (NSDictionary *)forgotPasswordPOST {

    NSMutableDictionary *post = [NSMutableDictionary dictionary];
    NSString *email = [self paramNameForSelector:@selector(nameForEmailInUserRemindPassword:) withDefaultName:@"email"];
    if (self.email != nil) post[email] = self.email;

    if ([self extraRemindPasswordParams]) {
        [post addEntriesFromDictionary:[self extraRegistrationParams]];
    }
    return [post copy];
}

- (NSString *)forgotPasswordQuery {
    return [self queryFromDictionary:[self forgotPasswordPOST]];
}

#pragma mark Register

- (NSDictionary *)registerPOST {

    NSMutableDictionary *post = [NSMutableDictionary dictionary];

    NSString *email = [self paramNameForSelector:@selector(nameForEmailInUserRegistration:) withDefaultName:@"email"];
    if (self.email != nil) post[email] = self.email;
    
    NSString *password = [self paramNameForSelector:@selector(nameForPasswordInUserLogin:) withDefaultName:@"password"];
    if (self.password != nil) post[password] = self.password;

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
        value = [(NSString *)value ssk_percentEscapedString];
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
