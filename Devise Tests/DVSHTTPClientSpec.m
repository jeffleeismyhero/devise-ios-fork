//
//  DVSHTTPClientSpec.m
//
//  Copyright 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSHTTPClient.h"
#import "DVSTestConfiguration.h"

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

    __block DVSHTTPClient *client = nil;

    beforeEach(^{
        client = [[DVSHTTPClient alloc] init];
    });

    context(@"provided with no configuration", ^{

        it(@"should fail to perform a post request", ^{
            [[theBlock(^{
                [client POST:@"post" parameters:nil completion:nil];
            }) should] raiseWithName:NSInternalInconsistencyException];
        });

    });

    context(@"provided with a configuration", ^{

        __block DVSTestConfiguration *configuration = nil;

        beforeEach(^{
            configuration = [[DVSTestConfiguration alloc] initWithServerURL:nil appendPathComponents:NO];
            client.configuration = configuration;
        });

        context(@"with no server url", ^{

            beforeEach(^{
                configuration.serverURL = nil;
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
            });

            specify(^{
                [[theValue(configuration.numberOfRetries) should] equal:theValue(0)];
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
        });
        
    });

    // please test http client extensions in dedicated specs

});

SPEC_END
