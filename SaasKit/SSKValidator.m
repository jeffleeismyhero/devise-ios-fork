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

#pragma mark - Initializers

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

#pragma mark - Public Methods

+ (BOOL)validateModel:(NSObject *)model error:(NSError **)error usingRules:(NSArray *(^)())rules {

    NSError *validationError = [self valideModel:model usingRules:rules returnTypeClass:[NSError class]];
    if (validationError && *error == NULL) {
        *error = validationError;
        return NO;
    }
    return YES;
}

+ (NSArray *)validateModel:(NSObject *)model usingRules:(NSArray *(^)())rules {
    return [self valideModel:model usingRules:rules returnTypeClass:[NSArray class]];
}

#pragma mark - Private Methods

+ (id)valideModel:(NSObject *)model usingRules:(NSArray *(^)())rules returnTypeClass:(Class)class {
    
    BOOL throwFirstError = NO;
    if (class == [NSArray class]) throwFirstError = NO;
    else if (class == [NSError class]) throwFirstError = YES;
    else NSAssert(NO, @"Allowed class: NSArray or NSError");
    
    NSArray *array = rules();
    NSArray *properties = [self propertiesOfModel:model];
    NSMutableArray *errors = [NSMutableArray array];
    
    if (array.count == 0) {
        NSString *message = [NSString stringWithFormat:@"Lack of validation rules. Are you sure you don't want to define rules for %@ model", [model class]];
        [[SSKConfiguration sharedConfiguration] logMessage:message];
    }
    
    for (SSKPropertyValidator *validator in array) {
        
        [self validatePropertyInValidator:validator ofModel:model];
        
        if (![properties ssk_containsString:validator.propertyName]) {
            NSString *message = [NSString stringWithFormat:@"Property named '%@' wasn't found in %@ class. Property validation skipped.", validator.propertyName, [model class]];
            [[SSKConfiguration sharedConfiguration] logMessage:message];
            
        } else {
            id value = [model valueForKey:validator.propertyName];
            
            if (throwFirstError) {
                NSError *validationError = [validator simpleValidationOfValue:value];
                if (validationError) {
                    return validationError;
                }
            } else {
                [errors addObjectsFromArray:[validator complexValidationOfValue:value]];
            }
        }
    }
    return throwFirstError ? nil : [errors copy];
}

+ (void)validatePropertyInValidator:(SSKPropertyValidator *)validator ofModel:(NSObject *)model {
    // Tricky part:
    // Compiler doesn't show warnings if any validation block call isn't ended with parentheses
    // Catch an exception and inform user about possible reason
    @try {
        (void)validator.propertyName;
    }
    @catch (NSException *exception) {
        NSAssert1(NO, @"An exception appear during parameter from %@ model validation. Did you remember to use parentheses in block call?", [model class]);
    }
}

+ (NSArray *)propertiesOfModel:(NSObject *)model {
    uint count;
    objc_property_t *properties = class_copyPropertyList([model class], &count);
    NSMutableArray *propertyArray = [NSMutableArray arrayWithCapacity:count];
    
    for (uint i = 0; i < count ; i++) {
        const char *propertyName = property_getName(properties[i]);
        [propertyArray addObject:[NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
    }
    free(properties);
    return [propertyArray copy];
}

@end
