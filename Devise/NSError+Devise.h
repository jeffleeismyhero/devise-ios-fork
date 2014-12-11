//
//  NSError+Devise.h
//
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  The error codes used by the framework.
 */
typedef NS_ENUM(NSInteger, DVSErrorCode){
    DVSErrorValidationFailed = 20001, // model validation failed
    DVSErrorResponseError // server response with an error
};

/**
 *  The error domain used by the framework.
 */
extern NSString * const DVSErrorDomain;

@interface NSError (Devise)

/**
*  Translates an error code to a description string.
*
*  @param code The error code.
*  @return Translated code to string.
*/
+ (NSString *)dvs_descriptionForErrorCode:(DVSErrorCode)code;

+ (instancetype)dvs_errorWithDescription:(NSString *)description code:(NSInteger)code;

/**
 *  Creates an error object described by http response error.
 *
 *  @param response server response.
 *  @return instance of NSError.
 */
+ (instancetype)dvs_errorWithErrorResponse:(NSDictionary *)response;

@end
