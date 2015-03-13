//
//  DVSFacebookAuthenticator.h
//  Devise
//
//  Created by Pawel Bialecki on 09.03.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^DVSFacebookParametersBlock)(NSDictionary *parameters, NSError *error);

@interface DVSFacebookAuthenticator : NSObject

- (void)signInUsingFacebookWithAppID:(NSString *)facebookAppID completion:(DVSFacebookParametersBlock)completion;

@end
