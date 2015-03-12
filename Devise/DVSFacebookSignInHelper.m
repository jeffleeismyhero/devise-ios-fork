//
//  DVSFacebookSignInHelper.m
//  Devise
//
//  Created by Pawel Bialecki on 09.03.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

@import Accounts;
@import Social;
#import "DVSFacebookSignInHelper.h"
#import "DVSOAuthJSONParameters.h"
#import "DVSAccountStore.h"

@implementation DVSFacebookSignInHelper

- (void)signInUsingFacebookWithAppID:(NSString *)facebookAppID completion:(DVSFacebookParametersBlock)completion {
    DVSAccountStore *store = [[DVSAccountStore alloc] initWithACAccountTypeIdentifier:ACAccountTypeIdentifierFacebook appIDkey:facebookAppID permissions:@[@"email"]];
    [store requestAccessWithCompletion:^(ACAccount *account, NSError *error) {
        if (account) {
            [self makeRequestWithAccount:account completion:completion];
        } else if (completion != NULL) {
            completion(NO, nil, error);
        }
    }];
}

#pragma mark - Private methods

- (void)makeRequestWithAccount:(ACAccount *)account completion:(DVSFacebookParametersBlock)completion {
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                            requestMethod:SLRequestMethodGET
                                                      URL:[NSURL URLWithString:@"https://graph.facebook.com/me"]
                                               parameters:nil];
    request.account = account;
    
    [request performRequestWithHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            [self checkResponse:response data:data oAuthToken:account.credential.oauthToken completion:completion];
        } else if (completion != NULL) {
            completion(NO, nil, error);
        }
    }];
}

- (void)checkResponse:(NSURLResponse *)response data:(NSData *)data oAuthToken:(NSString *)oAuthToken completion:(DVSFacebookParametersBlock)completion {
    if ([self isResponseValid:response]) {
        NSError *deserializationError;
        id userData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&deserializationError];
        if (deserializationError) {
            if (completion != NULL) completion(NO, nil, deserializationError);
        } else {
            NSDictionary *parameters = [self parametersFromUserData:userData oAuthToken:oAuthToken];
            if (completion != NULL) completion(YES, parameters, nil);
        }
    } else if (completion != NULL) {
        completion(NO, nil, [NSError errorWithDomain:NSURLErrorDomain code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: @"Facebook response is not valid!"}]);
    }
}

#pragma mark - Helpers

- (NSDictionary *)parametersFromUserData:(id)userData oAuthToken:(NSString *)oAuthToken {
    return [DVSOAuthJSONParameters dictionaryForParametersWithProvider:DVSOAuthProviderFacebook
                                                            oAuthToken:oAuthToken
                                                                userID:userData[@"id"]
                                                             userEmail:userData[@"email"]];
}

- (BOOL)isResponseValid:(NSURLResponse *)response {
    return ((NSHTTPURLResponse *)response).statusCode == 200;
}

@end
