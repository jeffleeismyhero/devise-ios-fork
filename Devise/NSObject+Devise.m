//
//  NSObject+Devise.m
//  Devise
//
//  Created by Patryk Kaczmarek on 15.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "NSObject+Devise.h"
#import <objc/runtime.h>

@implementation NSObject (Devise)

- (NSArray *)dvs_runtimePropertiesOfClass:(Class)aClass {
    
    uint count;
    objc_property_t *properties = class_copyPropertyList(aClass, &count);
    NSMutableArray *propertyArray = [NSMutableArray arrayWithCapacity:count];
    
    for (uint i = 0; i < count ; i++) {
        const char *propertyName = property_getName(properties[i]);
        [propertyArray addObject:[NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
    }
    free(properties);
    return propertyArray;
}

- (NSArray *)dvs_propertiesOfClass:(Class)aClass {
    
    NSMutableArray *array = [[self dvs_runtimePropertiesOfClass:aClass] mutableCopy];
    
    if (aClass.superclass != [NSObject class]) {
        [array addObjectsFromArray:[self dvs_propertiesOfClass:aClass.superclass]];
    }
    return [array copy];
}

- (NSArray *)dvs_properties {
    return [self dvs_propertiesOfClass:[self class]];
}

@end
