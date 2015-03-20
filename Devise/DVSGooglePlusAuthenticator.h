//
//  DVSGooglePlusAuthenticator.h
//  Devise
//
//  Created by Pawel Bialecki on 09.03.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^DVSGoogleParametersBlock)(NSDictionary *parameters, NSError *error);

/**
 *  DVSGooglePlusAuthenticator uses GPPSignIn under the hood and it needs Google+ SDK to work.
 *  If you want to customize GPPSignIn even more, please use [GPPSignIn sharedInstance].
 */
@interface DVSGooglePlusAuthenticator : NSObject

/**
 *  Initializes DVSGooglePlusAuthenticator for authentication with Google+ as 3rd party service.
 *
 *  @param clientID Application's client ID
 *
 *  @return Instance of DVSGooglePlusAuthenticator.
 */
- (instancetype)initWithClientID:(NSString *)clientID;

/**
 *  Authenticate user with Google client ID given in init method. Shared instance of GPSignIn object will be used
 *
 *  @param completion Block invoke when authentication will end. 
 *                    If succeeded will return formatted parameter dictionary according do devise-ios convention. Otherwise error.
 */
- (void)authenticateWithCompletion:(DVSGoogleParametersBlock)completion;

/**
 *  Passes arguments to GPPSignIn handleURL:sourceApplication:annotation: method
 */
- (BOOL)handleURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

@end
