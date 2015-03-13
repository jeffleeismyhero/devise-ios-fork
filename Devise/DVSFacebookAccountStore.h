//
//  DVSAccountStore.h
//  Devise
//
//  Created by Pawel Bialecki on 09.03.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

@import Accounts;

typedef void(^DVSAccountStoreBlock)(ACAccount *account, NSError *error);

@interface DVSFacebookAccountStore : ACAccountStore

- (instancetype)initWithAppIDkey:(NSString *)appIDKey permissions:(NSArray *)permissions;

/**
 * Request access to facebook account configured on the device
 */
- (void)requestAccessWithCompletion:(DVSAccountStoreBlock)completion;

@end
