//
//  DVSUser+Memorize.m
//  Devise
//
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSUser+Memorize.h"
#import "SSKeychain.h"

NSString * const dvs_token = @"co.netguru.lib.Devise.token";
NSString * const dvs_email = @"co.netguru.lib.Devise.email";
NSString * const dvs_account = @"co.netguru.lib.Devise.account";
NSString * const dvs_identifier = @"co.netguru.lib.Devise.identifier";

@implementation DVSUser (Memorize)

- (void)dvs_deleteSensitiveData {
    [self dvs_deleteEmail];
    [self dvs_deleteToken];
    [self dvs_deleteidentifier];
}

- (BOOL)dvs_saveSensitiveData:(NSDictionary *)dictionary {
    
    if (dictionary[@"user"]) {
        [self dvs_saveToken:dictionary[@"user"][@"authenticationToken"]];
        [self dvs_saveIdentifier:dictionary[@"user"][@"id"]];
        [self dvs_saveEmail:dictionary[@"user"][@"email"]];
        return YES;
    }
    return NO;
}

#pragma mark token

- (NSString *)dvs_token {
    return [SSKeychain passwordForService:dvs_token account:dvs_account];
}

- (void)dvs_saveToken:(NSString *)token {
    [SSKeychain setPassword:token forService:dvs_token account:dvs_account];
}

- (void)dvs_deleteToken {
    [SSKeychain deletePasswordForService:dvs_token account:dvs_account];
}

#pragma mark email

- (NSString *)dvs_email {
    return [SSKeychain passwordForService:dvs_email account:dvs_account];
}

- (void)dvs_saveEmail:(NSString *)email {
    [SSKeychain setPassword:email forService:dvs_email account:dvs_account];
}

- (void)dvs_deleteEmail {
    [SSKeychain deletePasswordForService:dvs_email account:dvs_account];
}

#pragma mark uid

- (NSString *)dvs_identifier {
    return [SSKeychain passwordForService:dvs_identifier account:dvs_account];
}

- (void)dvs_saveIdentifier:(NSString *)identifier {
    [SSKeychain setPassword:identifier forService:dvs_identifier account:dvs_account];
}

- (void)dvs_deleteidentifier {
    [SSKeychain deletePasswordForService:dvs_identifier account:dvs_account];
}

@end
