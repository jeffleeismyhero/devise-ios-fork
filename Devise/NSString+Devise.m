//
//  NSString+Devise.m
//
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "NSString+Devise.h"

@implementation NSString (Devise)

- (BOOL)dvs_isEmpty {
    return !(self.length > 0);
}

- (BOOL)dvs_isEmail {
    NSString *regex = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

- (BOOL)dvs_isDecimal {
    NSCharacterSet *set = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSRange range = [self rangeOfCharacterFromSet:set];
    return (range.location == NSNotFound);
}

- (NSString *)dvs_percentEscapedString {
    return [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
