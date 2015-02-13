//
//  DVSPersistenceManager.m
//  Devise
//
//  Created by Wojciech Trzasko on 13.02.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSPersistenceManager.h"
#import <UICKeyChainStore/UICKeyChainStore.h>
#import "DVSConfiguration.h"
#import "DVSUser+Persistence.h"

@implementation DVSPersistenceManager

@synthesize localUser = _localUser;

#pragma mark - Shared instance

+ (instancetype)sharedPersistence {
    static DVSPersistenceManager *sharedPersistence;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        sharedPersistence = [DVSPersistenceManager new];
    });
    
    return sharedPersistence;
}

#pragma mark - Accessors

- (DVSUser *)localUser {
    return _localUser ? : (_localUser = [self persistentUser]);
}

- (void)setLocalUser:(DVSUser *)user {
    [self removePersistentUser];
    _localUser = user;
    if (_localUser) [self savePersistentUser:_localUser];
}

#pragma mark - Persistent helpers

- (void)savePersistentUser:(DVSUser *)user {
    NSString *keychainService = [DVSConfiguration sharedConfiguration].keychainServiceName;
    NSString *keychainKey = [DVSConfiguration sharedConfiguration].resourceName;
    NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:user];
    [UICKeyChainStore setData:archivedData forKey:keychainKey service:keychainService];
}

- (void)removePersistentUser {
    NSString *keychainService = [DVSConfiguration sharedConfiguration].keychainServiceName;
    NSString *keychainKey = [DVSConfiguration sharedConfiguration].resourceName;
    [UICKeyChainStore removeItemForKey:keychainKey service:keychainService];
}

- (DVSUser *)persistentUser {
    NSString *keychainService = [DVSConfiguration sharedConfiguration].keychainServiceName;
    NSString *keychainKey = [DVSConfiguration sharedConfiguration].resourceName;
    NSData *archivedData = [UICKeyChainStore dataForKey:keychainKey service:keychainService];
    return [NSKeyedUnarchiver unarchiveObjectWithData:archivedData];
}


@end
