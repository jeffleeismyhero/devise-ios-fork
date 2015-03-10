//
//  DVSFacebookSignInHelper.h
//  Devise
//
//  Created by Pawel Bialecki on 09.03.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DVSTypedefs.h"

@interface DVSFacebookSignInHelper : NSObject

- (void)obtainLoginParametersWithAppID:(NSString *)appID completion:(DVSFacebookParametersBlock)completion;

@end
