//
//  DVSTestGooglePlusAuthenticator.h
//  Devise
//
//  Created by Radoslaw Szeja on 13/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSGooglePlusAuthenticator.h"

@interface DVSTestGooglePlusAuthenticator : DVSGooglePlusAuthenticator

@property (copy, nonatomic, readwrite) DVSVoidBlock success;
@property (copy, nonatomic, readwrite) DVSErrorBlock failure;
@property (copy, nonatomic, readwrite) NSString *clientID;

@end


@interface DVSGooglePlusAuthenticator (DeviseTests)

- (GTLServicePlus *)googlePlusService;
- (void)authenticate;

- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error;
- (void)didDisconnectWithError:(NSError *)error;

@end
