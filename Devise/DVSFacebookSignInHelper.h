//
//  DVSFacebookSignInDelegate.h
//  Devise
//
//  Created by Pawel Bialecki on 09.03.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DVSTypedefs.h"

@interface DVSFacebookSignInHelper : NSObject

- (void)signInUsingFacebookWithAppID:(NSString *)facebookAppID success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;

@end
