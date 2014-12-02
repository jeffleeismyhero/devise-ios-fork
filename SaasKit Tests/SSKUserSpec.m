//
//  SSKUserSpec.m
//
//  Copyright 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "SSKAPIManager.h"

SPEC_BEGIN(SSKUserSpec)

describe(@"SSKUser", ^{

    __block SSKConfiguration *configuration = nil;

    NSString *validUsername = @"jappleseed";
    NSString *validEmail = @"john.appleseed@apple.com";
    NSString *validPassword = @"$ecr3t";

    beforeEach(^{
        configuration = [[SSKConfiguration alloc] initWithServerURL:[OHHTTPStubs ssk_stubURL]];
        [SSKConfiguration stub:@selector(sharedConfiguration) andReturn:configuration];
    });

    describe(@"logging in", ^{

        __block SSKUser *user = nil;
        __block id<OHHTTPStubsDescriptor> routeStub = nil;

        void (^performLogin)(void(^)(BOOL, NSError *)) = ^(void(^completion)(BOOL, NSError *)) {
            [user loginWithSuccess:^{
                if (completion != nil) completion(YES, nil);
            } failure:^(NSError *error) {
                if (completion != nil) completion(NO, error);
            }];
        };

        void (^assertLoginShouldSucceed)() = ^{
            __block BOOL success = NO; __block NSError *error = nil;
            performLogin(^(BOOL inputSuccess, NSError *inputError) {
                success = inputSuccess;
                error = inputError;
            });
            [[expectFutureValue(theValue(success)) shouldEventually] beYes];
            [[expectFutureValue(error) shouldEventually] beNil];
        };

        void (^assertLoginShouldFail)() = ^{
            __block BOOL success = NO; __block NSError *error = nil;
            performLogin(^(BOOL inputSuccess, NSError *inputError) {
                success = inputSuccess;
                error = inputError;
            });
            [[expectFutureValue(theValue(success)) shouldEventually] beNo];
            [[expectFutureValue(error) shouldEventually] beNonNil];
        };

        beforeAll(^{
            routeStub = [OHHTTPStubs ssk_stubLoginRouteWithOptions:@{
                @"allowedUsername": validUsername,
                @"allowedEmail": validEmail,
                @"allowedPassword": validPassword,
            }];
        });

        afterAll(^{
            [OHHTTPStubs removeStub:routeStub];
        });

        beforeEach(^{
            user = [SSKUser user];
        });

        context(@"using email with incorrect syntax", ^{

            beforeEach(^{
                user.loginMethod = SSKLoginMethodEmail;
                user.email = @"qux";
                user.password = validPassword;
            });

            it(@"should fail", ^{
                assertLoginShouldFail();
            });

        });

        context(@"using no email or username", ^{

            beforeEach(^{
                user.password = validPassword;
            });

            it(@"should fail", ^{
                assertLoginShouldFail();
            });

        });

        context(@"using no password", ^{

            beforeEach(^{
                user.username = validUsername;
                user.email = validEmail;
            });

            it(@"should fail", ^{
                assertLoginShouldFail();
            });

        });

        context(@"using incorrect username", ^{

            beforeEach(^{
                user.loginMethod = SSKLoginMethodUsername;
                user.username = @"foo";
                user.password = validPassword;
            });

            it(@"should fail", ^{
                assertLoginShouldFail();
            });

        });

        context(@"using incorrect email", ^{

            beforeEach(^{
                user.loginMethod = SSKLoginMethodEmail;
                user.email = @"john.smith@apple.com";
                user.password = validPassword;
            });

            it(@"should fail", ^{
                assertLoginShouldFail();
            });
            
        });

        context(@"using incorrect password", ^{

            beforeEach(^{
                user.username = validUsername;
                user.email = validEmail;
                user.password = @"baz";
            });

            it(@"should fail", ^{
                assertLoginShouldFail();
            });
            
        });

        context(@"using correct username and password", ^{

            beforeEach(^{
                user.loginMethod = SSKLoginMethodUsername;
                user.username = validUsername;
                user.password = validPassword;
            });

            it(@"should succeed", ^{
                assertLoginShouldSucceed();
            });

        });

        context(@"using correct email and password", ^{

            beforeEach(^{
                user.loginMethod = SSKLoginMethodEmail;
                user.email = validEmail;
                user.password = validPassword;
            });

            it(@"should succeed", ^{
                assertLoginShouldSucceed();
            });
            
        });

    });

    describe(@"reminding password", ^{

        __block SSKUser *user = nil;
        __block id<OHHTTPStubsDescriptor> routeStub = nil;

        void (^performForgotPassword)(void(^)(BOOL, NSError *)) = ^(void(^completion)(BOOL, NSError *)) {
            [user remindPasswordWithSuccess:^{
                if (completion != nil) completion(YES, nil);
            } failure:^(NSError *error) {
                if (completion != nil) completion(NO, error);
            }];
        };

        void (^assertRemindPasswordShouldSucceed)() = ^{
            __block BOOL success = NO; __block NSError *error = nil;
            performForgotPassword(^(BOOL inputSuccess, NSError *inputError) {
                success = inputSuccess;
                error = inputError;
            });
            [[expectFutureValue(theValue(success)) shouldEventually] beYes];
            [[expectFutureValue(error) shouldEventually] beNil];
        };

        void (^assertRemindPasswordShouldFail)() = ^{
            __block BOOL success = NO; __block NSError *error = nil;
            performForgotPassword(^(BOOL inputSuccess, NSError *inputError) {
                success = inputSuccess;
                error = inputError;
            });
            [[expectFutureValue(theValue(success)) shouldEventually] beNo];
            [[expectFutureValue(error) shouldEventually] beNonNil];
        };

        beforeAll(^{
            routeStub = [OHHTTPStubs ssk_stubForgotPasswordRouteWithOptions:@{
                @"allowedEmail": validEmail,
            }];
        });
        
        afterAll(^{
            [OHHTTPStubs removeStub:routeStub];
        });
        
        beforeEach(^{
            user = [SSKUser user];
        });

        context(@"using no email", ^{

            it(@"should fail", ^{
                assertRemindPasswordShouldFail();
            });

        });

        context(@"using email with invalid syntax", ^{

            beforeEach(^{
                user.email = @"fox";
            });

            it(@"should fail", ^{
                assertRemindPasswordShouldFail();
            });
            
        });

        context(@"using incorrect email", ^{

            beforeEach(^{
                user.email = @"john.smith@apple.com";
            });

            it(@"should fail", ^{
                assertRemindPasswordShouldFail();
            });
            
        });

        context(@"using valid email", ^{

            beforeEach(^{
                user.email = validEmail;
            });

            it(@"should succeed", ^{
                assertRemindPasswordShouldSucceed();
            });
            
        });

    });

    describe(@"registration", ^{

        __block SSKUser *user = nil;
        __block id<OHHTTPStubsDescriptor> routeStub = nil;

        void (^performRegisterPassword)(void(^)(BOOL, NSError *)) = ^(void(^completion)(BOOL, NSError *)) {
            [user registerWithSuccess:^{
                if (completion != nil) completion(YES, nil);
            } failure:^(NSError *error) {
                if (completion != nil) completion(NO, error);
            }];
        };

        void (^assertRegisterShouldSucceed)() = ^{
            __block BOOL success = NO; __block NSError *error = nil;
            performRegisterPassword(^(BOOL inputSuccess, NSError *inputError) {
                success = inputSuccess;
                error = inputError;
            });
            [[expectFutureValue(theValue(success)) shouldEventually] beYes];
            [[expectFutureValue(error) shouldEventually] beNil];
        };

        void (^assertRegisterShouldFail)() = ^{
            __block BOOL success = NO; __block NSError *error = nil;
            performRegisterPassword(^(BOOL inputSuccess, NSError *inputError) {
                success = inputSuccess;
                error = inputError;
            });
            [[expectFutureValue(theValue(success)) shouldEventually] beNo];
            [[expectFutureValue(error) shouldEventually] beNonNil];
        };

        beforeAll(^{
            routeStub = [OHHTTPStubs ssk_stubRegisterRouteWithOptions:nil];
        });

        afterAll(^{
            [OHHTTPStubs removeStub:routeStub];
        });

        beforeEach(^{
            user = [SSKUser user];
        });

        context(@"using no email", ^{

            beforeEach(^{
                user.username = validUsername;
                user.password = validPassword;
            });

            it(@"should fail", ^{
                assertRegisterShouldFail();
            });
            
        });

        context(@"using email with invalid syntax", ^{

            beforeEach(^{
                user.email = @"dog";
                user.username = validUsername;
                user.password = validPassword;
            });

            it(@"should fail", ^{
                assertRegisterShouldFail();
            });
            
        });

        context(@"using no username", ^{

            beforeEach(^{
                user.email = validEmail;
                user.password = validPassword;
            });

            it(@"should fail", ^{
                assertRegisterShouldFail();
            });
            
        });

        context(@"using no password", ^{

            beforeEach(^{
                user.email = validEmail;
                user.username = validUsername;
            });

            it(@"should fail", ^{
                assertRegisterShouldFail();
            });
            
        });

        context(@"using correct data", ^{

            beforeEach(^{
                user.email = validEmail;
                user.username = validUsername;
                user.password = validPassword;
            });

            it(@"should succeed", ^{
                assertRegisterShouldSucceed();
            });
            
        });

    });

});

SPEC_END
