//
//  DVSSignUpSpec.m
//  Devise
//
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

#import "KIFUITestActor+DeviseDemo.h"

SPEC_BEGIN(DVSSignUpSpec)

describe(@"sign up screen", ^{
    
    beforeAll(^{
        [tester dvs_moveToSignUp];
    });
    
    it(@"should do basic test", ^{
        [[theValue(@1) should] equal:theValue(@1)];
    });
    
});

SPEC_END
