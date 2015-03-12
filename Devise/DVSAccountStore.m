//
//  DVSAccountStore.m
//  Devise
//
//  Created by Pawel Bialecki on 09.03.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSAccountStore.h"

@interface DVSAccountStore ()

@property (copy, nonatomic) NSString *accountTypeIdentifier;
@property (copy, nonatomic) NSString *appIDKey;
@property (strong, nonatomic) NSArray *permissions;

@end

@implementation DVSAccountStore

- (instancetype)initWithACAccountTypeIdentifier:(NSString *)accountTypeIdentifier appIDkey:(NSString *)appIDkey permissions:(NSArray *)permissions {
    if (self = [super init]) {
        self.accountTypeIdentifier = accountTypeIdentifier;
        self.appIDKey = appIDkey;
        self.permissions = permissions;
    }
    
    return self;
}

- (void)requestAccessWithCompletion:(DVSAccountStoreBlock)completion {

    NSAssert(self.accountTypeIdentifier != nil, @"accountTypeIdentifier can not be nil!");
    NSAssert(self.appIDKey != nil, @"appIDKey can not be nil!");
    NSAssert(self.permissions != nil, @"permissions can not be nil!");
    
    NSDictionary *options = @{
        ACFacebookAppIdKey : self.appIDKey,
        ACFacebookPermissionsKey : self.permissions,
        ACFacebookAudienceKey : ACFacebookAudienceOnlyMe
    };
    
    [self requestAccessToAccountsWithType:[self accountTypeWithAccountTypeIdentifier:self.accountTypeIdentifier] options:options completion:^(BOOL granted, NSError *error) {
        if (granted) {
            [self refreshTokenForAccount:[self facebookAccount] completion:^(ACAccount *account, NSError *error) {
                if (completion != NULL) completion(account, error);
            }];
        } else if (completion != NULL) completion(nil, error);
    }];
}

- (void)refreshTokenForAccount:(ACAccount *)account completion:(DVSAccountStoreBlock)completion {
    [self renewCredentialsForAccount:account completion:^(ACAccountCredentialRenewResult renewResult, NSError *error) {
        if (renewResult == ACAccountCredentialRenewResultRenewed) {
            if (completion != NULL) completion([self facebookAccount], error);
        } else if (completion != NULL) {
            completion(nil, error);
        }
    }];
}

- (ACAccount *)facebookAccount {
    NSArray *accounts = [self accountsWithAccountType:[self accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook]];
    NSAssert([accounts count] > 0, @"At least one Facebook account should exist!");
    return [accounts lastObject];
}

@end
