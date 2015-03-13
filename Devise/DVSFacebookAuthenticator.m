//
//  DVSFacebookAuthenticator.m
//  Devise
//
//  Created by Pawel Bialecki on 09.03.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

@import Accounts;
@import Social;
#import "DVSFacebookAuthenticator.h"
#import "DVSOAuthJSONParameters.h"
#import "DVSFacebookAccountStore.h"

@implementation DVSFacebookAuthenticator

- (void)signInUsingFacebookWithAppID:(NSString *)facebookAppID completion:(DVSFacebookParametersBlock)completion {
    
    if (completion == NULL) return;
    
    DVSFacebookAccountStore *store = [[DVSFacebookAccountStore alloc] initWithAppIDkey:facebookAppID permissions:@[@"email"]];
    [store requestAccessWithCompletion:^(ACAccount *account, NSError *error) {
        if (account) {
            [self makeRequestWithAccount:account completion:completion];
        } else {
            completion(nil, error);
        }
    }];
}

#pragma mark - Private methods

- (void)makeRequestWithAccount:(ACAccount *)account completion:(DVSFacebookParametersBlock)completion {
    
    if (completion == NULL) return;
    
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                            requestMethod:SLRequestMethodGET
                                                      URL:[NSURL URLWithString:@"https://graph.facebook.com/me"]
                                               parameters:nil];
    request.account = account;
    
    [request performRequestWithHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            completion(nil, error);
        } else {
            [self checkResponse:response data:data oAuthToken:account.credential.oauthToken completion:completion];
        }
    }];
}

- (void)checkResponse:(NSURLResponse *)response data:(NSData *)data oAuthToken:(NSString *)oAuthToken completion:(DVSFacebookParametersBlock)completion {
    
    if (completion == NULL) return;
    
    if ([self isResponseValid:response]) {
        NSError *deserializationError;
        id userData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&deserializationError];
        
        if (deserializationError) {
            completion(nil, deserializationError);
        } else {
            NSDictionary *parameters = [self parametersFromUserData:userData oAuthToken:oAuthToken];
            completion(parameters, nil);
        }
    } else {
        completion(nil, [NSError errorWithDomain:NSURLErrorDomain code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: @"Facebook response is not valid!"}]);
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
