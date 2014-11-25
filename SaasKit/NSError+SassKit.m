//
//  NSError+SassKit.m
//  
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "NSError+SassKit.h"

NSString * const SSKErrorDomain = @"co.netguru.lib.sasskit.error";

@implementation NSError (SassKit)

+ (instancetype)ssk_errorWithCode:(SSKErrorCode)code parameter:(NSString *)parameter {
    NSString *translation = [self ssk_descriptionForErrorCode:code];
    NSString *description = [NSString stringWithFormat:@"Parameter '%@' %@", parameter, translation];
    return [[self alloc] initWithDomain:SSKErrorDomain code:code userInfo:@{
        NSLocalizedDescriptionKey: description,
    }];
}

+ (NSString *)ssk_descriptionForErrorCode:(SSKErrorCode)code {
    switch (code) {
        case SSKErrorParamEmpty:
            return @"cannot be nil or empty";
        case SSKErrorParamSyntaxInvalid:
            return @"has invalid syntax";
    }
}

@end
