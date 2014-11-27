//
//  SSKPropertyValidator.h
//  SaasKit
//
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SSKSyntax) {
    SSKSyntaxEmail
};

@interface SSKPropertyValidator : NSObject

+ (SSKPropertyValidator *)validatorForPropertyName:(NSString *)propertyName;

#pragma mark - Validators Rules (NSObject):

@property (nonatomic, readonly, copy) SSKPropertyValidator *(^required)();
@property (nonatomic, readonly, copy) SSKPropertyValidator *(^hasSyntax)(SSKSyntax);

#pragma mark - Validators Rules (NSString):

@property (nonatomic, readonly, copy) SSKPropertyValidator *(^lengthRange)(NSUInteger min, NSUInteger max);

#pragma mark - Validator Messages:

/// User-defined error message used when the value is too short (default: is too short).
@property (nonatomic, readonly, copy) SSKPropertyValidator *(^tooShort)(NSString *message);
/// User-defined error message usesd when the value is too long (default: is too long).
@property (nonatomic, readonly, copy) SSKPropertyValidator *(^tooLong)(NSString *message);
/// User-defined error message used when the value is nil (default: cannot be nil or empty).
@property (nonatomic, readonly, copy) SSKPropertyValidator *(^nilOrEmpty)(NSString *message);
/// User-defined error message used when the value is nil (default: has invalid syntax).
@property (nonatomic, readonly, copy) SSKPropertyValidator *(^invalidSyntax)(SSKSyntax syntax, NSString *message);
/// User-defined localized property name. Used in error localized description (default: same as propertyName).
@property (nonatomic, readonly, copy) SSKPropertyValidator *(^localizedPropertyName)(NSString *name);

@property (strong, readonly, nonatomic) NSString *propertyName;

- (NSDictionary *)messages;
- (NSError *)validateValue:(id)value;

@end
