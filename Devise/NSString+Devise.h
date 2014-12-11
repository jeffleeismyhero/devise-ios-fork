//
//  NSString+Devise.h
//  
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Devise)

- (BOOL)dvs_isEmpty;
- (BOOL)dvs_isEmail;
- (BOOL)dvs_isDecimal;
- (NSString *)dvs_percentEscapedString;

@end
