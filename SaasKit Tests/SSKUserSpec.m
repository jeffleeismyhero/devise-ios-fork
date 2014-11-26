//
//  SSKUserSpec.m
//
//  Copyright 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "SSKAPIManager.h"

SPEC_BEGIN(SSKUserSpec)

describe(@"SSKUser", ^{

    __block SSKConfiguration *configuration = nil;
    __block SSKUser *user = nil;

    beforeEach(^{

        NSURL *serverURL = [NSURL URLWithString:@"http://httpbin.org"];
        configuration = [[SSKConfiguration alloc] initWithServerURL:serverURL];
        [SSKConfiguration stub:@selector(sharedConfiguration) andReturn:configuration];

        user = [SSKUser user];
        user.username = @"foo";
        user.password = @"bar";
        
    });

    specify(^{
        [[user shouldNot] beNil];
    });

    context(@"when reminding password", ^{

        beforeEach(^{
            SEL selector = @selector(remindPasswordForUser:withSuccess:failure:);
            [SSKAPIManager stub:selector withBlock:^id(NSArray *params) {
                if (params.count >= 2) {
                    SSKVoidBlock successBlock = params[1];
                    successBlock();
                }
                return nil;
            }];
        });

        void (^performRemindPassword)(BOOL *, NSError **) = ^(BOOL *success, NSError **error) {
            __block BOOL blockSuccess = NO;
            __block NSError *blockError = nil;
            [user remindPasswordWithSuccess:^{
                blockSuccess = YES;
                blockError = nil;
            } failure:^(NSError *error) {
                blockSuccess = NO;
                blockError = error;
            }];
            if (success != NULL) *success = blockSuccess;
            if (error != NULL) *error = blockError;
        };

        context(@"when email is incorrect", ^{

            beforeEach(^{
                user.email = @"baz";
            });

            it(@"should fail to remind password", ^{
                __block NSError *error = nil;
                __block BOOL success = NO;
                performRemindPassword(&success, &error);
                [[expectFutureValue(theValue(success)) should] beNo];
                [[expectFutureValue(error) shouldNot] beNil];
            });

        });

        context(@"when email is correct", ^{

            beforeEach(^{
                user.email = @"john.appleseed@example.com";
            });

            it(@"should fail to remind password", ^{
                __block NSError *error = nil;
                __block BOOL success = NO;
                performRemindPassword(&success, &error);
                [[expectFutureValue(theValue(success)) should] beYes];
                [[expectFutureValue(error) should] beNil];
            });
            
        });

    });

});

SPEC_END
