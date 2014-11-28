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
        case SSKErrorValidationFailed:
            return @"";
        case SSKErrorRequestError:
            return @"request error";
        case SSKErrorResponseEmpty:
            return @"response cannot be empty";
    }
}

+ (instancetype)ssk_errorWithDescription:(NSString *)description code:(NSInteger)code {
    return [[self alloc] initWithDomain:SSKErrorDomain code:code userInfo:@{NSLocalizedDescriptionKey: description}];
}

+ (instancetype)ssk_errorForEmptyResponse {
    return [[self alloc] initWithDomain: SSKErrorDomain code: SSKErrorResponseEmpty userInfo: @{
                            NSLocalizedDescriptionKey: [NSError ssk_descriptionForErrorCode: SSKErrorResponseEmpty]} ];
}

+ (instancetype)ssk_errorFromDictionary: (NSDictionary*) dictionary {
    return [[self alloc] initWithDomain: SSKErrorDomain code: SSKErrorRequestError userInfo: dictionary ];
}

@end
