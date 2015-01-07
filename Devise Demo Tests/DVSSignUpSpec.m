//
//  DVSSignUpSpec.m
//  Devise
//
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

SPEC_BEGIN(DVSSignUpSpec)

describe(@"sign up screen", ^{
    
    beforeAll(^{
        [tester dvs_moveToSignUp];
    });
    
    afterAll(^{
        [tester dvs_moveBackToWelcome];
    });
    
    it(@"should do basic test", ^{
        [[theValue(@1) should] equal:theValue(@1)];
    });
    
});

SPEC_END
