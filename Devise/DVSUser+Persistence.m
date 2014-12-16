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
 
    NSArray *properties = [self dvs_properties];
    for (NSString *property in properties) {
        id value = [aDecoder decodeObjectForKey:property];
        [self setValue:value forKey:property];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    NSMutableArray *properties = [[self dvs_properties] mutableCopy];
    
    //do not store those properties:
    [properties removeObject:@"additionalRequestParameters"];
    [properties removeObject:@"dataSource"];
    [properties removeObject:@"httpClient"];
    
    for (NSString *property in properties) {
        [aCoder encodeObject:[self valueForKey:property] forKey:property];
    }
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end