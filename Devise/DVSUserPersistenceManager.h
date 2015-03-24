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
 */
@property (strong, nonatomic) DVSUser *localUser;

/**
 *  Creates (if neccessary) and returns persistent manager with default (shared) configuration.
 */
+ (instancetype)sharedPersistenceManager;

/**
 *  Default Initializer for DVSUserPersistenceManager class.
 *
 *  @param configuration The configuration used to initialize DVSUserPersistenceManager.
 */
- (instancetype)initWithConfiguration:(DVSConfiguration *)configuration NS_DESIGNATED_INITIALIZER;

/**
 *  Returns locally stored email used in HTTP X-User-Email Header Field.
 */
- (NSString *)persistedUserEmail;

@end
