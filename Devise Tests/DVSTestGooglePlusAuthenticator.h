//
//  DVSTestGooglePlusAuthenticator.h
//  Devise
//
//  Created by Radoslaw Szeja on 13/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSGooglePlusAuthenticator.h"

#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>

@interface DVSTestGooglePlusAuthenticator : DVSGooglePlusAuthenticator

@property (copy, nonatomic, readwrite) DVSGoogleParametersBlock completion;

@end

@interface DVSGooglePlusAuthenticator (DeviseTests)

- (GTLServicePlus *)googlePlusServiceWithAuthorizer:(id <GTMFetcherAuthorizationProtocol>)authorizer;
- (void)authenticate;

- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error;
- (void)didDisconnectWithError:(NSError *)error;

@end
