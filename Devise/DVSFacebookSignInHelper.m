//
//  DVSFacebookSignInDelegate.m
//  Devise
//
//  Created by Pawel Bialecki on 09.03.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

@import Accounts;
@import Social;
#import "DVSFacebookSignInHelper.h"
#import "DVSOAuthJSONParameters.h"
#import "DVSUserManager.h"
#import "DVSHTTPClient+User.h"
#import "DVSAccountStore.h"

@implementation DVSFacebookSignInHelper

- (void)signInUsingFacebookWithAppID:(NSString *)facebookAppID success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {

    DVSAccountStore *accountStore = [[DVSAccountStore alloc] initWithACAccountTypeIdentifier:ACAccountTypeIdentifierFacebook appIDkey:facebookAppID permissions:@[@"email"]];
    
    [accountStore requestAccessWithCompletion:^(BOOL granted, NSError *error) {
        if (granted) {
            NSArray *accounts = [accountStore accountsWithAccountType:[accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook]];
            NSAssert([accounts count] > 0, @"At least one Facebook account should exist!");
            
            ACAccount *facebookAccount = [accounts lastObject];
            [self makeRequestWithAccount:facebookAccount success:success failure:failure];
        } else if (failure != NULL) {
            failure(error);
        }
    }];
}

- (void)makeRequestWithAccount:(ACAccount *)account success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:@"https://graph.facebook.com/me"] parameters:nil];
    request.account = account;
    
    [request performRequestWithHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error && ((NSHTTPURLResponse *)response).statusCode == 200) {
            NSError *deserializationError;
            NSDictionary *userData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&deserializationError];
            
            [self authorizeFacebookUserWithAccount:account userData:userData deserializationError:deserializationError success:success failure:failure];
        } else if (failure != NULL) {
            failure(error);
        };
    }];
}

- (void)authorizeFacebookUserWithAccount:(ACAccount *)facebookAccount userData:(NSDictionary *)userData deserializationError:(NSError *)deserializationError success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    if (userData != nil && deserializationError == nil) {
        NSDictionary *parameters = [DVSOAuthJSONParameters dictionaryForParametersWithProvider:DVSOAuthProviderFacebook oAuthToken:facebookAccount.credential.oauthToken userID:userData[@"id"] userEmail:userData[@"email"]];
        
        [[DVSUserManager defaultManager].httpClient signInUsingFacebookUser:[DVSUserManager defaultManager].user parameters:parameters success:success failure:failure];
    }
}

@end
