//
//  DVSGooglePlusSignInHelper.m
//  Devise
//
//  Created by Pawel Bialecki on 09.03.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSGooglePlusSignInHelper.h"
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#import "DVSOAuthJSONParameters.h"
#import "DVSUserManager.h"
#import "DVSHTTPClient+User.h"

@interface DVSGooglePlusSignInHelper () <GPPSignInDelegate>

@property (copy) DVSVoidBlock success;
@property (copy) DVSErrorBlock failure;
@property (copy, nonatomic) NSString *clientID;

@end

@implementation DVSGooglePlusSignInHelper

- (void)authenticateWithGoogleClientID:(NSString *)clientID success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    self.success = success;
    self.failure = failure;
    self.clientID = clientID;
    
    [self setupGoogleSharedInstance];
    [GPPSignIn sharedInstance].delegate = self;
    [[GPPSignIn sharedInstance] authenticate];
}

#pragma mark - Lifecycle

- (void)dealloc {
    [GPPSignIn sharedInstance].delegate = nil;
}

#pragma mark - Google+ SDK helpers

- (void)setupGoogleSharedInstance {
    [GPPSignIn sharedInstance].clientID = self.clientID;
    [GPPSignIn sharedInstance].scopes = @[ kGTLAuthScopePlusLogin, kGTLAuthScopePlusUserinfoProfile, kGTLAuthScopePlusUserinfoEmail, kGTLAuthScopePlusMe ];
    [GPPSignIn sharedInstance].shouldFetchGoogleUserID = YES;
    [GPPSignIn sharedInstance].shouldFetchGooglePlusUser = YES;
    [GPPSignIn sharedInstance].shouldFetchGoogleUserEmail = YES;
}

- (GTLServicePlus *)googlePlusService {
    GTLServicePlus* service = [[GTLServicePlus alloc] init];
    service.retryEnabled = YES;
    [service setAuthorizer:[GPPSignIn sharedInstance].authentication];
    service.apiVersion = @"v1";
    return service;
}

#pragma mark - GPPSignInDelegate

- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error {
    if (error) {
        if (self.failure != NULL) self.failure(error);
    } else {
        GTLServicePlus *plusService = [self googlePlusService];
        GTLQueryPlus *query = [GTLQueryPlus queryForPeopleGetWithUserId:@"me"];
        [plusService executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLPlusPerson *person, NSError *error) {
            if (error) {
                if (self.failure != NULL) self.failure(error);
            } else {
                NSDictionary *parameters = [DVSOAuthJSONParameters dictionaryForParametersWithProvider:DVSOAuthProviderGoogle oAuthToken:auth.accessToken userID:person.identifier userEmail:[GPPSignIn sharedInstance].authentication.userEmail];
                
                [[DVSUserManager defaultManager].httpClient signInUsingGoogleUser:[DVSUserManager defaultManager].user parameters:parameters success:self.success failure:self.failure];
            }
        }];
    }
}

- (void)didDisconnectWithError:(NSError *)error {
    if (self.failure != NULL) self.failure(error);
}

@end
