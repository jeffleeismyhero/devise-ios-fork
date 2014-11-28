//
//  NSError+SassKit.h
//
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>

/// The error codes used by the framework.
typedef NS_ENUM(NSInteger, SSKErrorCode) {
    SSKErrorParamEmpty = 20001,
    SSKErrorParamSyntaxInvalid = 20002,
    SSKErrorValidationFailed = 20003,
    SSKErrorRequestError = 20004,
    SSKErrorResponseEmpty = 20005
};

/// The error domain used by the framework.
extern NSString * const SSKErrorDomain;

@interface NSError (SassKit)

/// Creates an error instance using a code and a parameter.
///
/// @param code The error code.
/// @param parameter The optional parameter.
+ (instancetype)ssk_errorWithCode:(SSKErrorCode)code parameter:(NSString *)parameter;

/// Translates an error code to a description string.
///
/// @param code The error code.
+ (NSString *)ssk_descriptionForErrorCode:(SSKErrorCode)code;

+ (instancetype)ssk_errorWithDescription:(NSString *)description code:(NSInteger)code;

/* Creates an error object when some response object was expected but nothing was returned */
+ (instancetype)ssk_errorForEmptyResponse;

/* Creates an error object described by http response error */
+ (instancetype)ssk_errorFromDictionary: (NSDictionary*) dictionary;

@end
