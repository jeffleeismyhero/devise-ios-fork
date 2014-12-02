//
//  NSError+SassKit.h
//
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>

/// The error codes used by the framework.
typedef NS_ENUM(NSInteger, SSKErrorCode) {
    // Model validation failed
    SSKErrorValidationFailed = 20001,
    // server response with an error
    SSKErrorResponseError
};

/// The error domain used by the framework.
extern NSString * const SSKErrorDomain;

@interface NSError (SassKit)

/// Translates an error code to a description string.
///
/// @param code The error code.
+ (NSString *)ssk_descriptionForErrorCode:(SSKErrorCode)code;

+ (instancetype)ssk_errorWithDescription:(NSString *)description code:(NSInteger)code;

/* Creates an error object described by http response error */
+ (instancetype)ssk_errorWithErrorResponse:(NSDictionary *)response;

@end
