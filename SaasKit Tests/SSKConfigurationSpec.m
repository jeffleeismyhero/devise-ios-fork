//
//  SSKConfigurationSpec.m
//
//  Copyright 2014 Netguru Sp. z o.o. All rights reserved.
//

SPEC_BEGIN(SSKConfigurationSpec)

describe(@"SSKConfiguration", ^{

    context(@"when newly instantiated", ^{

        __block SSKConfiguration *configuration = nil;

        beforeEach(^{
            configuration = [[SSKConfiguration alloc] init];
        });

        it(@"should have no server url", ^{
            [[configuration.serverURL should] beNil];
        });

        it(@"should have the lowest log level", ^{
            [[theValue(configuration.logLevel) should] equal:theValue(SSKLogLevelNone)];
        });

    });

    context(@"when using a shared instance", ^{

        it(@"should return the same instance", ^{
            SSKConfiguration *first = [SSKConfiguration sharedConfiguration];
            SSKConfiguration *second = [SSKConfiguration sharedConfiguration];
            [[first should] beIdenticalTo:second];
        });

    });

    __block SSKConfiguration *configuration = nil;

    beforeEach(^{
        NSURL *serverURL = [NSURL URLWithString:@"http://httpbin.org"];
        configuration = [[SSKConfiguration alloc] initWithServerURL:serverURL];
    });

    context(@"when log level is set to warning", ^{

        beforeEach(^{
            configuration.logLevel = SSKLogLevelWarning;
        });

        it(@"should not raise an exception", ^{
            [[theBlock(^{
                [configuration logMessage:@"foo"];
            }) shouldNot] raise];
        });
        
    });

    context(@"when log level is set to assert", ^{

        beforeEach(^{
            configuration.logLevel = SSKLogLevelAssert;
        });

        it(@"should raise an exception", ^{
            [[theBlock(^{
                [configuration logMessage:@"baz"];
            }) should] raiseWithName:NSInternalInconsistencyException];
        });

    });

    it(@"should have exactly three route paths", ^{
        [[configuration.routePaths should] haveCountOf:3];
    });

    it(@"should save the route path", ^{
        [configuration setPath:@"bar" forRoute:SSKRouteLogin];
        NSString *path = [configuration pathForRoute:SSKRouteLogin];
        [[path should] equal:@"bar"];
    });

});

SPEC_END
