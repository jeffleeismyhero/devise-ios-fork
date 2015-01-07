//
//  DVSFunctionalTestsConfig.m
//  Devise
//
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

CONFIG_START

beforeAllSpecs(^{
    [tester waitForTimeInterval:1.0]; // for app to settle
});

CONFIG_END
