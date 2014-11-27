//
//  SSKPropertyValidator.h
//  SaasKit
//
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSKPropertyValidator : NSObject

+ (SSKPropertyValidator *)validatorForPropertyName:(NSString *)propertyName;

#pragma mark - Validators Rules:
#pragma mark NSObject:

@property (nonatomic, readonly, copy) SSKPropertyValidator *(^required)();

#pragma mark NSString:

/// Validates that the NSString has email syntax.
@property (nonatomic, readonly, copy) SSKPropertyValidator *(^emailSyntax)();

/// Validates that the NSString contains only decimal chars.
@property (nonatomic, readonly, copy) SSKPropertyValidator *(^decimal)();

/// Validates that the NSString has minimum length (inclusive).
@property (nonatomic, readonly, copy) SSKPropertyValidator *(^minLength)(NSUInteger min);

/// Validates that the NSString has maximum length (inclusive).
@property (nonatomic, readonly, copy) SSKPropertyValidator *(^maxLength)(NSUInteger min);

/// Validates that the NSString length is between minimum and maximum (inclusive).
@property (nonatomic, readonly, copy) SSKPropertyValidator *(^lengthRange)(NSUInteger min, NSUInteger max);

/// Validates that the NSString has exact length (inclusive).
@property (nonatomic, readonly, copy) SSKPropertyValidator *(^exactLength)(NSUInteger length);

#pragma mark NSNumber:

/// Validates that the NSNumber represents false status.
@property (nonatomic, readonly, copy) SSKPropertyValidator *(^falseValue)();

/// Validates that the NSNumber represents true status.
@property (nonatomic, readonly, copy) SSKPropertyValidator *(^trueValue)();

/// Validates lower limit of NSNumber (inclusive).
@property (nonatomic, readonly, copy) SSKPropertyValidator *(^min)(NSInteger min);

/// Validates upper limit of NSNumber (inclusive).
@property (nonatomic, readonly, copy) SSKPropertyValidator *(^max)(NSInteger max);

/// Validates that the NSNumber value is between minimum and maximum (inclusive).
@property (nonatomic, readonly, copy) SSKPropertyValidator *(^range)(NSInteger min, NSInteger max);

/// Validates exact value of NSNumber.
@property (nonatomic, readonly, copy) SSKPropertyValidator *(^exact)(NSInteger exact);

#pragma mark - Validator Messages:

/// User-defined error message used when the property is nil (default: cannot be nil or empty).
@property (nonatomic, readonly, copy) SSKPropertyValidator *(^nilOrEmpty)(NSString *message);

/// User-defined localized property name. Used in error localized description (default: same as propertyName).
@property (nonatomic, readonly, copy) SSKPropertyValidator *(^localizedPropertyName)(NSString *name);

/// User-defined error message used when the property has invalid email syntax (default: has invalid email syntax).
@property (nonatomic, readonly, copy) SSKPropertyValidator *(^isntEmail)(NSString *name);

/// User-defined error message used when the property isn't decimal (default: isn't decimal).
@property (nonatomic, readonly, copy) SSKPropertyValidator *(^isntDecimal)(NSString *name);

/// User-defined error message used when the property length is too short (default: is too short. Should be min {attribute} signs.).
@property (nonatomic, readonly, copy) SSKPropertyValidator *(^tooShort)(NSString *message);

/// User-defined error message usesd when the property length is too long (default: is too long. Should be max {attribute} signs.).
@property (nonatomic, readonly, copy) SSKPropertyValidator *(^tooLong)(NSString *message);

/// User-defined error message usesd when the property hasn't exact length (default: hasn't exact length. Should has {attribute} signs.).
@property (nonatomic, readonly, copy) SSKPropertyValidator *(^notExactLength)(NSString *message);

/// User-defined error message used when the property value isn't false (default: should be false).
@property (nonatomic, readonly, copy) SSKPropertyValidator *(^isntFalse)(NSString *message);

/// User-defined error message used when the property value isn't true (default: should be true).
@property (nonatomic, readonly, copy) SSKPropertyValidator *(^isntTrue)(NSString *message);

/// User-defined error message used when the property value is too small (default: is too small. Should be min {attribute}.).
@property (nonatomic, readonly, copy) SSKPropertyValidator *(^tooSmall)(NSString *message);

/// User-defined error message usesd when the property value is too big (default: is too big. Should be max {attribute}.).
@property (nonatomic, readonly, copy) SSKPropertyValidator *(^tooBig)(NSString *message);

/// User-defined error message usesd when the property value isn't exact (default: isn't exact. Should be {attribute}.).
@property (nonatomic, readonly, copy) SSKPropertyValidator *(^notExact)(NSString *message);

/// Name of validated property
@property (strong, readonly, nonatomic) NSString *propertyName;

/// 
- (NSError *)validateValue:(id)value;

@end
