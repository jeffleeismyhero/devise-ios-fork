//
//  SSKValidatorSpec.m
//  SaasKit
//
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "SSKSampleValidateModel.h"

SPEC_BEGIN(SSKValidatorSpec)

describe(@"SSKValidator", ^{
    
    __block SSKSampleValidateModel *model = nil;
    
    context(@"when newly instantiated", ^{
        __block SSKValidator *validator = nil;
        
        beforeEach(^{
            validator = [[SSKValidator alloc] init];
        });
        
        it(@"should not be nil", ^{
            [[validator shouldNot] beNil];
        });
    });
    
    context(@"when model has been initialized", ^{
        
        beforeEach(^{
            model = [[SSKSampleValidateModel alloc] init];
        });
        
        it(@"should not be nil", ^{
            [[model shouldNot] beNil];
        });
        
        it(@"all properties should be nil", ^{
            [[model.string should] beNil];
            [[model.stringToCompare should] beNil];
            [[model.number should] beNil];
            [[model.numberToCompare should] beNil];
        });
    });
    
    context(@"validate model to first error", ^{
        
        __block NSArray *(^rules)(void) = nil;
        
        void (^performValidation)(void(^)(BOOL, NSError *)) = ^(void(^completion)(BOOL, NSError *)) {
            NSError *validationError;
            BOOL success = [SSKValidator validateModel:model withError:&validationError rules:rules];
            completion(success, validationError);
        };
        
        void (^assertValidationShouldPass)() = ^{
            __block BOOL success = NO; __block NSError *error = nil;
            performValidation(^(BOOL inputSuccess, NSError *inputError) {
                success = inputSuccess;
                error = inputError;
            });
            [[expectFutureValue(theValue(success)) shouldEventually] beYes];
            [[expectFutureValue(error) shouldEventually] beNil];
        };
        
        void (^assertValidationShouldFail)() = ^{
            __block BOOL success = NO; __block NSError *error = nil;
            performValidation(^(BOOL inputSuccess, NSError *inputError) {
                success = inputSuccess;
                error = inputError;
            });
            [[expectFutureValue(theValue(success)) shouldEventually] beNo];
            [[expectFutureValue(error) shouldEventually] beNonNil];
        };
        
        beforeEach(^{
            model = [[SSKSampleValidateModel alloc] init];
            rules = nil;
        });
        
        context(@"using no email", ^{
            
            beforeEach(^{
                rules = ^{
                    return @[validate(@"string").required()];
                };
            });

            it(@"should fail", ^{
                assertValidationShouldFail();
            });
        });
        
        context(@"using wrong email syntax", ^{
            
            beforeEach(^{
                model.string = @"jappleseed@";
                rules = ^{
                    return @[validate(@"string").emailSyntax()];
                };
            });
            
            it(@"should fail", ^{
                assertValidationShouldFail();
            });
        });
        
        context(@"using correct email syntax", ^{
            
            beforeEach(^{
                model.string = @"jappleseed@apple.com";
                rules = ^{
                    return @[validate(@"string").emailSyntax()];
                };
            });
            
            it(@"should pass", ^{
                assertValidationShouldPass();
            });
        });
    });
});

SPEC_END
