//
//  DVSUser+Persistence.m
//
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <UICKeyChainStore/UICKeyChainStore.h>

#import "DVSConfiguration.h"
#import "DVSUser+Persistence.h"
#import "NSObject+Devise.h"

@interface DVSUser ()

@property (strong, nonatomic, readwrite) NSString *identifier;
@property (strong, nonatomic, readwrite) NSString *sessionToken;

@end

@implementation DVSUser (DVSLocalPersistence)

#pragma mark - Local persistence management

static DVSUser *_dvs_localUser = nil;

+ (instancetype)localUser {
    if (_dvs_localUser != nil) return _dvs_localUser;
    return (_dvs_localUser = [self persistentUser]);
}

+ (void)setLocalUser:(DVSUser *)user {
    [self removeLocalUser];
    NSString *keychainService = [[self class] configuration].keychainServiceName;
    NSString *keychainKey = [[self class] configuration].resourceName;
    NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:user];
    [UICKeyChainStore setData:archivedData forKey:keychainKey service:keychainService];
    _dvs_localUser = user;
}

+ (void)removeLocalUser {
    NSString *keychainService = [[self class] configuration].keychainServiceName;
    NSString *keychainKey = [[self class] configuration].resourceName;
    [UICKeyChainStore removeItemForKey:keychainKey service:keychainService];
    _dvs_localUser = nil;
}

+ (NSString *)persistentXUserEmail {
    return [[self persistentUser].email copy];
}

+ (DVSUser *)persistentUser {
    NSString *keychainService = [[self class] configuration].keychainServiceName;
    NSString *keychainKey = [[self class] configuration].resourceName;
    NSData *archivedData = [UICKeyChainStore dataForKey:keychainKey service:keychainService];
    return [NSKeyedUnarchiver unarchiveObjectWithData:archivedData];
}

#pragma mark - Object serialization

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self == nil) return nil;
    
    self.identifier = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"identifier"];
    self.email = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"email"];
    self.sessionToken = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"sessionToken"];
    
    [[self subclassPropertyNamesToPersist] enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        Class aClass = [self dvs_classOfPropertyNamed:key];
        id value = [aDecoder decodeObjectOfClass:aClass forKey:key];
        [self setValue:value forKey:key];
    }];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.identifier forKey:@"identifier"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.sessionToken forKey:@"sessionToken"];
    
    [[self subclassPropertyNamesToPersist] enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        id object = [self valueForKey:key];
        [aCoder encodeObject:object forKey:key];
    }];
}

- (NSArray *)subclassPropertyNamesToPersist {
    
    SEL selector = @selector(propertiesToPersistByName);
    if ([self respondsToSelector:selector]) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        NSArray *array = [self performSelector:selector];
        #pragma clang diagnostic pop
        for (id object in array) {
            if (![object isKindOfClass:[NSString class]]) {
                [[DVSConfiguration sharedConfiguration] logMessage:@"Properties to persist should be passed by name as NSString. Aborted."];
                return nil;
            }
        }
        return array;
    }
    return nil;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end