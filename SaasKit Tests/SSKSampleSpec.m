//
//  SSKSampleSpec.m
//  
//  Copyright 2014 Netguru Sp. z o.o. All rights reserved.
//

SPEC_BEGIN(SSKSampleSpec)

describe(@"math", ^{

    it(@"is awesome", ^{
        [[theValue(2 + 3) should] equal:theValue(5)];
    });

});

SPEC_END
