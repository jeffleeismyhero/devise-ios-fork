//
//  DVSGooglePlusAuthenticator.m
//  Devise
//
//  Created by Pawel Bialecki on 09.03.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSGooglePlusAuthenticator.h"
#import "DVSOAuthJSONParameters.h"

#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>

@interface DVSGooglePlusAuthenticator () <GPPSignInDelegate>

@property (copy, nonatomic) DVSGoogleParametersBlock completion;

@end

@implementation DVSGooglePlusAuthenticator

- (instancetype)initWithClientID:(NSString *)clientID {
    self = [super init];
    if (self) {
        GPPSignIn *signIn = [GPPSignIn sharedInstance];
        signIn.clientID = clientID;
        signIn.scopes = @[ kGTLAuthScopePlusLogin, kGTLAuthScopePlusUserinfoProfile, kGTLAuthScopePlusUserinfoEmail, kGTLAuthScopePlusMe ];
        signIn.attemptSSO = YES;
        signIn.shouldFetchGoogleUserID = YES;
        signIn.shouldFetchGooglePlusUser = YES;
        signIn.shouldFetchGoogleUserEmail = YES;
    }
    return self;
}

- (void)dealloc {
    [GPPSignIn sharedInstance].delegate = nil;
}

#pragma mark - Public methods

- (void)authenticateWithCompletion:(DVSGoogleParametersBlock)completion {
    self.completion = completion;
    [self authenticate];
}

- (BOOL)handleURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation  {
    return [[GPPSignIn sharedInstance] handleURL:url sourceApplication:sourceApplication annotation:annotation];
}

#pragma mark - Google+ SDK helpers

- (GTLServicePlus *)googlePlusServiceWithAuthorizer:(id <GTMFetcherAuthorizationProtocol>)authorizer {
    GTLServicePlus *service = [[GTLServicePlus alloc] init];
    [service setAuthorizer:authorizer];
    service.retryEnabled = YES;
    service.apiVersion = @"v1";
    return service;
}

- (void)authenticate {
    [GPPSignIn sharedInstance].delegate = self;
    if (![[GPPSignIn sharedInstance] trySilentAuthentication]) {
        [[GPPSignIn sharedInstance] authenticate];
    }
}

- (void)continueAuthenticationWithAuth:(GTMOAuth2Authentication *)auth {
    
    if (self.completion == NULL) return;
    
    GTLServicePlus *plusService = [self googlePlusServiceWithAuthorizer:auth];
    GTLQueryPlus *query = [GTLQueryPlus queryForPeopleGetWithUserId:@"me"];
    [plusService executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLPlusPerson *person, NSError *error) {
        if (error) {
            self.completion(nil, error);
        } else {
            NSDictionary *parameters = [DVSOAuthJSONParameters dictionaryForParametersWithProvider:DVSOAuthProviderGoogle oAuthToken:auth.accessToken userID:person.identifier userEmail:[GPPSignIn sharedInstance].authentication.userEmail];
            self.completion(parameters, nil);
        }
    }];
}

#pragma mark - GPPSignInDelegate

- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error {
    if (error) {
        if (self.completion != NULL) self.completion(nil, error);
    } else {
        [self continueAuthenticationWithAuth:auth];
    }
}

- (void)didDisconnectWithError:(NSError *)error {
    if (self.completion != NULL) self.completion(nil, error);
}

@end
