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
        [[user class] removeLocalUser];
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
                user.email = @"john.appleseed@apple.com";
                user.password = @"$eCR3t";
            });

            it(@"should succeed", ^{
                __block BOOL success = NO;
                [client registerUser:user success:^{
                    success = YES;
                } failure:nil];
                [[expectFutureValue(theValue(success)) shouldEventually] beTrue];
            });

            it(@"should fill the user object", ^{
                [client registerUser:user success:nil failure:nil];
                [[expectFutureValue(user.identifier) shouldEventually] beNonNil];
                [[expectFutureValue(user.sessionToken) shouldEventually] beNonNil];
            });

            it(@"should save the user locally", ^{
                [client registerUser:user success:nil failure:nil];
                [[expectFutureValue([[user class] localUser]) shouldEventually] beIdenticalTo:user];
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
                user.email = @"john.appleseed@apple.com";
                user.password = @"$eCR3t";
            });

            it(@"should succeed", ^{
                __block BOOL success = NO;
                [client logInUser:user success:^{
                    success = YES;
                } failure:nil];
                [[expectFutureValue(theValue(success)) shouldEventually] beTrue];
            });

            it(@"should fill the user object", ^{
                [client logInUser:user success:nil failure:nil];
                [[expectFutureValue(user.identifier) shouldEventually] beNonNil];
                [[expectFutureValue(user.sessionToken) shouldEventually] beNonNil];
            });

            it(@"should save the user locally", ^{
                [client logInUser:user success:nil failure:nil];
                [[expectFutureValue([[user class] localUser]) shouldEventually] beIdenticalTo:user];
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
                user.email = @"john.appleseed@apple.com";
                user.sessionToken = @"xXx_s3ss10N_t0K3N_xXx";
                [[user class] setLocalUser:user];
            });

            context(@"using correct data", ^{

                beforeEach(^{
                    user.email = @"john.appleseed@microsoft.com";
                });

                it(@"should succeed", ^{
                    __block BOOL success = NO;
                    [client updateUser:user success:^{
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
                user.email = @"john.appleseed@apple.com";
                user.sessionToken = @"xXx_s3ss10N_t0K3N_xXx";
                [[user class] setLocalUser:user];
            });

            context(@"using correct data", ^{

                it(@"should succeed", ^{
                    __block BOOL success = NO;
                    [client deleteUser:user success:^{
                        success = YES;
                    } failure:nil];
                    [[expectFutureValue(theValue(success)) shouldEventually] beTrue];
                });

                it(@"should remove the locally saved user", ^{
                    [client deleteUser:user success:nil failure:nil];
                    [[expectFutureValue([[user class] localUser]) shouldEventually] beNil];
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
                user.email = @"john.appleseed@apple.com";
                user.sessionToken = @"xXx_s3ss10N_t0K3N_xXx";
                [[user class] setLocalUser:user];
            });

            context(@"using correct data", ^{

                beforeEach(^{
                    user.password = @"n3w_$eCR3t";
                });

                it(@"should succeed", ^{
                    __block BOOL success = NO;
                    [client changePasswordOfUser:user success:^{
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
                user.email = @"john.appleseed@apple.com";
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
