//
//  DVSTestUserManager.h
//  Devise
//
//  Created by Patryk Kaczmarek on 25/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

#import <Devise/Devise.h>
#import "DVSUserPersistenceStore.h"

@interface DVSTestUserManager : DVSUserManager

@property (strong, nonatomic) DVSUserPersistenceStore *persistentStore;

@end
