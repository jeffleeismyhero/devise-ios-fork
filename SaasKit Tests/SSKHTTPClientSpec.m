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

        it(@"should use a shared configuration", ^{
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
                __block BOOL success = NO;
                [client GET:@"get" parameters:nil completion:^(id response, NSError *error) {
                    if (error == nil) success = YES;
                }];
                [[expectFutureValue(theValue(success)) shouldEventually] beYes];
            });

            it(@"should succeed to perform a single post request", ^{
                __block BOOL success = NO;
                [client POST:@"post" parameters:nil completion:^(id response, NSError *error) {
                    if (error == nil) success = YES;
                }];
                [[expectFutureValue(theValue(success)) shouldEventually] beYes];
            });

        });

    });


    // please test http client extensions in dedicated specs

});

SPEC_END
