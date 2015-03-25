//
//  DVSUserPersistenceManager.h
//  Devise
//
//  Created by Wojciech Trzasko on 13.02.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DVSUser.h"

@class DVSConfiguration;

@interface DVSUserPersistenceManager : NSObject

/**
 *  A locally saved user object (if any).
 *  Notice that localUser will be taken only once from keychain store until will be nilled.
 */
@property (strong, nonatomic) DVSUser *localUser;

/**
 *  Default Initializer for DVSUserPersistenceManager class.
 *
 *  @param configuration The configuration used to initialize DVSUserPersistenceManager.
 */
- (instancetype)initWithConfiguration:(DVSConfiguration *)configuration NS_DESIGNATED_INITIALIZER;

/**
 *  Returns fresh copy of user model (or nil if any) taken from keychain store.
 *  Notice that persistentUser can be different from localUser.
 */
- (DVSUser *)persistentUser;

@end
