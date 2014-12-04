//
//  DVSValidatorSpec.m
//
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSPropertyValidator.h"

#define kPropertyName @"property"
#define KBlockMessage @"foo"

SPEC_BEGIN(DVSPropertyValidatorSpec)

describe(@"DVSPropertyValidator", ^{
    
    __block DVSPropertyValidator *propertyValidator;

    beforeEach(^{
        propertyValidator = [DVSPropertyValidator validatorForPropertyName:kPropertyName];
    });
    
    specify(^{
        [[propertyValidator shouldNot] beNil];
    });
    
    specify(^{
        [[propertyValidator.dateFormatter shouldNot] beNil];
    });
    
    it(@"should property name be equal to inited one", ^{
        [[theValue(propertyValidator.propertyName) should] equal:theValue(kPropertyName)];
    });
    
    it(@"should validator date formatter have short time style", ^{
        [[theValue(propertyValidator.dateFormatter.timeStyle) should] equal:theValue(NSDateFormatterShortStyle)];
    });
    
    it(@"should validator date formatter have short date style", ^{
        [[theValue(propertyValidator.dateFormatter.dateStyle) should] equal:theValue(NSDateFormatterShortStyle)];
    });
    
    it(@"should have exactly 19 messages", ^{
        [[propertyValidator.errorDescriptions should] haveCountOf:19];
    });
    
    it(@"should save custom message using property accessors", ^{
        [propertyValidator setMessage:@"bar" forErrorDescription:DVSErrorDescriptionRequired];
        NSString *description = [propertyValidator messageforErrorDescription:DVSErrorDescriptionRequired];
        [[description should] equal:@"bar"];
    });
    
    context(@"when change date formatter date and time style to NSDateFormatterLongStyle", ^{
        
        beforeEach(^{
            propertyValidator.dateFormatter.dateStyle = NSDateFormatterLongStyle;
            propertyValidator.dateFormatter.timeStyle = NSDateFormatterLongStyle;
        });
        
        it(@"should have date style be equal to NSDateFormatterLongStyle", ^{
            [[theValue(propertyValidator.dateFormatter.dateStyle) should] equal:theValue(NSDateFormatterLongStyle)];
        });
        
        it(@"should have time style be equal to NSDateFormatterLongStyle", ^{
            [[theValue(propertyValidator.dateFormatter.timeStyle) should] equal:theValue(NSDateFormatterLongStyle)];
        });
    });

    
    typedef void (^DVSPropertyErrorDescriptionBlock)(NSString *, DVSErrorDescription, DVSPropertyValidator *);
    DVSPropertyErrorDescriptionBlock testMessage = ^(NSString *name, DVSErrorDescription errorDescription, DVSPropertyValidator *validator) {
        
        describe([NSString stringWithFormat:@"should save custom message for %@ description", name], ^{
            
            it(@"using block", ^{
                [[[validator messageforErrorDescription:errorDescription] should] equal:KBlockMessage];
            });
        });
    };

    DVSPropertyValidator *validator = [DVSPropertyValidator validatorForPropertyName:kPropertyName];
    testMessage(@"required", DVSErrorDescriptionRequired, validator.nilOrEmpty(KBlockMessage));
    testMessage(@"localizedPropertyName", DVSErrorDescriptionLocalizedPropertyName, validator.localizedPropertyName(KBlockMessage));
    testMessage(@"isntEmail", DVSErrorDescriptionSyntaxEmail, validator.isntEmail(KBlockMessage));
    testMessage(@"isntDecimal", DVSErrorDescriptionDecimal, validator.isntDecimal(KBlockMessage));
    testMessage(@"tooShort", DVSErrorDescriptionTooShort, validator.tooShort(KBlockMessage));
    testMessage(@"tooLong", DVSErrorDescriptionTooLong, validator.tooLong(KBlockMessage));
    testMessage(@"notExactLength", DVSErrorDescriptionExactLength, validator.notExactLength(KBlockMessage));
    testMessage(@"doesntMatch", DVSErrorDescriptionDoesntMatch, validator.doesntMatch(KBlockMessage));
    testMessage(@"isntFalse", DVSErrorDescriptionIsntFalse, validator.isntFalse(KBlockMessage));
    testMessage(@"isntTrue", DVSErrorDescriptionIsntTrue, validator.isntTrue(KBlockMessage));
    testMessage(@"tooSmall", DVSErrorDescriptionTooSmall, validator.tooSmall(KBlockMessage));
    testMessage(@"tooBig", DVSErrorDescriptionTooBig, validator.tooBig(KBlockMessage));
    testMessage(@"notExact", DVSErrorDescriptionExact, validator.notExact(KBlockMessage));
    testMessage(@"isntEqual", DVSErrorDescriptionEqual, validator.isntEqual(KBlockMessage));
    testMessage(@"isEqual", DVSErrorDescriptionNotEqual, validator.isEqual(KBlockMessage));
    testMessage(@"isntGreater", DVSErrorDescriptionGreaterThan, validator.isntGreater(KBlockMessage));
    testMessage(@"isntLess", DVSErrorDescriptionLessThan, validator.isntLess(KBlockMessage));
    testMessage(@"isntGreaterOrEqual", DVSErrorDescriptionGreaterThanOrEqualTo, validator.isntGreaterOrEqual(KBlockMessage));
    testMessage(@"isntLessOrEqual", DVSErrorDescriptionLessThanOrEqualTo, validator.isntLessOrEqual(KBlockMessage));
    
    it(@"all messages should be custom", ^{
        NSArray *keys = [validator errorDescriptions].allKeys;
        for(NSString *key in keys) {
            [[[validator errorDescriptions][key] should] equal:KBlockMessage];
        }
    });
});

SPEC_END