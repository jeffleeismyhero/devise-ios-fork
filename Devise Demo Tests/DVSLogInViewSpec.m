//
//  DVSLogInViewSpec.m
//  Devise
//
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

SPEC_BEGIN(DVSLogInViewSpec)

describe(@"DVSLogInView", ^{
    
    beforeAll(^{
        [tester dvs_moveToLogIn];
    });
    
    afterAll(^{
        [tester dvs_moveBackToWelcome];
    });
    
    it(@"should do basic test", ^{
        [tester tapViewWithAccessibilityLabel:NSLocalizedString(DVSAccessibilityLabelEmailTextField, nil)];
    });
    
});

SPEC_END