//
//  SSKValidatorSpec.m
//
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "SSKValidator.h"

@interface SSKValidationTestModel : NSObject
@property (unsafe_unretained, nonatomic) id value;
@end @implementation SSKValidationTestModel @end

// /////////////////////////////////////////////////////////////////////////////

#define kValue @"value"
#define kValid @"valid"
#define kName @"name"
#define kErrorsNumber @"errorsNumber"
#define kExpectedClass @"expectedClass"
#define kNULL [NSNull null]

SPEC_BEGIN(SSKValidatorSpec)

describe(@"SSKValidator", ^{
    
#pragma mark - Implementation:

    typedef void (^SSKValidationTestBlock)(NSString *, NSArray *, void(^)(SSKPropertyValidator *));
    SSKValidationTestBlock testValidation = ^(NSString *name, NSArray *rules, void(^configureBlock)(SSKPropertyValidator *)) {

        describe([NSString stringWithFormat:@"%@ validator", name], ^{

            __block SSKPropertyValidator *validator = nil;
            __block SSKValidationTestModel *model = nil;

            beforeEach(^{
                model = [[SSKValidationTestModel alloc] init];
                validator = [SSKPropertyValidator validatorForPropertyName:kValue];
            });

            specify(^{
                [[validator shouldNot] beNil];
            });

            for (NSDictionary *rule in rules) {

                context([NSString stringWithFormat:@"using %@", rule[kName]], ^{
                    
                    __block BOOL success; __block  NSError *error; __block NSArray *array;
                    
                    beforeEach(^{
                        configureBlock(validator);
                        model.value = rule[kValue];
                        success = NO; error = nil; array = nil;
                    });

                    NSArray *(^rulesBlock)() = ^NSArray *{
                        return @[validator];
                    };
                    
                    if(![rule[kValue] isKindOfClass:rule[kExpectedClass]]) {
                        
                        it(@"should not accept class other than specified", ^{
                            [[theBlock(^{
                                [SSKValidator validateModel:model error:&error usingRules:rulesBlock];
                            }) should] raiseWithName:NSInternalInconsistencyException];
                            
                            [[theBlock(^{
                                [SSKValidator validateModel:model usingRules:rulesBlock];
                            }) should] raiseWithName:NSInternalInconsistencyException];
                        });
                        
                    } else if ([rule[kValid] isEqualToNumber:@YES]) {
                        
                        it(@"should succeed", ^{
                            success = [SSKValidator validateModel:model error:&error usingRules:rulesBlock];
                            array = [SSKValidator validateModel:model usingRules:rulesBlock];
                            
                            [[theValue(success) should] beYes];
                            [[error should] beNil];
                            [[array should] haveCountOf:[rule[kErrorsNumber] integerValue]];
                        });
                        
                    } else {
                        
                        it(@"should fail", ^{
                            success = [SSKValidator validateModel:model error:&error usingRules:rulesBlock];
                            array = [SSKValidator validateModel:model usingRules:rulesBlock];
                            
                            [[theValue(success) should] beNo];
                            [[error shouldNot] beNil];
                            [[array should] haveCountOf:[rule[kErrorsNumber] integerValue]];
                        });
                    }
                });
            }
        });
    };
    
    typedef NSDictionary * (^SSKValidationRulesBlock)(NSString *, NSObject *, BOOL, NSUInteger, Class);
    SSKValidationRulesBlock rule = ^(NSString *name, NSObject * value, BOOL valid, NSUInteger errors, Class expectedClass) {
        return @{kValue : value, kName : name, kValid : @(valid), kErrorsNumber : @(errors), kExpectedClass : expectedClass};
    };
    
#pragma mark - Actual tests:
    
    testValidation(@"any string", @[
         rule(@"incorrect defined class", @123, NO, 1, [NSString class]),
         rule(@"correct defined class", @"123", YES, 0, [NSString class]),
     ], ^(SSKPropertyValidator *validator) {
         validator.decimal();
     });
    
    testValidation(@"required", @[
        rule(@"no value", kNULL, NO, 1, [NSNull class]),
        rule(@"any value", @"qux", YES, 0, [NSString class])
    ], ^(SSKPropertyValidator *validator) {
        validator.required();
    });

    testValidation(@"emailSyntax", @[
        rule(@"email with invalid syntax", @"foo~", NO, 1, [NSString class]),
        rule(@"email with valid syntax", @"john.appleseed@apple.com", YES, 0, [NSString class])
    ], ^(SSKPropertyValidator *validator) {
        validator.emailSyntax();
    });
    
    testValidation(@"decimal", @[
         rule(@"invalid decimal", @"123ewq", NO, 1, [NSString class]),
         rule(@"valid decimal", @"123567", YES, 0, [NSString class]),
     ], ^(SSKPropertyValidator *validator) {
         validator.required().decimal();
     });
    
    testValidation(@"minLength", @[
         rule(@"too short string", @"veryShoryString", NO, 1, [NSString class]),
         rule(@"string with required length", @"this_string_should_pass_the_test", YES, 0, [NSString class]),
     ], ^(SSKPropertyValidator *validator) {
         validator.required().minLength(20);
     });
    
    testValidation(@"maxLength", @[
         rule(@"string with required length", @"this_string_should_not_pass_the_test", NO, 1, [NSString class]),
         rule(@"too long string", @"veryShoryString", YES, 0, [NSString class]),
     ], ^(SSKPropertyValidator *validator) {
         validator.required().maxLength(20);
     });
});

SPEC_END
