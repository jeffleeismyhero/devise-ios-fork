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
    
    NSString *email = [self paramNameForSelector:@selector(nameForEmailInUserRegistration:) withDefaultName:@"email"];
    if (self.email != nil) json[email] = self.email;
    
    NSString *password = [self paramNameForSelector:@selector(nameForPasswordInUserLogin:) withDefaultName:@"password"];
    if (self.password != nil) json[password] = self.password;
    
    if ([self extraRegistrationParams]) {
        [json addEntriesFromDictionary:[self extraRegistrationParams]];
    }
    return [self userDeviseLikeJSONWithJSON:[json copy]];
}

- (NSDictionary *)loginJSON {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    
    NSString *password = [self paramNameForSelector:@selector(nameForPasswordInUserLogin:) withDefaultName:@"password"];
    if (self.password != nil) json[password] = self.password;
    
    NSString *email = [self paramNameForSelector:@selector(nameForEmailInUserLogin:) withDefaultName:@"email"];
    if (self.email != nil) json[email] = self.email;

    if ([self extraLoginParams]) {
        [json addEntriesFromDictionary:[self extraLoginParams]];
    }

    return [self userDeviseLikeJSONWithJSON:[json copy]];
}

- (NSDictionary *)forgotPasswordJSON {
    
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    NSString *email = [self paramNameForSelector:@selector(nameForEmailInUserRemindPassword:) withDefaultName:@"email"];
    if (self.email != nil) json[email] = self.email;
    
    if ([self extraRemindPasswordParams]) {
        [json addEntriesFromDictionary:[self extraRegistrationParams]];
    }
    return [self userDeviseLikeJSONWithJSON:[json copy]];
}

- (NSDictionary *)changePasswordJSON {

    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    NSString *password = [self paramNameForSelector:@selector(nameForPasswordInRemindPassword:) withDefaultName:@"password"];
    if (self.password != nil) json[password] = self.password;
    
    NSString *passwordConfirmation = [self paramNameForSelector:@selector(nameForPasswordConfirmationInChangePassword:) withDefaultName:@"passwordConfirmation"];
    if (self.password != nil) json[passwordConfirmation] = self.password;

    if ([self extraChangePasswordParams]) {
        [json addEntriesFromDictionary:[self extraChangePasswordParams]];
    }
    return [self userDeviseLikeJSONWithJSON:json];
}

#pragma mark - Private Methods

- (NSDictionary *)userDeviseLikeJSONWithJSON:(NSDictionary *)json {
    return @{@"user" : json};
}

//- (NSString *)queryFromDictionary:(NSDictionary *)dictionary {
//
//    NSMutableString *query = [NSMutableString string];
//    [dictionary.allKeys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        if (idx != 0) {
//            [query appendString:@"&"];
//        }
//        id key = [self validatedValue:obj];
//        id value = [self validatedValue:dictionary[obj]];
//        [query appendFormat:@"%@=%@", key, value];
//    }];
//    return [query copy];
//}

//- (id)validatedValue:(id)value {
//    
//    BOOL isValidClass = [self isValidClassForValue:value includeDictionaryClass:YES];
//    NSAssert(isValidClass, @"Value is kind of %@ class which is not allowed when using GET request. Allowed classes: NSNumber, NSString or NSDictionary for nested queries", NSStringFromClass([value class]));
//
//    if ([value isKindOfClass:[NSString class]]) {
//        value = [(NSString *)value dvs_percentEscapedString];
//        
//    } else if ([value isKindOfClass:[NSDictionary class]]) {
//        user[password]=alcatraz2&user[passwordConfirmation]=alcatraz2
//    }
//    return value;
//}

//- (BOOL)isValidClassForValue:(id)value includeDictionaryClass:(BOOL)include {
//    if ([value isKindOfClass:[NSString class]]) {
//        return YES;
//    } else if ([value isKindOfClass:[NSNumber class]]) {
//        return YES;
//    } else if (include && [value isKindOfClass:[NSDictionary class]]) {
//        return YES;
//    }
//    return NO;
//}

- (NSString *)paramNameForSelector:(SEL)selector withDefaultName:(NSString *)name {

    if (self.dataSource && [self.dataSource respondsToSelector:selector]) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        name = [self.dataSource performSelector:selector withObject:self];
        #pragma clang diagnostic pop
    }
    return name;
}

@end
