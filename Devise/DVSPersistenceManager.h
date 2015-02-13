//
//  DVSPersistenceManager.h
//  Devise
//
//  Created by Wojciech Trzasko on 13.02.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DVSUser.h"

@interface DVSPersistenceManager : NSObject

/**
 *  A locally saved user object (if any).
 */
@property (strong, nonatomic) DVSUser *localUser;

+ (instancetype)sharedPersistence;

@end
