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

@interface SSKPropertyValidator ()

@property (strong, nonatomic) NSMutableArray *validators;
@property (strong, nonatomic) NSMutableDictionary *syntaxMessages;
@property (strong, nonatomic) NSString *tooShortMessage;
@property (strong, nonatomic) NSString *tooLongMessage;
@property (strong, nonatomic) NSString *nilMessage;
@property (strong, nonatomic) NSString *localizedName;

@end

@implementation SSKPropertyValidator

#pragma mark - Initializers

- (instancetype)initWithPropertyName:(NSString *)propertyName {
    self = [super init];
    if (self) {
        NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@\""];
        _propertyName = [propertyName stringByTrimmingCharactersInSet:set];
        _validators = [NSMutableArray array];
        _tooShortMessage = @"is too short";
        _tooLongMessage = @"is too long";
        _nilMessage = @"cannot be nil";
        [self setMessage:@"has invalid syntax" forInvalidSyntax:SSKSyntaxEmail];
    }
    return self;
}

+ (SSKPropertyValidator *)validatorForPropertyName:(NSString *)propertyName {
    return [[[self class] alloc] initWithPropertyName:propertyName];
}

#pragma mark - public methods

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
        self.tooShortMessage = message;
        return self;
    };
}

- (SSKPropertyValidator *(^)(NSString *))tooLong {
    return ^(NSString *message) {
        self.tooLongMessage = message;
        return self;
    };
}

- (SSKPropertyValidator *(^)(NSString *))isNil {
    return ^(NSString *message) {
        self.nilMessage = message;
        return self;
    };
}

- (SSKPropertyValidator *(^)(SSKSyntax, NSString *))syntaxMsg {
    return ^(SSKSyntax syntax, NSString *message) {
        [self setMessage:message forInvalidSyntax:syntax];
        return self;
    };
}

- (SSKPropertyValidator *(^)(NSString *))localizedPropertyName {
    return ^(NSString *name) {
        self.localizedName = name;
        return self;
    };
}

#pragma mark - Validators Rules

- (SSKPropertyValidator *(^)())required {
    __weak typeof(self)weakSelf = self;
    
    return ^() {
        [self.validators addObject:^(NSObject *value) {
            if (!value) {
                return [weakSelf errorWithMessage:weakSelf.nilMessage];
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
            
            [weakSelf requiredClass:[NSString class] ofObject:value];
            if (value.length < min) {
                return [weakSelf errorWithMessage:weakSelf.tooShortMessage];
            } else if (value.length > max) {
                return [weakSelf errorWithMessage:weakSelf.tooLongMessage];
            }
            return (NSError *)nil;
        }];
        return self;
    };
}

- (SSKPropertyValidator *(^)(SSKSyntax))syntax {
    __weak typeof(self)weakSelf = self;
    
    return ^(SSKSyntax syntax) {
        [self.validators addObject:^(NSString *value) {
            
            [weakSelf requiredClass:[NSString class] ofObject:value];
            switch (syntax) {
                case SSKSyntaxEmail:
                    if (![value ssk_isEmail]) {
                        return [weakSelf errorWithMessage:[weakSelf messageForInvalidSyntax:syntax]];
                    }
                    break;
            }
            return (NSError *)nil;
        }];
        return self;
    };
}

#pragma mark - private methods

- (NSError *)errorWithMessage:(NSString *)message {
    NSString *description = [NSString stringWithFormat:@"%@ %@", self.localizedName ?: self.propertyName, message];
    return [NSError ssk_errorWithDescription:description code:SSKErrorValidationFailed];
}

- (NSString *)messageForInvalidSyntax:(SSKSyntax)syntax {
    return self.syntaxMessages[@(syntax)];
}

- (void)setMessage:(NSString *)message forInvalidSyntax:(SSKSyntax)syntax {
    self.syntaxMessages[@(syntax)] = message;
}

- (NSMutableDictionary *)syntaxMessages {
    if (_syntaxMessages != nil) return _syntaxMessages;
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    _syntaxMessages = dictionary;
    return _syntaxMessages;
}

- (void)requiredClass:(Class)class ofObject:(NSObject *)object {
    NSAssert3([object isKindOfClass:class], @"Parameter %@(%@ class) is not kind of class %@", object, [object class], class);
}

@end
