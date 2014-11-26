//
//  SSKValidator.m
//  SaasKit
//
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "SSKValidator.h"
#import "NSArray+SaasKit.h"
#import "SSKConfiguration.h"
#import <objc/runtime.h>

@interface SSKValidator ()

@property (strong, nonatomic) NSMutableArray *validators;

@end

@implementation SSKValidator

- (instancetype)init {
    self = [super init];
    if (self) {
        _validators = [NSMutableArray array];
    }
    return self;
}

+ (SSKValidator *)validator {
    return [[[self class] alloc] init];
}

+ (BOOL)validateModel:(NSObject *)model withError:(NSError **)error rules:(NSArray *(^)())rules {
    
    NSArray *array = rules();
    NSArray *properties = [self propertiesOfModel:model];
    
    for (SSKPropertyValidator *validator in array) {
        
        if (![properties ssk_containsString:validator.propertyName]) {
            NSString *message = [NSString stringWithFormat:@"Property named '%@' wasn't found in %@ class. Property validation skipped.", validator.propertyName, [model class]];
            [[SSKConfiguration sharedConfiguration] logMessage:message];
            
        } else {
            id value = [model valueForKey:validator.propertyName];
            NSError *validationError = [validator validateValue:value];
            if (validationError && *error == NULL) {
                *error = validationError;
                return NO;
            }
        }
    }
    return YES;
}

+ (NSArray *)propertiesOfModel:(NSObject *)model {
    uint count;
    objc_property_t *properties = class_copyPropertyList([model class], &count);
    NSMutableArray *propertyArray = [NSMutableArray arrayWithCapacity:count];
    
    for (uint i = 0; i < count ; i++) {
        const char *propertyName = property_getName(properties[i]);
        [propertyArray addObject:[NSString  stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
    }
    free(properties);
    return [propertyArray copy];
}

@end
