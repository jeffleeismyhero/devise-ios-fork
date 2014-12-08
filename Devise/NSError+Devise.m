//
//  NSError+Devise.m
//  
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "NSError+Devise.h"
#import "NSDictionary+Devise.h"

NSString * const DVSErrorDomain = @"co.netguru.lib.Devise.error";

@implementation NSError (Devise)

+ (NSString *)dvs_descriptionForErrorCode:(DVSErrorCode)code {
    switch (code) {
        case DVSErrorValidationFailed:
            return @"Validation failed";
        case DVSErrorResponseError:
            return @"Response contains an error";
    }
}

+ (instancetype)dvs_errorWithDescription:(NSString *)description code:(NSInteger)code {
    return [[self alloc] initWithDomain:DVSErrorDomain code:code userInfo:@{NSLocalizedDescriptionKey: description}];
}

+ (instancetype)dvs_errorWithErrorResponse:(NSDictionary *)response {
    NSString *description = response[@"error"][@"message"] ?: [self dvs_descriptionForErrorCode:DVSErrorResponseError];
    NSInteger code = response[@"error"][@"status"] ? [response[@"error"] dvs_integerValueForKey:@"status"] : DVSErrorResponseError;
    return [[self alloc] initWithDomain:DVSErrorDomain code:code userInfo:@{NSLocalizedDescriptionKey : description}];
}

@end
