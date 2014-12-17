//
//  DVSUserSpec.m
//
//  Copyright 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSTestConfiguration.h"
#import "DVSTestUser.h"

SPEC_BEGIN(DVSUserSpec)

describe(@"DVSUser", ^{

    context(@"when newly initialized", ^{

        __block DVSUser *user = nil;

        beforeEach(^{
            user = [[DVSUser alloc] init];
        });

        it(@"should use a shared configuration", ^{
            [[[[user class] configuration] should] beIdenticalTo:[DVSConfiguration sharedConfiguration]];
        });

    });

    __block DVSTestConfiguration *configuration = nil;
    __block DVSTestUser *user = nil;

    beforeEach(^{
        NSURL *serverURL = [NSURL URLWithString:@"http://devise-tests/"];
        configuration = [[DVSTestConfiguration alloc] initWithServerURL:serverURL appendPathComponents:NO];
        [[user class] setConfiguration:configuration];
        user = [[DVSTestUser alloc] init];
    });

    describe(@"logging in", ^{

        __block id<OHHTTPStubsDescriptor> stub = nil;

        beforeAll(^{
            stub = [OHHTTPStubs dvs_stubUserRegisterRequestsWithOptions:nil];
        });

        afterAll(^{
            [OHHTTPStubs removeStub:stub];
        });

        context(@"using correct data", ^{
            
            beforeEach(^{
                user.email = @"john.appleseed@apple.com";
                user.password = @"$eCR3t";
            });

            it(@"should succeed", ^{
                __block BOOL success = NO;
                [user registerWithSuccess:^{
                    success = YES;
                } failure:nil];
                [[expectFutureValue(theValue(success)) shouldEventually] beTrue];
            });

            it(@"shoud fill the user object", ^{
                [user registerWithSuccess:nil failure:nil];
                [[expectFutureValue(user.identifier) shouldEventually] beNonNil];
                [[expectFutureValue(user.sessionToken) shouldEventually] beNonNil];
            });

            it(@"should save the user locally", ^{
                [user registerWithSuccess:nil failure:nil];
                [[expectFutureValue([[user class] localUser]) shouldEventually] beIdenticalTo:user];
            });

        });

        describe(@"validation", ^{

            context(@"using no email", ^{

                beforeEach(^{
                    user.password = @"$eCR3t";
                });

                it(@"should fail", ^{
                    __block BOOL failure = NO;
                    [user registerWithSuccess:nil failure:^(NSError *error) {
                        failure = YES;
                    }];
                    [[expectFutureValue(theValue(failure)) shouldEventually] beTrue];
                });

            });

            context(@"using email with invalid syntax", ^{

                beforeEach(^{
                    user.email = @"john.appleseed.apple.com";
                    user.password = @"$eCR3t";
                });

                it(@"should fail", ^{
                    __block BOOL failure = NO;
                    [user registerWithSuccess:nil failure:^(NSError *error) {
                        failure = YES;
                    }];
                    [[expectFutureValue(theValue(failure)) shouldEventually] beTrue];
                });
                
            });

            context(@"using no password", ^{

                beforeEach(^{
                    user.email = @"john.appleseed@apple.com";
                });

                it(@"should fail", ^{
                    __block BOOL failure = NO;
                    [user registerWithSuccess:nil failure:^(NSError *error) {
                        failure = YES;
                    }];
                    [[expectFutureValue(theValue(failure)) shouldEventually] beTrue];
                });
                
            });

        });

    });

});

SPEC_END
