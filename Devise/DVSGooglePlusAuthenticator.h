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

- (void)authenticateWithGoogleClientID:(NSString *)clientID success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;
- (void)authenticateWithSignIn:(GPPSignIn *)signIn success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;

@end
