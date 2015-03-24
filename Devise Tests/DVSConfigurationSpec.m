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
            [[theValue(configuration.loggingMode) should] equal:theValue(DVSLoggingModeNone)];
        });

        it(@"should not accept invalid server url", ^{
            configuration.loggingMode = DVSLoggingModeAssert;
            [[theBlock(^{
                configuration.serverURL = [NSURL URLWithString:@"http:/foo"];
            }) should] raiseWithName:NSInternalInconsistencyException];
        });

        it(@"should not have a positive number of retries", ^{
            [[theValue(configuration.numberOfRetries) should] equal:theValue(0)];
        });

        it(@"should have a default resource name", ^{
            [[configuration.resourceName should] equal:@"users"];
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

        context(@"when mode is set to warning", ^{

            beforeEach(^{
                configuration.loggingMode = DVSLoggingModeWarning;
            });

            it(@"should not raise an exception", ^{
                [[theBlock(^{
                    [configuration logMessage:@"foo"];
                }) shouldNot] raise];
            });
        });

        context(@"when mode is set to assert", ^{

            beforeEach(^{
                configuration.loggingMode = DVSLoggingModeAssert;
            });

            it(@"should raise an exception", ^{
                [[theBlock(^{
                    [configuration logMessage:@"baz"];
                }) should] raiseWithName:NSInternalInconsistencyException];
            });
            
        });
    });
    
});

SPEC_END
