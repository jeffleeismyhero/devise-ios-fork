//
//  DVSTestFacebookAccountStore.h
//  Devise
//
//  Created by Radoslaw Szeja on 16/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSFacebookAccountStore.h"

@interface DVSTestFacebookAccountStore : DVSFacebookAccountStore

@property (strong, nonatomic, readwrite) NSDictionary *options;

@end

@interface DVSFacebookAccountStore (DeviseTests)

- (void)renewCredentialsWithCompletion:(DVSAccountStoreBlock)completion;
- (ACAccount *)account;

@end
