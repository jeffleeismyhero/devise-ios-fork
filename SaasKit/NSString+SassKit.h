//
//  NSString+SassKit.h
//  
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SassKit)

/// Whether a string is empty.
- (BOOL)ssk_isEmpty;

/// Whether a string has a valid email syntax.
- (BOOL)ssk_isEmail;

/// Whether a string represents a decimal number.
- (BOOL)ssk_isDecimal;

/// Returns a string with percent escapes.
- (NSString *)ssk_percentEscapedString;

@end
