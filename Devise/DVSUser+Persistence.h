//
//  DVSUser+Persistence.h
//  
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSUser.h"

@interface DVSUser (DVSLocalPersistence) <NSSecureCoding>

/**
 *  A locally saved user object (if any).
 */
+ (instancetype)localUser;

/**
 *  Saves the locally saved user object.
 */
+ (void)setLocalUser:(DVSUser *)user;

/**
 *  Removes the locally saved user object.
 */
+ (void)removeLocalUser;

/**
 *  Returns stored locally email used in HTTP X-User-Email Header Field
 */
+ (NSString *)persistentXUserEmail;

@end

@protocol DVSUserPersisting <NSObject>

@optional
/**
 *  List of property which will be stored locally. Pass names as strings.
 */
- (NSArray *)propertiesToPersistByName;

@end
