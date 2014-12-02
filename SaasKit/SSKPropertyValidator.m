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
    SSKValidatorMessageTypeDoesntMatch,
    //NSNumber messages:
    SSKValidatorMessageTypeIsntFalse,
    SSKValidatorMessageTypeIsntTrue,
    SSKValidatorMessageTypeTooSmall,
    SSKValidatorMessageTypeTooBig,
    SSKValidatorMessageTypeExact,
    //
    SSKValidatorMessageTypeEqual,
    SSKValidatorMessageTypeNotEqual,
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

- (SSKPropertyValidator *(^)(NSString *))localizedPropertyName {
    return ^(NSString *name) {
        [self setMessage:name forMessageType:SSKValidatorMessageTypeLocalizedPropertyName];
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

- (SSKPropertyValidator *(^)(NSString *))doesntMatch {
    return ^(NSString *message) {
        [self setMessage:message forMessageType:SSKValidatorMessageTypeDoesntMatch];
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

#pragma mark Compare messages:

- (SSKPropertyValidator *(^)(NSString *))isntEqual {
    return ^(NSString *message) {
        [self setMessage:message forMessageType:SSKValidatorMessageTypeEqual];
        return self;
    };
}

- (SSKPropertyValidator *(^)(NSString *))isEqual {
    return ^(NSString *message) {
        [self setMessage:message forMessageType:SSKValidatorMessageTypeNotEqual];
        return self;
    };
}

- (SSKPropertyValidator *(^)(NSString *))isntGreater {
    return ^(NSString *message) {
        [self setMessage:message forMessageType:SSKValidatorMessageTypeGreaterThan];
        return self;
    };
}

- (SSKPropertyValidator *(^)(NSString *))isntLess {
    return ^(NSString *message) {
        [self setMessage:message forMessageType:SSKValidatorMessageTypeLessThan];
        return self;
    };
}

- (SSKPropertyValidator *(^)(NSString *))isntGreaterOrEqual {
    return ^(NSString *message) {
        [self setMessage:message forMessageType:SSKValidatorMessageTypeGreaterThanOrEqualTo];
        return self;
    };
}

- (SSKPropertyValidator *(^)(NSString *))isntLessOrEqual {
    return ^(NSString *message) {
        [self setMessage:message forMessageType:SSKValidatorMessageTypeLessThanOrEqualTo];
        return self;
    };
}

#pragma mark - Rules
#pragma mark Overall rules:

- (SSKPropertyValidator *(^)())required {
    __weak typeof(self) weakSelf = self;
    
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
    __weak typeof(self) weakSelf = self;
    
    return ^(NSObject *compareObject, SSKComparisionOperator comparisionOperator) {
        [self.validators addObject:^(NSObject *value) {
            
            if ([value isKindOfClass:[NSNumber class]]) {
                return [weakSelf compareNumber:(NSNumber *)value toNumber:(NSNumber *)compareObject usingOperator:comparisionOperator];
                
            } else if ([value isKindOfClass:[NSDate class]]) {
                return [weakSelf compareDate:(NSDate *)value toDate:(NSDate *)compareObject usingOperator:comparisionOperator];
                
            } else {
                NSString *description = [NSString stringWithFormat:@"Only NSDate and NSNumber objects can be compared to eachoter. Given parameter is kind of %@ class", [value class]];
                [weakSelf assertWithDescription:description];
            }
            return (NSError *)nil;
        }];
        return self;
    };
}

#pragma mark NSString rules:

- (SSKPropertyValidator *(^)())emailSyntax {
    __weak typeof(self) weakSelf = self;
    
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
    __weak typeof(self) weakSelf = self;
    
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
    __weak typeof(self) weakSelf = self;
    
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
    __weak typeof(self) weakSelf = self;
    
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
    __weak typeof(self) weakSelf = self;
    
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
    __weak typeof(self) weakSelf = self;
    
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

- (SSKPropertyValidator *(^)(NSString *))match {
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *string) {
        [self.validators addObject:^(NSString *value) {
            
            if (![weakSelf isObject:value kindOfClass:[NSString class]]) {
                return (NSError *)nil;
            } else if (![value isEqualToString:string]) {
                return [weakSelf errorWithMessageType:SSKValidatorMessageTypeDoesntMatch attribute:string];
            }
            return (NSError *)nil;
        }];
        return self;
    };
}

#pragma mark NSNumber rules:

- (SSKPropertyValidator *(^)())falseValue {
    __weak typeof(self) weakSelf = self;
    
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
    __weak typeof(self) weakSelf = self;
    
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
    __weak typeof(self) weakSelf = self;
    
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
    __weak typeof(self) weakSelf = self;
    
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
    __weak typeof(self) weakSelf = self;
    
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
    __weak typeof(self) weakSelf = self;
    
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
    
    if (![self isObject:compareNumber kindOfClass:[NSNumber class]]) {
        return nil;
    }
    
    NSString *attribute = compareNumber.stringValue;
    switch (comparisionOperator) {
        case SSKComparisionOperatorEqual:
            if (![number isEqualToNumber:compareNumber]) {
                return [self errorWithMessageType:SSKValidatorMessageTypeEqual attribute:attribute];
            } break;
        case SSKComparisionOperatorNotEqual:
            if ([number isEqualToNumber:compareNumber]) {
                return [self errorWithMessageType:SSKValidatorMessageTypeNotEqual attribute:attribute];
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
    
    if (![self isObject:compareDate kindOfClass:[NSDate class]]) {
        return nil;
    }
    
    NSString *attribute = [self.dateFormatter stringFromDate:compareDate];
    switch (comparisionOperator) {
        case SSKComparisionOperatorEqual:
            if (![date isEqual:compareDate]) {
                return [self errorWithMessageType:SSKValidatorMessageTypeEqual attribute:attribute];
            } break;
        case SSKComparisionOperatorNotEqual:
            if ([date isEqualToDate:compareDate]) {
                return [self errorWithMessageType:SSKValidatorMessageTypeNotEqual attribute:attribute];
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

- (void)assertWithDescription:(NSString *)description {
    NSAssert(NO, description);
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
    [self setMessage:@"doesn't match {attribute}" forMessageType:SSKValidatorMessageTypeDoesntMatch];
    
    // NSNumber:
    [self setMessage:@"is too small. Should be min {attribute}." forMessageType:SSKValidatorMessageTypeTooSmall];
    [self setMessage:@"is too big. Should be max {attribute}." forMessageType:SSKValidatorMessageTypeTooBig];
    [self setMessage:@"should be true." forMessageType:SSKValidatorMessageTypeIsntTrue];
    [self setMessage:@"should be false." forMessageType:SSKValidatorMessageTypeIsntFalse];
    [self setMessage:@"isn't exact. Should be {attribute}." forMessageType:SSKValidatorMessageTypeExact];
    
    // Two NSObjects comparision:
    [self setMessage:@"isn't equal to {attribute}" forMessageType:SSKValidatorMessageTypeEqual];
    [self setMessage:@"is equal to {attribute}" forMessageType:SSKValidatorMessageTypeNotEqual];
    [self setMessage:@"is greater than or equal to {attribute}. Should be less than {attribute}." forMessageType:SSKValidatorMessageTypeLessThan];
    [self setMessage:@"is less than or equal to {attribute}. Should be greater than {attribute}." forMessageType:SSKValidatorMessageTypeGreaterThan];
    [self setMessage:@"is greater than {attribute}. Should be less or equal to {attribute}." forMessageType:SSKValidatorMessageTypeLessThanOrEqualTo];
    [self setMessage:@"is less than {attribute}. Should be greater or equal to {attribute}." forMessageType:SSKValidatorMessageTypeGreaterThanOrEqualTo];
}

- (NSDateFormatter *)dateFormatter {
    if(!_dateFormatter) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterShortStyle;
        dateFormatter.timeStyle = NSDateFormatterShortStyle;
        _dateFormatter = dateFormatter;
    }
    return _dateFormatter;
}

@end
