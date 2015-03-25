//
//  DVSHTTPClientUserSpec.m
//
//  Copyright 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSHTTPClient+User.h"
#import "DVSTestConfiguration.h"
#import "DVSTestUser.h"

SPEC_BEGIN(DVSHTTPClientUserSpec)

describe(@"DVSHTTPClient+User", ^{

    __block DVSHTTPClient *client = nil;
    __block DVSTestConfiguration *configuration = nil;
    __block DVSTestUser *user = nil;

    beforeEach(^{
        NSURL *serverURL = [NSURL URLWithString:@"http://devise-tests/"];
        configuration = [[DVSTestConfiguration alloc] initWithServerURL:serverURL appendPathComponents:NO];
        client = [[DVSHTTPClient alloc] initWithConfiguration:configuration];
        user = [[DVSTestUser alloc] init];
    });

    describe(@"registering a user", ^{

        __block id<OHHTTPStubsDescriptor> stub = nil;

        beforeAll(^{
            stub = [OHHTTPStubs dvs_stubUserRegisterRequestsWithOptions:nil];
        });

        afterAll(^{
            [OHHTTPStubs removeStub:stub];
        });

        context(@"using correct data", ^{

            beforeEach(^{
                user.email = @"john.appleseed@example.com";
                user.password = @"$eCR3t";
            });

            it(@"should succeed", ^{
                __block BOOL success = NO;
                [client registerUser:user success:^(DVSUser *user) {
                    success = YES;
                } failure:nil];
                [[expectFutureValue(theValue(success)) shouldEventually] beTrue];
            });

            it(@"should fill the user object", ^{
                [client registerUser:user success:nil failure:nil];
                [[expectFutureValue(user.identifier) shouldEventually] beNonNil];
                [[expectFutureValue(user.sessionToken) shouldEventually] beNonNil];
            });

        });

    });

    describe(@"logging in a user", ^{

        __block id<OHHTTPStubsDescriptor> stub = nil;

        beforeAll(^{
            stub = [OHHTTPStubs dvs_stubUserLogInRequestsWithOptions:nil];
        });

        afterAll(^{
            [OHHTTPStubs removeStub:stub];
        });

        context(@"using correct data", ^{

            beforeEach(^{
                user.email = @"john.appleseed@example.com";
                user.password = @"$eCR3t";
            });

            it(@"should succeed", ^{
                __block BOOL success = NO;
                [client logInUser:user success:^(DVSUser *user) {
                    success = YES;
                } failure:nil];
                [[expectFutureValue(theValue(success)) shouldEventually] beTrue];
            });

            it(@"should fill the user object", ^{
                [client logInUser:user success:nil failure:nil];
                [[expectFutureValue(user.identifier) shouldEventually] beNonNil];
                [[expectFutureValue(user.sessionToken) shouldEventually] beNonNil];
            });

        });

    });

    describe(@"updating a user", ^{

        __block id<OHHTTPStubsDescriptor> stub = nil;

        beforeAll(^{
            stub = [OHHTTPStubs dvs_stubUserUpdateRequestsWithOptions:nil];
        });

        afterAll(^{
            [OHHTTPStubs removeStub:stub];
        });

        context(@"when authorized", ^{

            beforeEach(^{
                user.identifier = @"1";
                user.email = @"john.appleseed@example.com";
                user.sessionToken = @"xXx_s3ss10N_t0K3N_xXx";
            });

            context(@"using correct data", ^{

                beforeEach(^{
                    user.email = @"john.appleseed@example2.com";
                });

                it(@"should succeed", ^{
                    __block BOOL success = NO;
                    [client updateUser:user success:^(DVSUser *user) {
                        success = YES;
                    } failure:nil];
                    [[expectFutureValue(theValue(success)) shouldEventually] beTrue];
                });

            });

        });
        
    });

    describe(@"deleting a user", ^{

        __block id<OHHTTPStubsDescriptor> stub = nil;

        beforeAll(^{
            stub = [OHHTTPStubs dvs_stubUserDeleteRequestsWithOptions:nil];
        });

        afterAll(^{
            [OHHTTPStubs removeStub:stub];
        });

        context(@"when authorized", ^{

            beforeEach(^{
                user.identifier = @"1";
                user.email = @"john.appleseed@example.com";
                user.sessionToken = @"xXx_s3ss10N_t0K3N_xXx";
            });

            context(@"using correct data", ^{

                it(@"should succeed", ^{
                    __block BOOL success = NO;
                    [client deleteUser:user success:^{
                        success = YES;
                    } failure:nil];
                    [[expectFutureValue(theValue(success)) shouldEventually] beTrue];
                });
                
            });

        });
        
    });

    describe(@"changing password of a user", ^{

        __block id<OHHTTPStubsDescriptor> stub = nil;

        beforeAll(^{
            stub = [OHHTTPStubs dvs_stubUserChangePasswordRequestsWithOptions:nil];
        });

        afterAll(^{
            [OHHTTPStubs removeStub:stub];
        });

        context(@"when authorized", ^{

            beforeEach(^{
                user.identifier = @"1";
                user.email = @"john.appleseed@example.com";
                user.sessionToken = @"xXx_s3ss10N_t0K3N_xXx";
            });

            context(@"using correct data", ^{

                beforeEach(^{
                    user.password = @"n3w_$eCR3t";
                });

                it(@"should succeed", ^{
                    __block BOOL success = NO;
                    [client changePasswordOfUser:user success:^(DVSUser *user) {
                        success = YES;
                    } failure:nil];
                    [[expectFutureValue(theValue(success)) shouldEventually] beTrue];
                });

            });

        });
        
    });

    describe(@"reminding password to a user", ^{

        __block id<OHHTTPStubsDescriptor> stub = nil;

        beforeAll(^{
            stub = [OHHTTPStubs dvs_stubUserRemindPasswordRequestsWithOptions:nil];
        });

        afterAll(^{
            [OHHTTPStubs removeStub:stub];
        });

        context(@"using correct data", ^{

            beforeEach(^{
                user.email = @"john.appleseed@example.com";
            });

            it(@"should succeed", ^{
                __block BOOL success = NO;
                [client remindPasswordToUser:user success:^{
                    success = YES;
                } failure:nil];
                [[expectFutureValue(theValue(success)) shouldEventually] beTrue];
            });

        });

    });

});

SPEC_END
