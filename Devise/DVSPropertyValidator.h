//
//  DVSPropertyValidator.h
//  Devise
//
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DVSComparisionOperator) {
    DVSComparisionOperatorEqual,
    DVSComparisionOperatorNotEqual,
    DVSComparisionOperatorLessThan,
    DVSComparisionOperatorGreaterThan,
    DVSComparisionOperatorLessThanOrEqualTo,
    DVSComparisionOperatorGreaterThanOrEqualTo
};

typedef NS_ENUM(NSInteger, DVSErrorDescription) {
    //overall messages:
    DVSErrorDescriptionRequired,
    DVSErrorDescriptionLocalizedPropertyName,
    //NSString messages:
    DVSErrorDescriptionSyntaxEmail,
    DVSErrorDescriptionTooShort,
    DVSErrorDescriptionTooLong,
    DVSErrorDescriptionExactLength,
    DVSErrorDescriptionDecimal,
    DVSErrorDescriptionDoesntMatch,
    //NSNumber messages:
    DVSErrorDescriptionIsntFalse,
    DVSErrorDescriptionIsntTrue,
    DVSErrorDescriptionTooSmall,
    DVSErrorDescriptionTooBig,
    DVSErrorDescriptionExact,
    //Compare messages:
    DVSErrorDescriptionEqual,
    DVSErrorDescriptionNotEqual,
    DVSErrorDescriptionLessThan,
    DVSErrorDescriptionGreaterThan,
    DVSErrorDescriptionLessThanOrEqualTo,
    DVSErrorDescriptionGreaterThanOrEqualTo
};

@interface DVSPropertyValidator : NSObject

+ (DVSPropertyValidator *)validatorForPropertyName:(NSString *)propertyName;

#pragma mark - Validators Rules:

/// Validates that the NSObject is not nil
@property (nonatomic, readonly, copy) DVSPropertyValidator *(^required)();

/// Validates 2 object by comparing them to eachother. Compare operation is specified by DVSComparisionOperator. Use only to compare NSDates or NSNumbers objects.
@property (nonatomic, readonly, copy) DVSPropertyValidator *(^compareTo)(NSObject *comparedObject, DVSComparisionOperator comparisionOperator);

#pragma mark NSString:

/// Validates that the NSString has email syntax.
@property (nonatomic, readonly, copy) DVSPropertyValidator *(^emailSyntax)();

/// Validates that the NSString contains only decimal chars.
@property (nonatomic, readonly, copy) DVSPropertyValidator *(^decimal)();

/// Validates that the NSString has minimum length (inclusive).
@property (nonatomic, readonly, copy) DVSPropertyValidator *(^minLength)(NSUInteger min);

/// Validates that the NSString has maximum length (inclusive).
@property (nonatomic, readonly, copy) DVSPropertyValidator *(^maxLength)(NSUInteger min);

/// Validates that the NSString length is between minimum and maximum (inclusive).
@property (nonatomic, readonly, copy) DVSPropertyValidator *(^lengthRange)(NSUInteger min, NSUInteger max);

/// Validates that the NSString has exact length (inclusive).
@property (nonatomic, readonly, copy) DVSPropertyValidator *(^exactLength)(NSUInteger length);

/// Validates that the NSString match another string
@property (nonatomic, readonly, copy) DVSPropertyValidator *(^match)(NSString *string);

#pragma mark NSNumber:

/// Validates that the NSNumber represents false status.
@property (nonatomic, readonly, copy) DVSPropertyValidator *(^falseValue)();

/// Validates that the NSNumber represents true status.
@property (nonatomic, readonly, copy) DVSPropertyValidator *(^trueValue)();

/// Validates lower limit of NSNumber (inclusive).
@property (nonatomic, readonly, copy) DVSPropertyValidator *(^min)(NSInteger min);

/// Validates upper limit of NSNumber (inclusive).
@property (nonatomic, readonly, copy) DVSPropertyValidator *(^max)(NSInteger max);

/// Validates that the NSNumber value is between minimum and maximum (inclusive).
@property (nonatomic, readonly, copy) DVSPropertyValidator *(^range)(NSInteger min, NSInteger max);

/// Validates exact value of NSNumber.
@property (nonatomic, readonly, copy) DVSPropertyValidator *(^exact)(NSInteger exact);

#pragma mark - Validator Messages:

/// User-defined error message used when the property is nil (default: cannot be nil or empty).
/// Equivalent to setting a message by [setMessage:forErrorDescription:] method with DVSErrorDescriptionRequired.
@property (nonatomic, readonly, copy) DVSPropertyValidator *(^nilOrEmpty)(NSString *message);

/// User-defined localized property name. Used in error localized description (default: same as propertyName).
/// Equivalent to setting a message by [setMessage:forErrorDescription:] method with DVSErrorDescriptionLocalizedPropertyName.
@property (nonatomic, readonly, copy) DVSPropertyValidator *(^localizedPropertyName)(NSString *name);

/// User-defined error message used when the string property has invalid email syntax (default: has invalid email syntax).
/// Equivalent to setting a message by [setMessage:forErrorDescription:] method with DVSErrorDescriptionSyntaxEmail.
@property (nonatomic, readonly, copy) DVSPropertyValidator *(^isntEmail)(NSString *name);

/// User-defined error message used when the string property isn't decimal (default: isn't decimal).
/// Equivalent to setting a message by [setMessage:forErrorDescription:] method with DVSErrorDescriptionDecimal.
@property (nonatomic, readonly, copy) DVSPropertyValidator *(^isntDecimal)(NSString *name);

/// User-defined error message used when the property length is too short (default: is too short. Should be min {attribute} signs.).
/// Equivalent to setting a message by [setMessage:forErrorDescription:] method with DVSErrorDescriptionTooShort.
@property (nonatomic, readonly, copy) DVSPropertyValidator *(^tooShort)(NSString *message);

/// User-defined error message used when the property length is too long (default: is too long. Should be max {attribute} signs.).
/// Equivalent to setting a message by [setMessage:forErrorDescription:] method with DVSErrorDescriptionTooLong.
@property (nonatomic, readonly, copy) DVSPropertyValidator *(^tooLong)(NSString *message);

/// User-defined error message used when the property hasn't exact length (default: hasn't exact length. Should has {attribute} signs.).
/// Equivalent to setting a message by [setMessage:forErrorDescription:] method with DVSErrorDescriptionExactLength.
@property (nonatomic, readonly, copy) DVSPropertyValidator *(^notExactLength)(NSString *message);

/// User-defined error message used when the property doesn't match another string (doesn't match {attribute}.).
/// Equivalent to setting a message by [setMessage:forErrorDescription:] method with DVSErrorDescriptionDoesntMatch.
@property (nonatomic, readonly, copy) DVSPropertyValidator *(^doesntMatch)(NSString *message);

/// User-defined error message used when the property value isn't false (default: should be false).
/// Equivalent to setting a message by [setMessage:forErrorDescription:] method with DVSErrorDescriptionIsntFalse.
@property (nonatomic, readonly, copy) DVSPropertyValidator *(^isntFalse)(NSString *message);

/// User-defined error message used when the property value isn't true (default: should be true).
/// Equivalent to setting a message by [setMessage:forErrorDescription:] method with DVSErrorDescriptionIsntTrue.
@property (nonatomic, readonly, copy) DVSPropertyValidator *(^isntTrue)(NSString *message);

/// User-defined error message used when the property value is too small (default: is too small. Should be min {attribute}.).
/// Equivalent to setting a message by [setMessage:forErrorDescription:] method with DVSErrorDescriptionTooSmall.
@property (nonatomic, readonly, copy) DVSPropertyValidator *(^tooSmall)(NSString *message);

/// User-defined error message used when the property value is too big (default: is too big. Should be max {attribute}.).
/// Equivalent to setting a message by [setMessage:forErrorDescription:] method with DVSErrorDescriptionTooBig.
@property (nonatomic, readonly, copy) DVSPropertyValidator *(^tooBig)(NSString *message);

/// User-defined error message used when the property value isn't exact (default: isn't exact. Should be {attribute}.).
/// Equivalent to setting a message by [setMessage:forErrorDescription:] method with DVSErrorDescriptionExact.
@property (nonatomic, readonly, copy) DVSPropertyValidator *(^notExact)(NSString *message);

/// User-defined error message used when the property value isn't equal (default: isn't equal to {attribute}.).
/// Equivalent to setting a message by [setMessage:forErrorDescription:] method with DVSErrorDescriptionEqual.
@property (nonatomic, readonly, copy) DVSPropertyValidator *(^isntEqual)(NSString *message);

/// User-defined error message used when the property value is equal (default: is equal to {attribute}.).
/// Equivalent to setting a message by [setMessage:forErrorDescription:] method with DVSErrorDescriptionNotEqual.
@property (nonatomic, readonly, copy) DVSPropertyValidator *(^isEqual)(NSString *message);

/// User-defined error message used when the property value isn't equal (default: is less than or equal to {attribute}. Should be greater than {attribute}.).
/// Equivalent to setting a message by [setMessage:forErrorDescription:] method with DVSErrorDescriptionGreaterThan.
@property (nonatomic, readonly, copy) DVSPropertyValidator *(^isntGreater)(NSString *message);

/// User-defined error message used when the property value isn't equal (default: is greater than or equal to {attribute}. Should be less than {attribute}.).
/// Equivalent to setting a message by [setMessage:forErrorDescription:] method with DVSErrorDescriptionLessThan.
@property (nonatomic, readonly, copy) DVSPropertyValidator *(^isntLess)(NSString *message);

/// User-defined error message used when the property value isn't equal (default: is less than {attribute}. Should be greater or equal to {attribute}.).
/// Equivalent to setting a message by [setMessage:forErrorDescription:] method with DVSErrorDescriptionGreaterThanOrEqualTo.
@property (nonatomic, readonly, copy) DVSPropertyValidator *(^isntGreaterOrEqual)(NSString *message);

/// User-defined error message used when the property value isn't equal (default: is greater than {attribute}. Should be less or equal to {attribute}.).
/// Equivalent to setting a message by [setMessage:forErrorDescription:] method with DVSErrorDescriptionLessThanOrEqualTo.
@property (nonatomic, readonly, copy) DVSPropertyValidator *(^isntLessOrEqual)(NSString *message);

/// Name of validated property
@property (strong, readonly, nonatomic) NSString *propertyName;

/// Date formatter used in formating date in compareTo validation (2 NSDates). Default dateStyle and timeStyle is NSDateFormatterShortStyle.
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

/// Returns a message for given error description
///
/// @param errorDescription The error description, for which you want to get the message.
- (NSString *)messageforErrorDescription:(DVSErrorDescription)errorDescription;

/// Sets a message for the given error description
///
/// @param message The message you want to set.
/// @param errorDescription The error description, for which you want to get the message.
- (void)setMessage:(NSString *)message forErrorDescription:(DVSErrorDescription)errorDescription;

/// Dictionary of error descriptions used by validator
- (NSDictionary *)errorDescriptions;

/// Validates value to first error
- (NSError *)simpleValidationOfValue:(id)value;

/// Validates value and gather all possible errors
- (NSArray *)complexValidationOfValue:(id)value;

@end
