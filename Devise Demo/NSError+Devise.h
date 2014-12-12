//
//  NSError+Devise.h
//  Devise
//
//  Created by Wojciech Trzasko on 12.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (Devise)

+ (NSError *)dvs_passwordConfirmError;
+ (NSError *)dvs_newPasswordConfirmError;

@end
