//
//  NSString+SSKAdditions.h
//  SaasKit
//
//  Created by Patryk Kaczmarek on 19.11.2014.
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SSKAdditions)

- (BOOL)isNotEmpty;
- (BOOL)hasValidEmailSyntax;
- (BOOL)isDigit;
- (NSString *)stringByEscapingDiacritics;

@end
