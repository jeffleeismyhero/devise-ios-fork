//
//  SSKHTTPClientSpec.m
//
//  Copyright 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "SSKHTTPClient.h"

SPEC_BEGIN(SSKHTTPClientSpec)

describe(@"SSKHTTPClient", ^{

    context(@"when newly instantiated", ^{

        __block SSKHTTPClient *client = nil;

        beforeEach(^{
            client = [[SSKHTTPClient alloc] init];
        });

        it(@"should not have any configuration", ^{
            [[client.configuration should] beNil];
        });
        
    });

    context(@"when using a shared instance", ^{

        __block SSKHTTPClient *client = nil;

        beforeEach(^{
            client = [SSKHTTPClient sharedClient];
        });

        it(@"should provide the same instance", ^{
            SSKHTTPClient *secondClient = [SSKHTTPClient sharedClient];
            [[client should] beIdenticalTo:secondClient];
        });

        it(@"should use the shared configuration", ^{
            SSKConfiguration *configuration = [SSKConfiguration sharedConfiguration];
            [[client.configuration should] beIdenticalTo:configuration];
        });

    });

    __block SSKHTTPClient *client = nil;

    beforeEach(^{
        client = [[SSKHTTPClient alloc] init];
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

        __block SSKConfiguration *configuration = nil;

        beforeEach(^{
            configuration = [[SSKConfiguration alloc] init];
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
                configuration.serverURL = [NSURL URLWithString:@"http://httpbin.org"];
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
                [[expectFutureValue(response) shouldEventuallyBeforeTimingOutAfter(2)] beNonNil];
                [[expectFutureValue(error) shouldEventuallyBeforeTimingOutAfter(2)] beNil];
            });

            it(@"should succeed to perform a single post request", ^{
                __block id response = nil; __block NSError *error = nil;
                [client GET:@"get" parameters:nil completion:^(id blockResponse, NSError *blockError) {
                    response = blockResponse;
                    error = blockError;
                }];
                [[expectFutureValue(response) shouldEventuallyBeforeTimingOutAfter(2)] beNonNil];
                [[expectFutureValue(error) shouldEventuallyBeforeTimingOutAfter(2)] beNil];
            });

            it(@"should correctly deliver parameters while performing a get request", ^{
                __block id response = nil; __block NSError *error = nil; __block id args = nil;
                NSDictionary *parameters = @{ @"foo": @"bar", @"baz": @"qux" };
                [client GET:@"get" parameters:parameters completion:^(id blockResponse, NSError *blockError) {
                    response = blockResponse;
                    error = blockError;
                    args = blockResponse[@"args"];
                }];
                [[expectFutureValue(response) shouldEventuallyBeforeTimingOutAfter(2)] beNonNil];
                [[expectFutureValue(error) shouldEventuallyBeforeTimingOutAfter(2)] beNil];
                [[expectFutureValue(args) shouldEventuallyBeforeTimingOutAfter(2)] haveValue:@"bar" forKey:@"foo"];
                [[expectFutureValue(args) shouldEventuallyBeforeTimingOutAfter(2)] haveValue:@"qux" forKey:@"baz"];
            });

            it(@"should correctly deliver parameters while performing a post request", ^{
                __block id response = nil; __block NSError *error = nil; __block id json = nil;
                NSDictionary *parameters = @{ @"bar": @"foo", @"qux": @"baz" };
                [client POST:@"post" parameters:parameters completion:^(id blockResponse, NSError *blockError) {
                    response = blockResponse;
                    error = blockError;
                    json = blockResponse[@"json"];
                }];
                [[expectFutureValue(response) shouldEventuallyBeforeTimingOutAfter(2)] beNonNil];
                [[expectFutureValue(error) shouldEventuallyBeforeTimingOutAfter(2)] beNil];
                [[expectFutureValue(json) shouldEventuallyBeforeTimingOutAfter(2)] haveValue:@"foo" forKey:@"bar"];
                [[expectFutureValue(json) shouldEventuallyBeforeTimingOutAfter(2)] haveValue:@"baz" forKey:@"qux"];
            });

        });

    });

    // please test http client extensions in dedicated specs

});

SPEC_END
