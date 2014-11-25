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

@end
