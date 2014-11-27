//
//  SSKPropertyValidator.m
//  SaasKit
//
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "SSKPropertyValidator.h"
#import "NSError+SassKit.h"
#import "SSKTypedefs.h"
#import "NSString+SassKit.h"
#import "SSKConfiguration.h"

typedef NS_ENUM(NSInteger, SSKValidatorMessageType) {
    SSKValidatorMessageTypeTooShort,
    SSKValidatorMessageTypeTooLong,
    SSKValidatorMessageTypeRequired,
    SSKValidatorMessageTypePropertyName,
    SSKValidatorMessageTypeSyntaxEmail,
    SSKValidatorMessageTypeLocalizedPropertyName,
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
        [self setMessage:@"is too short" forMessageType:SSKValidatorMessageTypeTooShort];
        [self setMessage:@"is too long" forMessageType:SSKValidatorMessageTypeTooLong];
        [self setMessage:@"cannot be nil or empty" forMessageType:SSKValidatorMessageTypeRequired];
        [self setMessage:@"has invalid syntax" forMessageType:SSKValidatorMessageTypeSyntaxEmail];
        [self setMessage:_propertyName forMessageType:SSKValidatorMessageTypeLocalizedPropertyName];
    }
    return self;
}

+ (SSKPropertyValidator *)validatorForPropertyName:(NSString *)propertyName {
    return [[[self class] alloc] initWithPropertyName:propertyName];
}

#pragma mark - Public Methods

- (NSError *)validateValue:(id)value {
    for (SSKValidationBlock block in self.validators) {
        NSError *error = block(value);
        if (error) {
            return error;
        }
    }
    return nil;
}

#pragma - Validator Messages

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

- (SSKPropertyValidator *(^)(NSString *))nilOrEmpty {
    return ^(NSString *message) {
        [self setMessage:message forMessageType:SSKValidatorMessageTypeRequired];
        return self;
    };
}

- (SSKPropertyValidator *(^)(SSKSyntax, NSString *))invalidSyntax {
    return ^(SSKSyntax syntax, NSString *message) {
        
        SSKValidatorMessageType type;
        switch (syntax) {
            case SSKSyntaxEmail:
                type = SSKValidatorMessageTypeSyntaxEmail;
                break;
                
        }
        [self setMessage:message forMessageType:type];
        return self;
    };
}

- (SSKPropertyValidator *(^)(NSString *))localizedPropertyName {
    return ^(NSString *name) {
        [self setMessage:name forMessageType:SSKValidatorMessageTypeLocalizedPropertyName];
        return self;
    };
}

#pragma mark - Validators Rules

- (SSKPropertyValidator *(^)())required {
    __weak typeof(self)weakSelf = self;
    
    return ^() {
        [self.validators addObject:^(NSObject *value) {
            if (!value) {
                return [weakSelf errorWithMessageType:SSKValidatorMessageTypeRequired];
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
            
            if (![weakSelf hasObject:value requiredClaas:[NSString class]]) {
                return (NSError *)nil;
            } else if (value.length < min) {
                return [weakSelf errorWithMessageType:SSKValidatorMessageTypeTooShort];
            } else if (value.length > max) {
                return [weakSelf errorWithMessageType:SSKValidatorMessageTypeTooLong];
            }
            return (NSError *)nil;
        }];
        return self;
    };
}

- (SSKPropertyValidator *(^)(SSKSyntax))hasSyntax {
    __weak typeof(self)weakSelf = self;
    
    return ^(SSKSyntax syntax) {
        [self.validators addObject:^(NSString *value) {
            
            switch (syntax) {
                case SSKSyntaxEmail:
                    if (![weakSelf hasObject:value requiredClaas:[NSString class]]) {
                        break;
                    }
                    if (![value ssk_isEmail]) {
                        return [weakSelf errorWithMessageType:SSKValidatorMessageTypeSyntaxEmail];
                    }
                    break;
            }
            return (NSError *)nil;
        }];
        return self;
    };
}

#pragma mark - Messages

- (NSDictionary *)messages {
    return [self.validatorMessages copy];
}

- (NSString *)messageForMessageType:(SSKValidatorMessageType)messageType {
    return self.validatorMessages[@(messageType)];
}

- (void)setMessage:(NSString *)message forMessageType:(SSKValidatorMessageType)messageType {
    self.validatorMessages[@(messageType)] = message;
}

#pragma mark - private methods

- (NSError *)errorWithMessageType:(SSKValidatorMessageType)type {
    NSString *propertyName = [self messageForMessageType:SSKValidatorMessageTypeLocalizedPropertyName];
    NSString *description = [NSString stringWithFormat:@"%@ %@", propertyName, [self messageForMessageType:type]];
    return [NSError ssk_errorWithDescription:description code:SSKErrorValidationFailed];
}

- (BOOL)hasObject:(NSObject *)object requiredClaas:(Class)class {
    
    if (object == nil) {
        NSString *message = [NSString stringWithFormat:@"Cannot validate %@ property when is nil. Validation skipped", self.propertyName];
        [[SSKConfiguration sharedConfiguration] logMessage:message];
        return NO;
        
    } else if (![object isKindOfClass:class]) {
        NSAssert3(YES, @"Parameter %@(%@ class) is not kind of class %@", object, [object class], class);
    }
    return YES;
}

@end
