//
//  DVSHomeViewSpec.m
//  Devise
//
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

SPEC_BEGIN(DVSHomeViewSpec)

describe(@"home screen", ^{
    
    describe(@"delete alert", ^{
        
        __block id<OHHTTPStubsDescriptor> stub = nil;
        
        beforeAll(^{
            stub = [OHHTTPStubs dvs_stubUserDeleteRequestsWithOptions:nil];
        });
        
        afterAll(^{
            [OHHTTPStubs removeStub:stub];
        });
        
        beforeEach(^{
            [tester dvs_login];
            [tester tapViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Delete profile")];
            [tester waitForViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Delete")];
        });
        
        context(@"cancel button", ^{
            
            it(@"should close confirm popup", ^{
                [tester tapViewWithAccessibilityLabel:DVSAccessibilityLabel(@"No")];
                [tester waitForAbsenceOfViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Delete")];
                
            });
            
            afterEach(^{
                [tester dvs_tapLogOutButton];
            });
            
        });
        
        context(@"confirm button", ^{
            
            it(@"should delete profile", ^{
                [tester tapViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Yes")];
                [tester waitForViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Welcome")];
            });
            
        });
    });
    
});

SPEC_END
