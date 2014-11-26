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

+ (BOOL)validateModel:(NSObject *)model withError:(NSError **)error rules:(NSArray *(^)())rules;

@end
