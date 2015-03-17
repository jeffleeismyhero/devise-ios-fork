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

- (void)makeRequestWithAccount:(ACAccount *)account completion:(DVSFacebookParametersBlock)completion;
- (void)checkResponse:(NSURLResponse *)response data:(NSData *)data oAuthToken:(NSString *)oAuthToken completion:(DVSFacebookParametersBlock)completion;
- (NSDictionary *)parametersFromUserData:(id)userData oAuthToken:(NSString *)oAuthToken;
- (BOOL)isResponseValid:(NSURLResponse *)response;

@end


@interface DVSFacebookAccountStore (DeviseStubs)

+ (instancetype)dvs_stubFacebookAccountStore;

@end


@interface SLRequest (DeviseStubs)

+ (instancetype)dvs_stubSLRequest;

@end
