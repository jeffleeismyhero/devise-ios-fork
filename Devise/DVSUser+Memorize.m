//
//  DVSUser+Memorize.m
//  Devise
//
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSUser+Memorize.h"
#import "SSKeychain.h"
#import "NSDictionary+Devise.h"

NSString * const DVSServiceToken = @"co.netguru.lib.Devise.token";
NSString * const DVSServiceEmail = @"co.netguru.lib.Devise.email";
NSString * const DVSAccount = @"co.netguru.lib.Devise.account";
NSString * const DVSServiceIdentifier = @"co.netguru.lib.Devise.identifier";

@implementation DVSUser (Memorize)

- (void)dvs_deleteSensitiveData {
    [self dvs_deleteEmail];
    [self dvs_deleteToken];
    [self dvs_deleteIdentifier];
}

- (BOOL)dvs_saveSensitiveData:(NSDictionary *)dictionary {
    
    NSDictionary *user = dictionary[@"user"];
    if (user) {
        [self dvs_saveToken:[user dvs_stringValueForKey:@"authenticationToken"]];
        [self dvs_saveIdentifier:[user dvs_stringValueForKey:@"id"]];
        [self dvs_saveEmail:[user dvs_stringValueForKey:@"email"]];
        return YES;
    }
    return NO;
}

#pragma mark token

- (NSString *)dvs_token {
    return [SSKeychain passwordForService:DVSServiceToken account:DVSAccount];
}

- (void)dvs_saveToken:(NSString *)token {
    [SSKeychain setPassword:token forService:DVSServiceToken account:DVSAccount];
}

- (void)dvs_deleteToken {
    [SSKeychain deletePasswordForService:DVSServiceToken account:DVSAccount];
}

#pragma mark email

- (NSString *)dvs_email {
    return [SSKeychain passwordForService:DVSServiceEmail account:DVSAccount];
}

- (void)dvs_saveEmail:(NSString *)email {
    [SSKeychain setPassword:email forService:DVSServiceEmail account:DVSAccount];
}

- (void)dvs_deleteEmail {
    [SSKeychain deletePasswordForService:DVSServiceEmail account:DVSAccount];
}

#pragma mark uid

- (NSString *)dvs_identifier {
    return [SSKeychain passwordForService:DVSServiceIdentifier account:DVSAccount];
}

- (void)dvs_saveIdentifier:(NSString *)identifier {;
    [SSKeychain setPassword:identifier forService:DVSServiceIdentifier account:DVSAccount];
}

- (void)dvs_deleteIdentifier {
    [SSKeychain deletePasswordForService:DVSServiceIdentifier account:DVSAccount];
}

@end
