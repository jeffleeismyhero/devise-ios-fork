//
//  SSKPropertyValidator.m
//  SaasKit
//
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "SSKPropertyValidator.h"
#import "SSKConfiguration.h"
#import "NSString+SassKit.h"
#import "NSNumber+SaasKit.h"
#import "NSError+SassKit.h"
#import "NSDate+SaasKit.h"
#import "SSKTypedefs.h"

static inline NSString * intToString(NSUInteger x) {
    return [NSString stringWithFormat:@"%lu", (unsigned long)x];
}

NSString * const ssk_attribute = @"{attribute}";

typedef NS_ENUM(NSInteger, SSKValidatorMessageType) {
    //overall messages:
    SSKValidatorMessageTypeRequired,
    SSKValidatorMessageTypeLocalizedPropertyName,
    //NSString messages:
    SSKValidatorMessageTypeSyntaxEmail,
    SSKValidatorMessageTypeTooShort,
    SSKValidatorMessageTypeTooLong,
    SSKValidatorMessageTypeExactLength,
    SSKValidatorMessageTypeDecimal,
    SSKValidatorMessageTypeIdenticalTo,
    //NSNumber messages:
    SSKValidatorMessageTypeIsntFalse,
    SSKValidatorMessageTypeIsntTrue,
    SSKValidatorMessageTypeTooSmall,
    SSKValidatorMessageTypeTooBig,
    SSKValidatorMessageTypeExact,
    //
    SSKValidatorMessageTypeIdentical,
    SSKValidatorMessageTypeEqual,
    SSKValidatorMessageTypeNotEqual,
    SSKValidatorMessageTypeNotIdentical,
    SSKValidatorMessageTypeLessThan,
    SSKValidatorMessageTypeGreaterThan,
    SSKValidatorMessageTypeLessThanOrEqualTo,
    SSKValidatorMessageTypeGreaterThanOrEqualTo
};

@interface SSKPropertyValidator ()

@property (strong, nonatomic) NSMutableArray *validators;
@property (strong, nonatomic) NSMutableDictionary *validatorMessages;

@end

@implementation SSKPropertyValidator

#pragma mark - Initializers

- (instancetype)initWithPropertyName:(NSString *)propertyName {
    self = [super init];
    if (self) {
        NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@\""];
        _propertyName = [propertyName stringByTrimmingCharactersInSet:set];

        _validators = [NSMutableArray array];
        _validatorMessages = [NSMutableDictionary dictionary];
        [self initializeValidatorMessages];
    }
    return self;
}

+ (SSKPropertyValidator *)validatorForPropertyName:(NSString *)propertyName {
    return [[[self class] alloc] initWithPropertyName:propertyName];
}

#pragma mark - Public Methods

- (NSError *)simpleValidationOfValue:(id)value {
    
    for (SSKValidationBlock block in self.validators) {
        NSError *error = block(value);
        if (error) {
            return error;
        }
    }
    return nil;
}

- (NSArray *)complexValidationOfValue:(id)value {
    NSMutableArray *array = [NSMutableArray array];
    
    for (SSKValidationBlock block in self.validators) {
        NSError *error = block(value);
        if (error) {
            [array addObject:error];
        }
    }
    return array;
}

#pragma mark - Messages
#pragma mark Overall Messages

- (SSKPropertyValidator *(^)(NSString *))nilOrEmpty {
    return ^(NSString *message) {
        [self setMessage:message forMessageType:SSKValidatorMessageTypeRequired];
        return self;
    };
}

#pragma mark NSString messages:

- (SSKPropertyValidator *(^)(NSString *))isntEmail {
    return ^(NSString *message) {
        [self setMessage:message forMessageType:SSKValidatorMessageTypeSyntaxEmail];
        return self;
    };
}

- (SSKPropertyValidator *(^)(NSString *))isntDecimal {
    return ^(NSString *message) {
        [self setMessage:message forMessageType:SSKValidatorMessageTypeDecimal];
        return self;
    };
}

- (SSKPropertyValidator *(^)(NSString *))tooShort {
    return ^(NSString *message) {
        [self setMessage:message forMessageType:SSKValidatorMessageTypeTooShort];
        return self;
    };
}

- (SSKPropertyValidator *(^)(NSString *))tooLong {
    return ^(NSString *message) {
        [self setMessage:message forMessageType:SSKValidatorMessageTypeTooLong];
        return self;
    };
}

- (SSKPropertyValidator *(^)(NSString *))notExactLength {
    return ^(NSString *message) {
        [self setMessage:message forMessageType:SSKValidatorMessageTypeExactLength];
        return self;
    };
}

- (SSKPropertyValidator *(^)(NSString *))localizedPropertyName {
    return ^(NSString *name) {
        [self setMessage:name forMessageType:SSKValidatorMessageTypeLocalizedPropertyName];
        return self;
    };
}

#pragma mark NSNumber messages:

- (SSKPropertyValidator *(^)(NSString *))isntTrue {
    return ^(NSString *message) {
        [self setMessage:message forMessageType:SSKValidatorMessageTypeIsntTrue];
        return self;
    };
}

- (SSKPropertyValidator *(^)(NSString *))isntFalse {
    return ^(NSString *message) {
        [self setMessage:message forMessageType:SSKValidatorMessageTypeIsntFalse];
        return self;
    };
}

- (SSKPropertyValidator *(^)(NSString *))tooSmall {
    return ^(NSString *message) {
        [self setMessage:message forMessageType:SSKValidatorMessageTypeTooSmall];
        return self;
    };
}

- (SSKPropertyValidator *(^)(NSString *))tooBig {
    return ^(NSString *message) {
        [self setMessage:message forMessageType:SSKValidatorMessageTypeTooBig];
        return self;
    };
}

- (SSKPropertyValidator *(^)(NSString *))notExact {
    return ^(NSString *message) {
        [self setMessage:message forMessageType:SSKValidatorMessageTypeExact];
        return self;
    };
}

#pragma mark - Rules
#pragma mark Overall rules:

- (SSKPropertyValidator *(^)())required {
    __weak typeof(self)weakSelf = self;
    
    return ^() {
        [self.validators addObject:^(NSObject *value) {
            if (!value || [value isKindOfClass:[NSNull class]]) {
                return [weakSelf errorWithMessageType:SSKValidatorMessageTypeRequired];
            }
            return (NSError *)nil;
        }];
        return self;
    };
}

- (SSKPropertyValidator *(^)(NSObject *, SSKComparisionOperator))compareTo {
    __weak typeof(self)weakSelf = self;
    
    return ^(NSObject *compareObject, SSKComparisionOperator comparisionOperator) {
        [self.validators addObject:^(NSObject *value) {
            
            if ([value isKindOfClass:[NSNumber class]]) {
                return [weakSelf compareNumber:(NSNumber *)value toNumber:(NSNumber *)compareObject usingOperator:comparisionOperator];
                
            } else if ([value isKindOfClass:[NSDate class]]) {
                return [weakSelf compareDate:(NSDate *)value toDate:(NSDate *)compareObject usingOperator:comparisionOperator];
                
            }
            return (NSError *)nil;
        }];
        return self;
    };
}

#pragma mark NSString rules:

- (SSKPropertyValidator *(^)())emailSyntax {
    __weak typeof(self)weakSelf = self;
    
    return ^() {
        [self.validators addObject:^(NSString *value) {
            
            if (![weakSelf isObject:value kindOfClass:[NSString class]]) {
                return (NSError *)nil;
            } else if (![value ssk_isEmail]) {
                return [weakSelf errorWithMessageType:SSKValidatorMessageTypeSyntaxEmail];
            }
            return (NSError *)nil;
        }];
        return self;
    };
}

- (SSKPropertyValidator *(^)())decimal {
    __weak typeof(self)weakSelf = self;
    
    return ^() {
        [self.validators addObject:^(NSString *value) {
            
            if (![weakSelf isObject:value kindOfClass:[NSString class]]) {
                return (NSError *)nil;
            } else if (![value ssk_isDecimal]) {
                return [weakSelf errorWithMessageType:SSKValidatorMessageTypeDecimal];
            }
            return (NSError *)nil;
        }];
        return self;
    };
}

- (SSKPropertyValidator *(^)(NSUInteger min, NSUInteger max))lengthRange {
    __weak typeof(self)weakSelf = self;
    
    return ^(NSUInteger min, NSUInteger max) {
        [self.validators addObject:^(NSString *value) {
            
            if (![weakSelf isObject:value kindOfClass:[NSString class]]) {
                return (NSError *)nil;
            } else if (value.length < min) {
                return [weakSelf errorWithMessageType:SSKValidatorMessageTypeTooShort attribute:intToString(min)];
            } else if (value.length > max) {
                return [weakSelf errorWithMessageType:SSKValidatorMessageTypeTooLong attribute:intToString(max)];
            }
            return (NSError *)nil;
        }];
        return self;
    };
}

- (SSKPropertyValidator *(^)(NSUInteger min))minLength {
    __weak typeof(self)weakSelf = self;
    
    return ^(NSUInteger min) {
        [self.validators addObject:^(NSString *value) {
            
            if (![weakSelf isObject:value kindOfClass:[NSString class]]) {
                return (NSError *)nil;
            } else if (value.length < min) {
                return [weakSelf errorWithMessageType:SSKValidatorMessageTypeTooShort attribute:intToString(min)];
            }
            return (NSError *)nil;
        }];
        return self;
    };
}

- (SSKPropertyValidator *(^)(NSUInteger max))maxLength {
    __weak typeof(self)weakSelf = self;
    
    return ^(NSUInteger max) {
        [self.validators addObject:^(NSString *value) {
            
            if (![weakSelf isObject:value kindOfClass:[NSString class]]) {
                return (NSError *)nil;
            } else if (value.length > max) {
                return [weakSelf errorWithMessageType:SSKValidatorMessageTypeTooLong attribute:intToString(max)];
            }
            return (NSError *)nil;
        }];
        return self;
    };
}

- (SSKPropertyValidator *(^)(NSUInteger length))exactLength {
    __weak typeof(self)weakSelf = self;
    
    return ^(NSUInteger length) {
        [self.validators addObject:^(NSString *value) {
            
            if (![weakSelf isObject:value kindOfClass:[NSString class]]) {
                return (NSError *)nil;
            } else if (value.length != length) {
                return [weakSelf errorWithMessageType:SSKValidatorMessageTypeExactLength attribute:intToString(length)];
            }
            return (NSError *)nil;
        }];
        return self;
    };
}

#pragma mark NSNumber rules:

- (SSKPropertyValidator *(^)())falseValue {
    __weak typeof(self)weakSelf = self;
    
    return ^() {
        [self.validators addObject:^(NSNumber *value) {
            if (![weakSelf isObject:value kindOfClass:[NSNumber class]]) {
                return (NSError *)nil;
            } else if (![value isEqualToNumber:@(NO)]) {
                return [weakSelf errorWithMessageType:SSKValidatorMessageTypeIsntFalse];
            }
            return (NSError *)nil;
        }];
        return self;
    };
}

- (SSKPropertyValidator *(^)())trueValue {
    __weak typeof(self)weakSelf = self;
    
    return ^() {
        [self.validators addObject:^(NSNumber *value) {
            if (![weakSelf isObject:value kindOfClass:[NSNumber class]]) {
                return (NSError *)nil;
            } else if (![value isEqualToNumber:@(YES)]) {
                return [weakSelf errorWithMessageType:SSKValidatorMessageTypeIsntTrue];
            }
            return (NSError *)nil;
        }];
        return self;
    };
}

- (SSKPropertyValidator *(^)(NSInteger))min {
    __weak typeof(self)weakSelf = self;
    
    return ^(NSInteger min) {
        [self.validators addObject:^(NSNumber *value) {
            
            if (![weakSelf isObject:value kindOfClass:[NSNumber class]]) {
                return (NSError *)nil;
            } else if (value.floatValue < min) {
                return [weakSelf errorWithMessageType:SSKValidatorMessageTypeTooSmall attribute:intToString(min)];
            }
            return (NSError *)nil;
        }];
        return self;
    };
}

- (SSKPropertyValidator *(^)(NSInteger))max {
    __weak typeof(self)weakSelf = self;
    
    return ^(NSInteger max) {
        [self.validators addObject:^(NSNumber *value) {
            
            if (![weakSelf isObject:value kindOfClass:[NSNumber class]]) {
                return (NSError *)nil;
            } else if (value.floatValue > max) {
                return [weakSelf errorWithMessageType:SSKValidatorMessageTypeTooBig attribute:intToString(max)];
            }
            return (NSError *)nil;
        }];
        return self;
    };
}

- (SSKPropertyValidator *(^)(NSInteger, NSInteger))range {
    __weak typeof(self)weakSelf = self;
    
    return ^(NSInteger min, NSInteger max) {
        [self.validators addObject:^(NSString *value) {
            
            if (![weakSelf isObject:value kindOfClass:[NSNumber class]]) {
                return (NSError *)nil;
            } else if (value.floatValue < min) {
                return [weakSelf errorWithMessageType:SSKValidatorMessageTypeTooSmall attribute:intToString(min)];
            } else if (value.floatValue > max) {
                return [weakSelf errorWithMessageType:SSKValidatorMessageTypeTooBig attribute:intToString(max)];
            }
            return (NSError *)nil;
        }];
        return self;
    };
}

- (SSKPropertyValidator *(^)(NSInteger))exact {
    __weak typeof(self)weakSelf = self;
    
    return ^(NSInteger exact) {
        [self.validators addObject:^(NSNumber *value) {
            
            if (![weakSelf isObject:value kindOfClass:[NSNumber class]]) {
                return (NSError *)nil;
            } else if (![value compare:@(exact)] == NSOrderedSame) {
                return [weakSelf errorWithMessageType:SSKValidatorMessageTypeExact attribute:intToString(exact)];
            }
            return (NSError *)nil;
        }];
        return self;
    };
}

#pragma mark - Private Methods

- (NSError *)compareNumber:(NSNumber *)number toNumber:(NSNumber *)compareNumber usingOperator:(SSKComparisionOperator)comparisionOperator {
    NSString *attribute = @"number";
    
    if (![self isObject:number kindOfClass:[NSNumber class]] &&
        ![self isObject:compareNumber kindOfClass:[NSNumber class]]) {
        return nil;
    }
    
    switch (comparisionOperator) {
        case SSKComparisionOperatorEqual:
            if (![number isEqualToNumber:compareNumber]) {
                return [self errorWithMessageType:SSKValidatorMessageTypeEqual attribute:attribute];
            } break;
        case SSKComparisionOperatorIdentical:
            if (![number isEqual:compareNumber]) {
                return [self errorWithMessageType:SSKValidatorMessageTypeIdentical attribute:attribute];
            } break;
        case SSKComparisionOperatorNotEqual:
            if ([number isEqualToNumber:compareNumber]) {
                return [self errorWithMessageType:SSKValidatorMessageTypeNotEqual attribute:attribute];
            } break;
        case SSKComparisionOperatorNotIdentical:
            if ([number isEqual:compareNumber]) {
                return [self errorWithMessageType:SSKValidatorMessageTypeNotIdentical attribute:attribute];
            } break;
        case SSKComparisionOperatorLessThan:
            if (![number ssk_isLessThan:compareNumber]) {
                return [self errorWithMessageType:SSKValidatorMessageTypeLessThan attribute:attribute];
            } break;
        case SSKComparisionOperatorGreaterThan:
            if (![number ssk_isGreaterThan:compareNumber]) {
                return [self errorWithMessageType:SSKValidatorMessageTypeGreaterThan attribute:attribute];
            } break;
        case SSKComparisionOperatorLessThanOrEqualTo:
            if (![number ssk_isLessThanOrEqualTo:compareNumber]) {
                return [self errorWithMessageType:SSKValidatorMessageTypeLessThanOrEqualTo attribute:attribute];
            } break;
        case SSKComparisionOperatorGreaterThanOrEqualTo:
            if (![number ssk_isGreaterThanOrEqualTo:compareNumber]) {
                return [self errorWithMessageType:SSKValidatorMessageTypeGreaterThanOrEqualTo attribute:attribute];
            } break;
    }
    return nil;
}

- (NSError *)compareDate:(NSDate *)date toDate:(NSDate *)compareDate usingOperator:(SSKComparisionOperator)comparisionOperator {
    NSString *attribute = @"date";
    
    if (![self isObject:date kindOfClass:[NSDate class]] &&
        ![self isObject:compareDate kindOfClass:[NSDate class]]) {
        return nil;
    }
    
    switch (comparisionOperator) {
        case SSKComparisionOperatorEqual:
            if (![date isEqualToDate:compareDate]) {
                return [self errorWithMessageType:SSKValidatorMessageTypeEqual attribute:attribute];
            } break;
        case SSKComparisionOperatorIdentical:
            if (![date isEqual:compareDate]) {
                return [self errorWithMessageType:SSKValidatorMessageTypeIdentical attribute:attribute];
            } break;
        case SSKComparisionOperatorNotEqual:
            if ([date isEqualToDate:compareDate]) {
                return [self errorWithMessageType:SSKValidatorMessageTypeNotEqual attribute:attribute];
            } break;
        case SSKComparisionOperatorNotIdentical:
            if ([date isEqual:compareDate]) {
                return [self errorWithMessageType:SSKValidatorMessageTypeNotIdentical attribute:attribute];
            } break;
        case SSKComparisionOperatorLessThan:
            if (![date ssk_isEarlierThan:compareDate]) {
                return [self errorWithMessageType:SSKValidatorMessageTypeLessThan attribute:attribute];
            } break;
        case SSKComparisionOperatorGreaterThan:
            if (![date ssk_isLaterThan:compareDate]) {
                return [self errorWithMessageType:SSKValidatorMessageTypeGreaterThan attribute:attribute];
            } break;
        case SSKComparisionOperatorLessThanOrEqualTo:
            if (![date ssk_isEarlierThanOrEqualTo:compareDate]) {
                return [self errorWithMessageType:SSKValidatorMessageTypeLessThanOrEqualTo attribute:attribute];
            } break;
        case SSKComparisionOperatorGreaterThanOrEqualTo:
            if (![date ssk_isLaterThanOrEqualTo:compareDate]) {
                return [self errorWithMessageType:SSKValidatorMessageTypeGreaterThanOrEqualTo attribute:attribute];
            } break;
    }
    return nil;
}

- (NSString *)messageForMessageType:(SSKValidatorMessageType)messageType {
    return self.validatorMessages[@(messageType)];
}

- (void)setMessage:(NSString *)message forMessageType:(SSKValidatorMessageType)messageType {
    self.validatorMessages[@(messageType)] = message;
}

- (NSError *)errorWithMessageType:(SSKValidatorMessageType)type attribute:(NSString *)attribute {
    NSString *propertyName = [self messageForMessageType:SSKValidatorMessageTypeLocalizedPropertyName];
    NSString *description = [NSString stringWithFormat:@"%@ %@", propertyName, [self messageForMessageType:type]];
    if (attribute) {
        description = [description stringByReplacingOccurrencesOfString:ssk_attribute withString:attribute];
    }
    return [NSError ssk_errorWithDescription:description code:SSKErrorValidationFailed];
}


- (NSError *)errorWithMessageType:(SSKValidatorMessageType)type {
    return [self errorWithMessageType:type attribute:nil];
}

- (BOOL)isObject:(NSObject *)object kindOfClass:(Class)class {
    
    if (object == nil) {
        NSString *message = [NSString stringWithFormat:@"Cannot validate %@ property when is nil. Validation skipped", self.propertyName];
        [[SSKConfiguration sharedConfiguration] logMessage:message];
        return NO;
        
    } else if (![object isKindOfClass:class]) {
        NSAssert3(NO, @"Parameter %@(%@ class) is not kind of %@ class", object, [object class], class);
    }
    return YES;
}

- (void)initializeValidatorMessages {
    [self setMessage:@"cannot be nil or empty" forMessageType:SSKValidatorMessageTypeRequired];
    [self setMessage:_propertyName forMessageType:SSKValidatorMessageTypeLocalizedPropertyName];
    // NSString:
    [self setMessage:@"is too short. Should be min {attribute} signs." forMessageType:SSKValidatorMessageTypeTooShort];
    [self setMessage:@"is too long. Should be max {attribute} signs." forMessageType:SSKValidatorMessageTypeTooLong];
    [self setMessage:@"hasn't exact length. Should has {attribute} signs." forMessageType:SSKValidatorMessageTypeExactLength];
    [self setMessage:@"has invalid email syntax" forMessageType:SSKValidatorMessageTypeSyntaxEmail];
    [self setMessage:@"isn't decimal" forMessageType:SSKValidatorMessageTypeDecimal];
    
    // NSNumber:
    [self setMessage:@"is too small. Should be min {attribute}." forMessageType:SSKValidatorMessageTypeTooSmall];
    [self setMessage:@"is too big. Should be max {attribute}." forMessageType:SSKValidatorMessageTypeTooBig];
    [self setMessage:@"should be true." forMessageType:SSKValidatorMessageTypeIsntTrue];
    [self setMessage:@"should be false." forMessageType:SSKValidatorMessageTypeIsntFalse];
    [self setMessage:@"isn't exact. Should be {attribute}." forMessageType:SSKValidatorMessageTypeExact];
    
    // Two NSObjects comparision:
    [self setMessage:@"isn't identical to compared {attribute}" forMessageType:SSKValidatorMessageTypeIdentical];
    [self setMessage:@"isn't equal to compared {attribute}" forMessageType:SSKValidatorMessageTypeEqual];
    [self setMessage:@"is identical to compared {attribute}" forMessageType:SSKValidatorMessageTypeNotIdentical];
    [self setMessage:@"is equal to compared {attribute}" forMessageType:SSKValidatorMessageTypeNotEqual];
    [self setMessage:@"is greater than or equal to compared {attribute}" forMessageType:SSKValidatorMessageTypeLessThan];
    [self setMessage:@"is less than or equal to compared {attribute}" forMessageType:SSKValidatorMessageTypeGreaterThan];
    [self setMessage:@"is greater than compared {attribute}" forMessageType:SSKValidatorMessageTypeLessThanOrEqualTo];
    [self setMessage:@"is less than compared {attribute}" forMessageType:SSKValidatorMessageTypeGreaterThanOrEqualTo];
}

@end
