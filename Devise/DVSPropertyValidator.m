//
//  DVSPropertyValidator.m
//  Devise
//
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSPropertyValidator.h"
#import "DVSConfiguration.h"
#import "NSString+Devise.h"
#import "NSNumber+Devise.h"
#import "NSError+Devise.h"
#import "NSDate+Devise.h"
#import "DVSTypedefs.h"

static inline NSString * intToString(NSUInteger x) {
    return [NSString stringWithFormat:@"%lu", (unsigned long)x];
}

NSString * const dvs_attribute = @"{attribute}";

typedef NS_ENUM(NSInteger, DVSValidatorMessageType) {
    //overall messages:
    DVSValidatorMessageTypeRequired,
    DVSValidatorMessageTypeLocalizedPropertyName,
    //NSString messages:
    DVSValidatorMessageTypeSyntaxEmail,
    DVSValidatorMessageTypeTooShort,
    DVSValidatorMessageTypeTooLong,
    DVSValidatorMessageTypeExactLength,
    DVSValidatorMessageTypeDecimal,
    DVSValidatorMessageTypeIdenticalTo,
    DVSValidatorMessageTypeDoesntMatch,
    //NSNumber messages:
    DVSValidatorMessageTypeIsntFalse,
    DVSValidatorMessageTypeIsntTrue,
    DVSValidatorMessageTypeTooSmall,
    DVSValidatorMessageTypeTooBig,
    DVSValidatorMessageTypeExact,
    //
    DVSValidatorMessageTypeEqual,
    DVSValidatorMessageTypeNotEqual,
    DVSValidatorMessageTypeLessThan,
    DVSValidatorMessageTypeGreaterThan,
    DVSValidatorMessageTypeLessThanOrEqualTo,
    DVSValidatorMessageTypeGreaterThanOrEqualTo
};

@interface DVSPropertyValidator ()

@property (strong, nonatomic) NSMutableArray *validators;
@property (strong, nonatomic) NSMutableDictionary *validatorMessages;

@end

@implementation DVSPropertyValidator

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

+ (DVSPropertyValidator *)validatorForPropertyName:(NSString *)propertyName {
    return [[[self class] alloc] initWithPropertyName:propertyName];
}

#pragma mark - Public Methods

- (NSError *)simpleValidationOfValue:(id)value {
    
    for (DVSValidationBlock block in self.validators) {
        NSError *error = block(value);
        if (error) {
            return error;
        }
    }
    return nil;
}

- (NSArray *)complexValidationOfValue:(id)value {
    NSMutableArray *array = [NSMutableArray array];
    
    for (DVSValidationBlock block in self.validators) {
        NSError *error = block(value);
        if (error) {
            [array addObject:error];
        }
    }
    return array;
}

#pragma mark - Messages
#pragma mark Overall Messages

- (DVSPropertyValidator *(^)(NSString *))nilOrEmpty {
    return ^(NSString *message) {
        [self setMessage:message forMessageType:DVSValidatorMessageTypeRequired];
        return self;
    };
}

- (DVSPropertyValidator *(^)(NSString *))localizedPropertyName {
    return ^(NSString *name) {
        [self setMessage:name forMessageType:DVSValidatorMessageTypeLocalizedPropertyName];
        return self;
    };
}

#pragma mark NSString messages:

- (DVSPropertyValidator *(^)(NSString *))isntEmail {
    return ^(NSString *message) {
        [self setMessage:message forMessageType:DVSValidatorMessageTypeSyntaxEmail];
        return self;
    };
}

- (DVSPropertyValidator *(^)(NSString *))isntDecimal {
    return ^(NSString *message) {
        [self setMessage:message forMessageType:DVSValidatorMessageTypeDecimal];
        return self;
    };
}

- (DVSPropertyValidator *(^)(NSString *))tooShort {
    return ^(NSString *message) {
        [self setMessage:message forMessageType:DVSValidatorMessageTypeTooShort];
        return self;
    };
}

- (DVSPropertyValidator *(^)(NSString *))tooLong {
    return ^(NSString *message) {
        [self setMessage:message forMessageType:DVSValidatorMessageTypeTooLong];
        return self;
    };
}

- (DVSPropertyValidator *(^)(NSString *))notExactLength {
    return ^(NSString *message) {
        [self setMessage:message forMessageType:DVSValidatorMessageTypeExactLength];
        return self;
    };
}

- (DVSPropertyValidator *(^)(NSString *))doesntMatch {
    return ^(NSString *message) {
        [self setMessage:message forMessageType:DVSValidatorMessageTypeDoesntMatch];
        return self;
    };
}

#pragma mark NSNumber messages:

- (DVSPropertyValidator *(^)(NSString *))isntTrue {
    return ^(NSString *message) {
        [self setMessage:message forMessageType:DVSValidatorMessageTypeIsntTrue];
        return self;
    };
}

- (DVSPropertyValidator *(^)(NSString *))isntFalse {
    return ^(NSString *message) {
        [self setMessage:message forMessageType:DVSValidatorMessageTypeIsntFalse];
        return self;
    };
}

- (DVSPropertyValidator *(^)(NSString *))tooSmall {
    return ^(NSString *message) {
        [self setMessage:message forMessageType:DVSValidatorMessageTypeTooSmall];
        return self;
    };
}

- (DVSPropertyValidator *(^)(NSString *))tooBig {
    return ^(NSString *message) {
        [self setMessage:message forMessageType:DVSValidatorMessageTypeTooBig];
        return self;
    };
}

- (DVSPropertyValidator *(^)(NSString *))notExact {
    return ^(NSString *message) {
        [self setMessage:message forMessageType:DVSValidatorMessageTypeExact];
        return self;
    };
}

#pragma mark Compare messages:

- (DVSPropertyValidator *(^)(NSString *))isntEqual {
    return ^(NSString *message) {
        [self setMessage:message forMessageType:DVSValidatorMessageTypeEqual];
        return self;
    };
}

- (DVSPropertyValidator *(^)(NSString *))isEqual {
    return ^(NSString *message) {
        [self setMessage:message forMessageType:DVSValidatorMessageTypeNotEqual];
        return self;
    };
}

- (DVSPropertyValidator *(^)(NSString *))isntGreater {
    return ^(NSString *message) {
        [self setMessage:message forMessageType:DVSValidatorMessageTypeGreaterThan];
        return self;
    };
}

- (DVSPropertyValidator *(^)(NSString *))isntLess {
    return ^(NSString *message) {
        [self setMessage:message forMessageType:DVSValidatorMessageTypeLessThan];
        return self;
    };
}

- (DVSPropertyValidator *(^)(NSString *))isntGreaterOrEqual {
    return ^(NSString *message) {
        [self setMessage:message forMessageType:DVSValidatorMessageTypeGreaterThanOrEqualTo];
        return self;
    };
}

- (DVSPropertyValidator *(^)(NSString *))isntLessOrEqual {
    return ^(NSString *message) {
        [self setMessage:message forMessageType:DVSValidatorMessageTypeLessThanOrEqualTo];
        return self;
    };
}

#pragma mark - Rules
#pragma mark Overall rules:

- (DVSPropertyValidator *(^)())required {
    __weak typeof(self) weakSelf = self;
    
    return ^() {
        [self.validators addObject:^(NSObject *value) {
            if (!value || [value isKindOfClass:[NSNull class]]) {
                return [weakSelf errorWithMessageType:DVSValidatorMessageTypeRequired];
            }
            return (NSError *)nil;
        }];
        return self;
    };
}

- (DVSPropertyValidator *(^)(NSObject *, DVSComparisionOperator))compareTo {
    __weak typeof(self) weakSelf = self;
    
    return ^(NSObject *compareObject, DVSComparisionOperator comparisionOperator) {
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

- (DVSPropertyValidator *(^)())emailSyntax {
    __weak typeof(self) weakSelf = self;
    
    return ^() {
        [self.validators addObject:^(NSString *value) {
            
            if (![weakSelf isObject:value kindOfClass:[NSString class]]) {
                return (NSError *)nil;
            } else if (![value dvs_isEmail]) {
                return [weakSelf errorWithMessageType:DVSValidatorMessageTypeSyntaxEmail];
            }
            return (NSError *)nil;
        }];
        return self;
    };
}

- (DVSPropertyValidator *(^)())decimal {
    __weak typeof(self) weakSelf = self;
    
    return ^() {
        [self.validators addObject:^(NSString *value) {
            
            if (![weakSelf isObject:value kindOfClass:[NSString class]]) {
                return (NSError *)nil;
            } else if (![value dvs_isDecimal]) {
                return [weakSelf errorWithMessageType:DVSValidatorMessageTypeDecimal];
            }
            return (NSError *)nil;
        }];
        return self;
    };
}

- (DVSPropertyValidator *(^)(NSUInteger min, NSUInteger max))lengthRange {
    __weak typeof(self) weakSelf = self;
    
    return ^(NSUInteger min, NSUInteger max) {
        [self.validators addObject:^(NSString *value) {
            
            if (![weakSelf isObject:value kindOfClass:[NSString class]]) {
                return (NSError *)nil;
            } else if (value.length < min) {
                return [weakSelf errorWithMessageType:DVSValidatorMessageTypeTooShort attribute:intToString(min)];
            } else if (value.length > max) {
                return [weakSelf errorWithMessageType:DVSValidatorMessageTypeTooLong attribute:intToString(max)];
            }
            return (NSError *)nil;
        }];
        return self;
    };
}

- (DVSPropertyValidator *(^)(NSUInteger min))minLength {
    __weak typeof(self) weakSelf = self;
    
    return ^(NSUInteger min) {
        [self.validators addObject:^(NSString *value) {
            
            if (![weakSelf isObject:value kindOfClass:[NSString class]]) {
                return (NSError *)nil;
            } else if (value.length < min) {
                return [weakSelf errorWithMessageType:DVSValidatorMessageTypeTooShort attribute:intToString(min)];
            }
            return (NSError *)nil;
        }];
        return self;
    };
}

- (DVSPropertyValidator *(^)(NSUInteger max))maxLength {
    __weak typeof(self) weakSelf = self;
    
    return ^(NSUInteger max) {
        [self.validators addObject:^(NSString *value) {
            
            if (![weakSelf isObject:value kindOfClass:[NSString class]]) {
                return (NSError *)nil;
            } else if (value.length > max) {
                return [weakSelf errorWithMessageType:DVSValidatorMessageTypeTooLong attribute:intToString(max)];
            }
            return (NSError *)nil;
        }];
        return self;
    };
}

- (DVSPropertyValidator *(^)(NSUInteger length))exactLength {
    __weak typeof(self) weakSelf = self;
    
    return ^(NSUInteger length) {
        [self.validators addObject:^(NSString *value) {
            
            if (![weakSelf isObject:value kindOfClass:[NSString class]]) {
                return (NSError *)nil;
            } else if (value.length != length) {
                return [weakSelf errorWithMessageType:DVSValidatorMessageTypeExactLength attribute:intToString(length)];
            }
            return (NSError *)nil;
        }];
        return self;
    };
}

- (DVSPropertyValidator *(^)(NSString *))match {
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *string) {
        [self.validators addObject:^(NSString *value) {
            
            if (![weakSelf isObject:value kindOfClass:[NSString class]]) {
                return (NSError *)nil;
            } else if (![value isEqualToString:string]) {
                return [weakSelf errorWithMessageType:DVSValidatorMessageTypeDoesntMatch attribute:string];
            }
            return (NSError *)nil;
        }];
        return self;
    };
}

#pragma mark NSNumber rules:

- (DVSPropertyValidator *(^)())falseValue {
    __weak typeof(self) weakSelf = self;
    
    return ^() {
        [self.validators addObject:^(NSNumber *value) {
            if (![weakSelf isObject:value kindOfClass:[NSNumber class]]) {
                return (NSError *)nil;
            } else if (![value isEqualToNumber:@(NO)]) {
                return [weakSelf errorWithMessageType:DVSValidatorMessageTypeIsntFalse];
            }
            return (NSError *)nil;
        }];
        return self;
    };
}

- (DVSPropertyValidator *(^)())trueValue {
    __weak typeof(self) weakSelf = self;
    
    return ^() {
        [self.validators addObject:^(NSNumber *value) {
            if (![weakSelf isObject:value kindOfClass:[NSNumber class]]) {
                return (NSError *)nil;
            } else if (![value isEqualToNumber:@(YES)]) {
                return [weakSelf errorWithMessageType:DVSValidatorMessageTypeIsntTrue];
            }
            return (NSError *)nil;
        }];
        return self;
    };
}

- (DVSPropertyValidator *(^)(NSInteger))min {
    __weak typeof(self) weakSelf = self;
    
    return ^(NSInteger min) {
        [self.validators addObject:^(NSNumber *value) {
            
            if (![weakSelf isObject:value kindOfClass:[NSNumber class]]) {
                return (NSError *)nil;
            } else if (value.floatValue < min) {
                return [weakSelf errorWithMessageType:DVSValidatorMessageTypeTooSmall attribute:intToString(min)];
            }
            return (NSError *)nil;
        }];
        return self;
    };
}

- (DVSPropertyValidator *(^)(NSInteger))max {
    __weak typeof(self) weakSelf = self;
    
    return ^(NSInteger max) {
        [self.validators addObject:^(NSNumber *value) {
            
            if (![weakSelf isObject:value kindOfClass:[NSNumber class]]) {
                return (NSError *)nil;
            } else if (value.floatValue > max) {
                return [weakSelf errorWithMessageType:DVSValidatorMessageTypeTooBig attribute:intToString(max)];
            }
            return (NSError *)nil;
        }];
        return self;
    };
}

- (DVSPropertyValidator *(^)(NSInteger, NSInteger))range {
    __weak typeof(self) weakSelf = self;
    
    return ^(NSInteger min, NSInteger max) {
        [self.validators addObject:^(NSString *value) {
            
            if (![weakSelf isObject:value kindOfClass:[NSNumber class]]) {
                return (NSError *)nil;
            } else if (value.floatValue < min) {
                return [weakSelf errorWithMessageType:DVSValidatorMessageTypeTooSmall attribute:intToString(min)];
            } else if (value.floatValue > max) {
                return [weakSelf errorWithMessageType:DVSValidatorMessageTypeTooBig attribute:intToString(max)];
            }
            return (NSError *)nil;
        }];
        return self;
    };
}

- (DVSPropertyValidator *(^)(NSInteger))exact {
    __weak typeof(self) weakSelf = self;
    
    return ^(NSInteger exact) {
        [self.validators addObject:^(NSNumber *value) {
            
            if (![weakSelf isObject:value kindOfClass:[NSNumber class]]) {
                return (NSError *)nil;
            } else if (![value compare:@(exact)] == NSOrderedSame) {
                return [weakSelf errorWithMessageType:DVSValidatorMessageTypeExact attribute:intToString(exact)];
            }
            return (NSError *)nil;
        }];
        return self;
    };
}

#pragma mark - Private Methods

- (NSError *)compareNumber:(NSNumber *)number toNumber:(NSNumber *)compareNumber usingOperator:(DVSComparisionOperator)comparisionOperator {
    
    if (![self isObject:compareNumber kindOfClass:[NSNumber class]]) {
        return nil;
    }
    
    NSString *attribute = compareNumber.stringValue;
    switch (comparisionOperator) {
        case DVSComparisionOperatorEqual:
            if (![number isEqualToNumber:compareNumber]) {
                return [self errorWithMessageType:DVSValidatorMessageTypeEqual attribute:attribute];
            } break;
        case DVSComparisionOperatorNotEqual:
            if ([number isEqualToNumber:compareNumber]) {
                return [self errorWithMessageType:DVSValidatorMessageTypeNotEqual attribute:attribute];
            } break;
        case DVSComparisionOperatorLessThan:
            if (![number dvs_isLessThan:compareNumber]) {
                return [self errorWithMessageType:DVSValidatorMessageTypeLessThan attribute:attribute];
            } break;
        case DVSComparisionOperatorGreaterThan:
            if (![number dvs_isGreaterThan:compareNumber]) {
                return [self errorWithMessageType:DVSValidatorMessageTypeGreaterThan attribute:attribute];
            } break;
        case DVSComparisionOperatorLessThanOrEqualTo:
            if (![number dvs_isLessThanOrEqualTo:compareNumber]) {
                return [self errorWithMessageType:DVSValidatorMessageTypeLessThanOrEqualTo attribute:attribute];
            } break;
        case DVSComparisionOperatorGreaterThanOrEqualTo:
            if (![number dvs_isGreaterThanOrEqualTo:compareNumber]) {
                return [self errorWithMessageType:DVSValidatorMessageTypeGreaterThanOrEqualTo attribute:attribute];
            } break;
    }
    return nil;
}

- (NSError *)compareDate:(NSDate *)date toDate:(NSDate *)compareDate usingOperator:(DVSComparisionOperator)comparisionOperator {
    
    if (![self isObject:compareDate kindOfClass:[NSDate class]]) {
        return nil;
    }
    
    NSString *attribute = [self.dateFormatter stringFromDate:compareDate];
    switch (comparisionOperator) {
        case DVSComparisionOperatorEqual:
            if (![date isEqual:compareDate]) {
                return [self errorWithMessageType:DVSValidatorMessageTypeEqual attribute:attribute];
            } break;
        case DVSComparisionOperatorNotEqual:
            if ([date isEqualToDate:compareDate]) {
                return [self errorWithMessageType:DVSValidatorMessageTypeNotEqual attribute:attribute];
            } break;
        case DVSComparisionOperatorLessThan:
            if (![date dvs_isEarlierThan:compareDate]) {
                return [self errorWithMessageType:DVSValidatorMessageTypeLessThan attribute:attribute];
            } break;
        case DVSComparisionOperatorGreaterThan:
            if (![date dvs_isLaterThan:compareDate]) {
                return [self errorWithMessageType:DVSValidatorMessageTypeGreaterThan attribute:attribute];
            } break;
        case DVSComparisionOperatorLessThanOrEqualTo:
            if (![date dvs_isEarlierThanOrEqualTo:compareDate]) {
                return [self errorWithMessageType:DVSValidatorMessageTypeLessThanOrEqualTo attribute:attribute];
            } break;
        case DVSComparisionOperatorGreaterThanOrEqualTo:
            if (![date dvs_isLaterThanOrEqualTo:compareDate]) {
                return [self errorWithMessageType:DVSValidatorMessageTypeGreaterThanOrEqualTo attribute:attribute];
            } break;
    }
    return nil;
}

- (NSString *)messageForMessageType:(DVSValidatorMessageType)messageType {
    return self.validatorMessages[@(messageType)];
}

- (void)setMessage:(NSString *)message forMessageType:(DVSValidatorMessageType)messageType {
    self.validatorMessages[@(messageType)] = message;
}

- (NSError *)errorWithMessageType:(DVSValidatorMessageType)type attribute:(NSString *)attribute {
    NSString *propertyName = [self messageForMessageType:DVSValidatorMessageTypeLocalizedPropertyName];
    NSString *description = [NSString stringWithFormat:@"%@ %@", propertyName, [self messageForMessageType:type]];
    if (attribute) {
        description = [description stringByReplacingOccurrencesOfString:dvs_attribute withString:attribute];
    }
    return [NSError dvs_errorWithDescription:description code:DVSErrorValidationFailed];
}


- (NSError *)errorWithMessageType:(DVSValidatorMessageType)type {
    return [self errorWithMessageType:type attribute:nil];
}

- (BOOL)isObject:(NSObject *)object kindOfClass:(Class)class {
    
    if (object == nil) {
        NSString *message = [NSString stringWithFormat:@"Cannot validate %@ property when is nil. Validation skipped", self.propertyName];
        [[DVSConfiguration sharedConfiguration] logMessage:message];
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
    [self setMessage:@"cannot be nil or empty" forMessageType:DVSValidatorMessageTypeRequired];
    [self setMessage:_propertyName forMessageType:DVSValidatorMessageTypeLocalizedPropertyName];
    // NSString:
    [self setMessage:@"is too short. Should be min {attribute} signs." forMessageType:DVSValidatorMessageTypeTooShort];
    [self setMessage:@"is too long. Should be max {attribute} signs." forMessageType:DVSValidatorMessageTypeTooLong];
    [self setMessage:@"hasn't exact length. Should has {attribute} signs." forMessageType:DVSValidatorMessageTypeExactLength];
    [self setMessage:@"has invalid email syntax" forMessageType:DVSValidatorMessageTypeSyntaxEmail];
    [self setMessage:@"isn't decimal" forMessageType:DVSValidatorMessageTypeDecimal];
    [self setMessage:@"doesn't match {attribute}" forMessageType:DVSValidatorMessageTypeDoesntMatch];
    
    // NSNumber:
    [self setMessage:@"is too small. Should be min {attribute}." forMessageType:DVSValidatorMessageTypeTooSmall];
    [self setMessage:@"is too big. Should be max {attribute}." forMessageType:DVSValidatorMessageTypeTooBig];
    [self setMessage:@"should be true." forMessageType:DVSValidatorMessageTypeIsntTrue];
    [self setMessage:@"should be false." forMessageType:DVSValidatorMessageTypeIsntFalse];
    [self setMessage:@"isn't exact. Should be {attribute}." forMessageType:DVSValidatorMessageTypeExact];
    
    // Two NSObjects comparision:
    [self setMessage:@"isn't equal to {attribute}" forMessageType:DVSValidatorMessageTypeEqual];
    [self setMessage:@"is equal to {attribute}" forMessageType:DVSValidatorMessageTypeNotEqual];
    [self setMessage:@"is greater than or equal to {attribute}. Should be less than {attribute}." forMessageType:DVSValidatorMessageTypeLessThan];
    [self setMessage:@"is less than or equal to {attribute}. Should be greater than {attribute}." forMessageType:DVSValidatorMessageTypeGreaterThan];
    [self setMessage:@"is greater than {attribute}. Should be less or equal to {attribute}." forMessageType:DVSValidatorMessageTypeLessThanOrEqualTo];
    [self setMessage:@"is less than {attribute}. Should be greater or equal to {attribute}." forMessageType:DVSValidatorMessageTypeGreaterThanOrEqualTo];
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
