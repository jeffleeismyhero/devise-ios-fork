//
//  DVSUser+Memorize.h
//  Devise
//
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <Devise/Devise.h>

@interface DVSUser (Memorize)

- (NSString *)dvs_token;
- (NSString *)dvs_identifier;
- (NSString *)dvs_email;

- (void)dvs_deleteToken;
- (void)dvs_deleteEmail;
- (void)dvs_deleteidentifier;

- (void)dvs_deleteSensitiveData;
- (BOOL)dvs_saveSensitiveData:(NSDictionary *)dictionary;

@end
