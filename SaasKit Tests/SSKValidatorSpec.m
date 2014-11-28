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
                    
                    beforeEach(^{
                        configureBlock(validator);
                        model.value = rule[kValue];
                    });

                    NSArray *(^rulesBlock)() = ^NSArray *{
                        return @[validator];
                    };

                    if ([rule[kValid] isEqualToNumber:@YES]) {
                        
                        context(@"should success", ^{
                            
                            it(@"using [validateModel:error:usingRules:] method", ^{
                                
                                BOOL success = NO; NSError *error = nil;
                                success = [SSKValidator validateModel:model error:&error usingRules:rulesBlock];
                                [[theValue(success) should] beYes];
                                [[error should] beNil];
                            });
                            
                            it(@"using [validateModel:usingRules:] method", ^{
                                NSArray *array = nil;
                                array = [SSKValidator validateModel:model usingRules:rulesBlock];
                                [[array should] haveCountOf:[rule[kErrorsNumber] integerValue]];
                            });
                            
                        });

                    } else {
                        
                        context(@"should fail", ^{
                            
                            it(@"using [validateModel:error:usingRules:] method", ^{
                                BOOL success = NO; NSError *error = nil;
                                success = [SSKValidator validateModel:model error:&error usingRules:rulesBlock];
                                [[theValue(success) should] beNo];
                                [[error shouldNot] beNil];
                            });
                            
                            it(@"using [validateModel:usingRules:] method", ^{
                                NSArray *array = nil;
                                array = [SSKValidator validateModel:model usingRules:rulesBlock];
                                [[array should] haveCountOf:[rule[kErrorsNumber] integerValue]];
                            });
                            
                        });
                    }
                });
            }
        });
    };
    
    typedef NSDictionary * (^SSKValidationRulesBlock)(NSString *, NSObject *, NSNumber *, NSNumber *);
    SSKValidationRulesBlock rule = ^(NSString *name, NSObject * value, NSNumber *valid, NSNumber *errors) {
        NSMutableDictionary *dictionary = [@{kName : name, kValid : valid, kErrorsNumber : errors} mutableCopy];
        if(![value isKindOfClass:[NSNull class]]) dictionary[kValue] = value;
        return [dictionary copy];
    };
    
#pragma mark - Actual tests:
    
    testValidation(@"any non-required", @[
         rule(@"no value", kNULL, @YES, @(0)),
     ], ^(SSKPropertyValidator *validator) {
         validator.decimal();
     });
    
    testValidation(@"required", @[
        rule(@"no value", kNULL, @NO, @(1)),
        rule(@"any value", @"qux", @YES, @(0))
    ], ^(SSKPropertyValidator *validator) {
        validator.required();
    });

    testValidation(@"emailSyntax", @[
        rule(@"email with invalid syntax", @"foo~", @NO, @(1)),
        rule(@"email with valid syntax", @"john.appleseed@apple.com", @YES, @(0))
    ], ^(SSKPropertyValidator *validator) {
        validator.emailSyntax();
    });
    
    testValidation(@"decimal", @[
         rule(@"invalid decimal", @"123ewq", @NO, @(1)),
         rule(@"valid decimal", @"123567", @YES, @(0)),
     ], ^(SSKPropertyValidator *validator) {
         validator.required().decimal();
     });
    
    testValidation(@"minLength", @[
         rule(@"too short string", @"veryShoryString", @NO, @(1)),
         rule(@"string with required length", @"this_string_should_pass_the_test", @YES, @(0)),
     ], ^(SSKPropertyValidator *validator) {
         validator.required().minLength(20);
     });
    
    testValidation(@"maxLength", @[
         rule(@"string with required length", @"this_string_should_not_pass_the_test", @NO, @(1)),
         rule(@"too long string", @"veryShoryString", @YES, @(0)),
     ], ^(SSKPropertyValidator *validator) {
         validator.required().maxLength(20);
     });
});

SPEC_END
