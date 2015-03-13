//
//  DVSGooglePlusAuthenticator.h
//  Devise
//
//  Created by Pawel Bialecki on 09.03.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#import "DVSTypedefs.h"

/**
 *  DVSGooglePlusAuthenticator uses GPPSignIn under the hood and it needs Google+ SDK to work.
 */
@interface DVSGooglePlusAuthenticator : NSObject

@property (strong, nonatomic) GPPSignIn *signIn;

- (instancetype)initWithClientID:(NSString *)clientID;

/**
 *  Authenticate user with Google client ID. Shared instance of GPSignIn object will be used
 *  @param clientID Application's client ID
 */
- (void)authenticateWithGoogleClientID:(NSString *)clientID success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;

/**
 *  Authenticate user with provided GPPSignIn object. This method is meant to be used together with - (instancetype)initWithClientID:(NSString *)clientID, otherwise the client ID is unknown and authentication will fail.
 *  @param signIn GPPSignIn instance.
 */
- (void)authenticateWithSignIn:(GPPSignIn *)signIn success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;

@end
