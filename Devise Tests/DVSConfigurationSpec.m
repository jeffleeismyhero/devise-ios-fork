//
//  DVSConfigurationSpec.m
//
//  Copyright 2014 Netguru Sp. z o.o. All rights reserved.
//

SPEC_BEGIN(DVSConfigurationSpec)

describe(@"DVSConfiguration", ^{

    context(@"when newly instantiated", ^{

        __block DVSConfiguration *configuration = nil;

        beforeEach(^{
            configuration = [[DVSConfiguration alloc] init];
        });

        it(@"should have no server url", ^{
            [[configuration.serverURL should] beNil];
        });

        it(@"should have the lowest log level", ^{
            [[theValue(configuration.logLevel) should] equal:theValue(DVSLogLevelNone)];
        });

        it(@"should not accept invalid server url", ^{
            configuration.logLevel = DVSLogLevelAssert;
            [[theBlock(^{
                configuration.serverURL = [NSURL URLWithString:@"http:/foo"];
            }) should] raiseWithName:NSInternalInconsistencyException];
        });

        it(@"should not have a positive number of retries", ^{
            [[theValue(configuration.numberOfRetries) should] equal:theValue(0)];
        });

    });

    context(@"when using a shared instance", ^{

        it(@"should return the same instance", ^{
            DVSConfiguration *first = [DVSConfiguration sharedConfiguration];
            DVSConfiguration *second = [DVSConfiguration sharedConfiguration];
            [[first should] beIdenticalTo:second];
        });
        
    });

    __block DVSConfiguration *configuration = nil;

    beforeEach(^{
        NSURL *serverURL = [NSURL URLWithString:@"http://httpbin.org"];
        configuration = [[DVSConfiguration alloc] initWithServerURL:serverURL];
    });

    describe(@"logging", ^{

        context(@"when log level is set to warning", ^{

            beforeEach(^{
                configuration.logLevel = DVSLogLevelWarning;
            });

            it(@"should not raise an exception", ^{
                [[theBlock(^{
                    [configuration logMessage:@"foo"];
                }) shouldNot] raise];
            });
        });

        context(@"when log level is set to assert", ^{

            beforeEach(^{
                configuration.logLevel = DVSLogLevelAssert;
            });

            it(@"should raise an exception", ^{
                [[theBlock(^{
                    [configuration logMessage:@"baz"];
                }) should] raiseWithName:NSInternalInconsistencyException];
            });
            
        });
    });

    it(@"should have exactly three route paths", ^{
        [[configuration.routePaths should] haveCountOf:3];
    });

    it(@"should save the route path", ^{
        [configuration setPath:@"bar" forRoute:DVSRouteLogin];
        NSString *path = [configuration pathForRoute:DVSRouteLogin];
        [[path should] equal:@"bar"];
    });

});

SPEC_END
