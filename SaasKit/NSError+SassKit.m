//
//  NSError+SassKit.m
//  
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "NSError+SassKit.h"

NSString * const SSKErrorDomain = @"co.netguru.lib.sasskit.error";

@implementation NSError (SassKit)

+ (NSString *)ssk_descriptionForErrorCode:(SSKErrorCode)code {
    switch (code) {
        case SSKErrorValidationFailed:
            return @"Validation failed";
        case SSKErrorResponseError:
            return @"Response contains an error";
    }
}

+ (instancetype)ssk_errorWithDescription:(NSString *)description code:(NSInteger)code {
    return [[self alloc] initWithDomain:SSKErrorDomain code:code userInfo:@{NSLocalizedDescriptionKey: description}];
}

+ (instancetype)ssk_errorWithErrorResponse:(NSDictionary *)response {
    NSString *description = response[@"error"][@"message"] ?: [self ssk_descriptionForErrorCode:SSKErrorResponseError];
    return [[self alloc] initWithDomain:SSKErrorDomain code:SSKErrorResponseError userInfo:@{NSLocalizedDescriptionKey : description}];
}

@end
