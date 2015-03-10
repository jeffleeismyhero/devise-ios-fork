//
//  DVSGooglePlusSignInHelper.m
//  Devise
//
//  Created by Pawel Bialecki on 09.03.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSGooglePlusSignInHelper.h"
#import "DVSOAuthJSONParameters.h"
#import "DVSUserManager.h"
#import "DVSHTTPClient+User.h"

@interface DVSGooglePlusSignInHelper () <GPPSignInDelegate>

@property (copy, nonatomic) DVSVoidBlock success;
@property (copy, nonatomic) DVSErrorBlock failure;
@property (copy, nonatomic) NSString *clientID;

@end

@implementation DVSGooglePlusSignInHelper

- (instancetype)initWithClientID:(NSString *)clientID {
    self = [super init];
    if (self) {
        self.clientID = clientID;
    }
    return self;
}

- (void)dealloc {
    self.signIn.delegate = nil;
    self.signIn = nil;
}

#pragma mark - Public methods

- (void)authenticateWithGoogleClientID:(NSString *)clientID success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    self.success = success;
    self.failure = failure;
    self.clientID = clientID;
    
    self.signIn = [GPPSignIn sharedInstance];
    [self setupGoogleSignIn:self.signIn];

    [self authenticate];
}

- (void)authenticateWithSignIn:(GPPSignIn *)signIn success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure {
    self.success = success;
    self.failure = failure;
    self.signIn = signIn;
    
    [self setupGoogleSignIn:self.signIn];
    [self authenticate];
}

#pragma mark - Private methods

- (void)authenticate {    
    if (![self.signIn trySilentAuthentication]) {
        [self.signIn authenticate];
    }
}

#pragma mark - Google+ SDK helpers

- (void)setupGoogleSignIn:(GPPSignIn *)signIn {
    signIn.clientID = self.clientID;
    signIn.scopes = @[ kGTLAuthScopePlusLogin, kGTLAuthScopePlusUserinfoProfile, kGTLAuthScopePlusUserinfoEmail, kGTLAuthScopePlusMe ];
    signIn.attemptSSO = YES;
    signIn.shouldFetchGoogleUserID = YES;
    signIn.shouldFetchGooglePlusUser = YES;
    signIn.shouldFetchGoogleUserEmail = YES;
    signIn.delegate = self;
}

- (GTLServicePlus *)googlePlusService {
    GTLServicePlus* service = [[GTLServicePlus alloc] init];
    service.retryEnabled = YES;
    [service setAuthorizer:self.signIn.authentication];
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
