//
//  NSString+SassKit.m
//
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "NSString+SassKit.h"

@implementation NSString (SassKit)

- (BOOL)ssk_isEmpty {
    return !(self.length > 0);
}

- (BOOL)ssk_isEmail {
    NSString *regex = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

- (BOOL)ssk_isDecimal {
    NSCharacterSet *set = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSRange range = [self rangeOfCharacterFromSet:set];
    return (range.location == NSNotFound);
}

- (NSString *)ssk_percentEscapedString {
    return [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
