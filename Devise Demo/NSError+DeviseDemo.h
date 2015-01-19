//
//  NSError+DeviseDemo.h
//  Devise
//
//  Created by Wojciech Trzasko on 12.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (DeviseDemo)

+ (NSError *)dvs_passwordConfirmError;
+ (NSError *)dvs_newPasswordRequiredError;
+ (NSError *)dvs_newPasswordConfirmMatchError;
+ (NSError *)dvs_newPasswordConfirmRequiredError;
+ (NSError *)dvs_currentPasswordRequiredError;

- (NSInteger)dvs_urlStatusCode;

@end
