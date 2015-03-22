//
//  DVSTestFacebookAuthenticator.h
//  Devise
//
//  Created by Radoslaw Szeja on 16/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

@import Accounts;
@import Social;

#import "DVSFacebookAuthenticator.h"
#import "DVSOAuthJSONParameters.h"
#import "DVSTestFacebookAccountStore.h"

@interface DVSTestFacebookAuthenticator : DVSFacebookAuthenticator

@end

// Reveal private interface
@interface DVSTestFacebookAuthenticator (DeviseTests)

- (void)makeRequestWithAccount:(ACAccount *)account success:(DVSDictionaryBlock)success failure:(DVSErrorBlock)failure;
- (void)checkResponse:(NSURLResponse *)response data:(NSData *)data token:(NSString *)token success:(DVSDictionaryBlock)success failure:(DVSErrorBlock)failure;
- (NSDictionary *)parametersFromUserData:(id)userData token:(NSString *)token;
- (BOOL)isResponseValid:(NSURLResponse *)response;

@end


@interface DVSFacebookAccountStore (DeviseStubs)

+ (instancetype)dvs_stubFacebookAccountStore;

@end


@interface SLRequest (DeviseStubs)

+ (instancetype)dvs_stubSLRequest;

@end
