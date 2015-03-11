//
//  DVSAccountStore.h
//  Devise
//
//  Created by Pawel Bialecki on 09.03.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

@import Accounts;

typedef void(^DVSAccountStoreBlock)(ACAccount *account, NSError *error);

@interface DVSAccountStore : ACAccountStore

- (instancetype)initWithACAccountTypeIdentifier:(NSString *)accountTypeIdentifier appIDkey:(NSString *)appIDkey permissions:(NSArray *)permissions;
- (void)requestAccessWithCompletion:(DVSAccountStoreBlock)completion;
- (void)refreshTokenForAccount:(ACAccount *)account completion:(DVSAccountStoreBlock)completion;

@end
