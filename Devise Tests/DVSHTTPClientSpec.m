//
//  DVSHTTPClientSpec.m
//
//  Copyright 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSHTTPClient.h"

SPEC_BEGIN(DVSHTTPClientSpec)

describe(@"DVSHTTPClient", ^{

    context(@"when newly instantiated", ^{

        __block DVSHTTPClient *client = nil;

        beforeEach(^{
            client = [[DVSHTTPClient alloc] init];
        });

        it(@"should not have any configuration", ^{
            [[client.configuration should] beNil];
        });
        
    });

    context(@"when using a shared instance", ^{

        __block DVSHTTPClient *client = nil;

        beforeEach(^{
            client = [DVSHTTPClient sharedClient];
        });

        it(@"should provide the same instance", ^{
            DVSHTTPClient *secondClient = [DVSHTTPClient sharedClient];
            [[client should] beIdenticalTo:secondClient];
        });

        it(@"should use the shared configuration", ^{
            DVSConfiguration *configuration = [DVSConfiguration sharedConfiguration];
            [[client.configuration should] beIdenticalTo:configuration];
        });

    });

    __block DVSHTTPClient *client = nil;

    beforeEach(^{
        client = [[DVSHTTPClient alloc] init];
    });

    context(@"provided with no configuration", ^{

        it(@"should fail to perform a get request", ^{
            [[theBlock(^{
                [client GET:@"get" parameters:nil completion:nil];
            }) should] raiseWithName:NSInternalInconsistencyException];
        });

        it(@"should fail to perform a post request", ^{
            [[theBlock(^{
                [client POST:@"post" parameters:nil completion:nil];
            }) should] raiseWithName:NSInternalInconsistencyException];
        });

    });

    context(@"provided with a configuration", ^{

        __block DVSConfiguration *configuration = nil;

        beforeEach(^{
            configuration = [[DVSConfiguration alloc] init];
            client.configuration = configuration;
        });

        context(@"with no server url", ^{

            beforeEach(^{
                configuration.serverURL = nil;
            });

            it(@"should fail to perform a get request", ^{
                [[theBlock(^{
                    [client GET:@"get" parameters:nil completion:nil];
                }) should] raiseWithName:NSInternalInconsistencyException];
            });

            it(@"should fail to perform a post request", ^{
                [[theBlock(^{
                    [client POST:@"post" parameters:nil completion:nil];
                }) should] raiseWithName:NSInternalInconsistencyException];
            });

        });

        context(@"with a server url", ^{

            beforeEach(^{
                NSURL *baseURL = [NSURL URLWithString:@"http://httpbin.org"];
                configuration.serverURL = baseURL;
                [configuration stub:@selector(baseURL) andReturn:baseURL];
            });

            specify(^{
                [[theValue(configuration.numberOfRetries) should] equal:theValue(0)];
            });

            it(@"should succeed to perform a single get request", ^{
                __block id response = nil; __block NSError *error = nil;
                [client GET:@"get" parameters:nil completion:^(id blockResponse, NSError *blockError) {
                    response = blockResponse;
                    error = blockError;
                }];
                [[expectFutureValue(response) shouldEventually] beNonNil];
                [[expectFutureValue(error) shouldEventually] beNil];
            });

            it(@"should succeed to perform a single post request", ^{
                __block id response = nil; __block NSError *error = nil;
                [client GET:@"get" parameters:nil completion:^(id blockResponse, NSError *blockError) {
                    response = blockResponse;
                    error = blockError;
                }];
                [[expectFutureValue(response) shouldEventually] beNonNil];
                [[expectFutureValue(error) shouldEventually] beNil];
            });

            it(@"should correctly deliver parameters while performing a get request", ^{
                __block id response = nil; __block NSError *error = nil; __block id args = nil;
                NSDictionary *parameters = @{ @"foo": @"bar", @"baz": @"qux" };
                [client GET:@"get" parameters:parameters completion:^(id blockResponse, NSError *blockError) {
                    response = blockResponse;
                    error = blockError;
                    args = blockResponse[@"args"];
                }];
                [[expectFutureValue(response) shouldEventually] beNonNil];
                [[expectFutureValue(error) shouldEventually] beNil];
                [[expectFutureValue(args) shouldEventually] haveValue:@"bar" forKey:@"foo"];
                [[expectFutureValue(args) shouldEventually] haveValue:@"qux" forKey:@"baz"];
            });

            it(@"should correctly deliver parameters while performing a post request", ^{
                __block id response = nil; __block NSError *error = nil; __block id json = nil;
                NSDictionary *parameters = @{ @"bar": @"foo", @"qux": @"baz" };
                [client POST:@"post" parameters:parameters completion:^(id blockResponse, NSError *blockError) {
                    response = blockResponse;
                    error = blockError;
                    json = blockResponse[@"json"];
                }];
                [[expectFutureValue(response) shouldEventually] beNonNil];
                [[expectFutureValue(error) shouldEventually] beNil];
                [[expectFutureValue(json) shouldEventually] haveValue:@"foo" forKey:@"bar"];
                [[expectFutureValue(json) shouldEventually] haveValue:@"baz" forKey:@"qux"];
            });

            describe(@"retrying", ^{

                context(@"with a positive number of retries", ^{

                    __block id<OHHTTPStubsDescriptor> stub = nil;

                    beforeEach(^{
                        configuration.numberOfRetries = 2;
                        [OHHTTPStubs dvs_stubRequestsForPath:@"get" options:@{
                            DVSHTTPStubsNumberOfFailuresKey: @(2),
                        } response:^OHHTTPStubsResponse *(NSURLRequest *request) {
                            NSDictionary *json = @{ @"foo": @"bar" };
                            return [OHHTTPStubsResponse responseWithJSONObject:json statusCode:200 headers:nil];
                        }];
                    });

                    afterEach(^{
                        [OHHTTPStubs dvs_resetRemainingNumberOfFailuresForPath:@"get"];
                        [OHHTTPStubs removeStub:stub];
                    });

                    it(@"should retry until request succeeds", ^{
                        __block id response = nil; __block NSError *error = nil;
                        [client GET:@"get" parameters:nil completion:^(id blockResponse, NSError *blockError) {
                            response = blockResponse;
                            error = blockError;
                        }];
                        [[expectFutureValue(response) shouldEventually] beNonNil];
                        [[expectFutureValue(error) shouldEventually] beNil];
                        [[expectFutureValue(response) shouldEventually] haveValue:@"bar" forKey:@"foo"];
                    });

                });


            });

        });

    });

    // please test http client extensions in dedicated specs

});

SPEC_END
