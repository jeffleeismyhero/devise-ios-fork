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

SPEC_BEGIN(SSKValidatorSpec)

describe(@"SSKValidator", ^{

    typedef void (^SSKValidationTestBlock)(NSString *, NSArray *, void(^)(SSKPropertyValidator *));
    SSKValidationTestBlock testValidation = ^(NSString *name, NSArray *rules, void(^configureBlock)(SSKPropertyValidator *)) {

        describe([NSString stringWithFormat:@"%@ validator", name], ^{

            __block SSKPropertyValidator *validator = nil;
            __block SSKValidationTestModel *model = nil;

            beforeEach(^{
                model = [[SSKValidationTestModel alloc] init];
                validator = [SSKPropertyValidator validatorForPropertyName:@"value"];
            });

            specify(^{
                [[validator shouldNot] beNil];
            });

            for (NSDictionary *rule in rules) {

                context([NSString stringWithFormat:@"using %@", rule[@"name"]], ^{

                    beforeEach(^{
                        configureBlock(validator);
                        model.value = rule[@"value"];
                    });

                    NSArray *(^rulesBlock)() = ^NSArray *{
                        return @[ validator ];
                    };

                    if ([rule[@"valid"] isEqualToNumber:@YES]) {

                        it(@"should succeed", ^{
                            BOOL success = NO; NSError *error = nil;
                            success = [SSKValidator validateModel:model error:&error usingRules:rulesBlock];
                            [[theValue(success) should] beYes];
                            [[error should] beNil];
                        });

                    } else {

                        it(@"should fail", ^{
                            BOOL success = NO; NSError *error = nil;
                            success = [SSKValidator validateModel:model error:&error usingRules:rulesBlock];
                            [[theValue(success) should] beNo];
                            [[error shouldNot] beNil];
                        });

                    }

                });

            }

        });

    };

    // /////////////////////////////////////////////////////////////////////////

    testValidation(@"required", @[
        @{
            @"name": @"no value",
            @"valid": @NO,
        },
        @{
            @"name": @"any value",
            @"value": @"qux",
            @"valid": @YES,
        },
    ], ^(SSKPropertyValidator *validator) {
        validator.required();
    });

    testValidation(@"emailSyntax", @[
        @{
            @"name": @"email with invalid syntax",
            @"value": @"foo~bar",
            @"valid": @NO,
        },
        @{
            @"name": @"email with valid syntax",
            @"value": @"john.appleseed@apple.com",
            @"valid": @YES,
        },
    ], ^(SSKPropertyValidator *validator) {
        validator.emailSyntax();
    });

});

SPEC_END
