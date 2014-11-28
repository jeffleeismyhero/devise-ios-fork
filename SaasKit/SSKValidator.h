//
//  SSKValidator.h
//  SaasKit
//
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSKPropertyValidator.h"

#define validate(property) ({[SSKPropertyValidator validatorForPropertyName:@#property];})

@interface SSKValidator : NSObject
/**
 *  Specify a first validation error and return NO if any error appear or YES if validation will pass
 *
 *  @param model Model within properties are validated
 *  @param error Validation error with description. Possibe NULL if all validation will pass
 *  @param rules An array of validation rules. Every property within a model is validated separately
 *
 *  @return result of validation. YES if all validation will pass. Otherwise NO.
 */
+ (BOOL)validateModel:(NSObject *)model withError:(NSError **)error rules:(NSArray *(^)())rules;

/**
 *  Gather all validation errors and return them as an array.
 *
 *  @param model Model within properties are validated
 *  @param rules An array of validation rules. Every property within a model is validated separately
 *
 *  @return an array of errors. If validation will pass then array is empty.
 */
+ (NSArray *)validateModel:(NSObject *)model withRules:(NSArray *(^)())rules;

@end
