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

@interface DVSFacebookSignInHelper ()

@property (copy, nonatomic) NSString *faceookOAuthToken;

@end

@implementation DVSFacebookSignInHelper

- (void)obtainLoginParametersWithAppID:(NSString *)appID completion:(DVSFacebookParametersBlock)completion {
    [self signInUsingFacebookWithAppID:appID completion:completion];
}

- (void)signInUsingFacebookWithAppID:(NSString *)facebookAppID completion:(DVSFacebookParametersBlock)completion {

    DVSAccountStore *accountStore = [[DVSAccountStore alloc] initWithACAccountTypeIdentifier:ACAccountTypeIdentifierFacebook appIDkey:facebookAppID permissions:@[@"email"]];
    
    [accountStore requestAccessWithCompletion:^(BOOL granted, NSError *error) {
        if (granted) {
            NSArray *accounts = [accountStore accountsWithAccountType:[accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook]];
            NSAssert([accounts count] > 0, @"At least one Facebook account should exist!");
            
            ACAccount *facebookAccount = [accounts lastObject];
            self.faceookOAuthToken = facebookAccount.credential.oauthToken;
            [self makeRequestWithAccount:facebookAccount completion:completion];
        } else if (completion != NULL) {
            completion(NO, nil, error);
        }
    }];
}

- (void)makeRequestWithAccount:(ACAccount *)account completion:(DVSFacebookParametersBlock)completion {
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:@"https://graph.facebook.com/me"] parameters:nil];
    request.account = account;
    
    [request performRequestWithHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            [self checkResponse:response data:data completion:completion];
        } else if (completion != NULL) {
            completion(NO, nil, error);
        }
    }];
}

- (void)checkResponse:(NSURLResponse *)response data:(NSData *)data completion:(DVSFacebookParametersBlock)completion {
    if ([self isResponseValid:response]) {
        NSError *deserializationError;
        id userData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&deserializationError];
        if (deserializationError) {
            if (completion != NULL) completion(NO, nil, deserializationError);
        } else {
            [self createParametersFromUserData:userData completion:completion];
        }
    } else if (completion != NULL) {
        completion(NO, nil, [NSError errorWithDomain:NSURLErrorDomain code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: @"Facebook response is not valid!"}]);
    }
}

- (void)createParametersFromUserData:(id)userData completion:(DVSFacebookParametersBlock)completion {
    NSAssert(userData != nil, @"userData can not be nil!");
    NSDictionary *parameters = [DVSOAuthJSONParameters dictionaryForParametersWithProvider:DVSOAuthProviderFacebook oAuthToken:self.faceookOAuthToken userID:userData[@"id"] userEmail:userData[@"email"]];
    if (completion != NULL) completion(YES, parameters, nil);
}

- (BOOL)isResponseValid:(NSURLResponse *)response {
    return ((NSHTTPURLResponse *)response).statusCode == 200;
}

@end
