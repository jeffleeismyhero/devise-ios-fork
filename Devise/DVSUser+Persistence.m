//
//  DVSUser+Persistence.m
//
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <UICKeyChainStore/UICKeyChainStore.h>

#import "DVSConfiguration.h"
#import "DVSUser+Persistence.h"

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
    NSString *keychainService = [DVSConfiguration sharedConfiguration].keychainServiceName;
    NSString *keychainKey = NSStringFromClass(self);
    NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:user];
    [UICKeyChainStore setData:archivedData forKey:keychainKey service:keychainService];
    _dvs_localUser = user;
}

+ (void)removeLocalUser {
    NSString *keychainService = [DVSConfiguration sharedConfiguration].keychainServiceName;
    NSString *keychainKey = NSStringFromClass(self);
    [UICKeyChainStore removeItemForKey:keychainKey service:keychainService];
    _dvs_localUser = nil;
}

+ (NSString *)persistentXUserEmail {
    return [[self persistentUser].email copy];
}

+ (DVSUser *)persistentUser {
    NSString *keychainService = [DVSConfiguration sharedConfiguration].keychainServiceName;
    NSString *keychainKey = NSStringFromClass(self);
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
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.identifier forKey:@"identifier"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.sessionToken forKey:@"token"];
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end