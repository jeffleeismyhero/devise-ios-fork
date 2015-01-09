//
//  DVSProfileEditViewSpec.m
//  Devise
//
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

SPEC_BEGIN(DVSProfileEditViewSpec)

describe(@"profile edit screen", ^{
    
    __block id<OHHTTPStubsDescriptor> stub = nil;
    
    beforeAll(^{
        stub = [OHHTTPStubs dvs_stubUserUpdateRequestsWithOptions:nil];
        [tester dvs_login];
    });
    
    afterAll(^{
        [tester dvs_tapLogOutButton];
        [OHHTTPStubs removeStub:stub];
    });
    
    beforeEach(^{
        [tester tapViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Edit profile")];
    });
    
    afterEach(^{
        [tester tapViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Home")];
    });
    
    describe(@"on show", ^{
        
        context(@"e-mail field", ^{
            
            it(@"should be filled with user e-mail", ^{
                UITextField *emailTextField = (UITextField *)[tester waitForViewWithAccessibilityLabel:DVSAccessibilityLabel(@"E-mail field")];
                [[emailTextField.text should] equal:DVSValidEmail];
            });
            
        });
        
    });
    
    describe(@"error message for e-mail field", ^{
        
        context(@"should be shown", ^{
            
            beforeEach(^{
                [tester clearTextFromViewWithAccessibilityLabel:DVSAccessibilityLabel(@"E-mail field")];
            });
            
            afterEach(^{
                [tester dvs_closeErrorPopup];
            });
            
            it(@"when empty", ^{
                [tester tapViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Save")];
                [tester waitForViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Error")];
            });
            
            it(@"when has wrong syntax", ^{
                [tester enterText:@"john.appleseed.example.com" intoViewWithAccessibilityLabel:DVSAccessibilityLabel(@"E-mail field")];
                [tester tapViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Save")];
                [tester waitForViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Error")];
            });
            
        });
    });
    
    describe(@"success message", ^{
        
        beforeEach(^{
            [tester clearTextFromViewWithAccessibilityLabel:DVSAccessibilityLabel(@"E-mail field")];
        });
        
        afterEach(^{
            [tester tapViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Close")];
            [tester tapViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Home")];
        });
        
        it(@"should be shown when e-mail is valid", ^{
            [tester enterText:@"john.appleseed@example.com" intoViewWithAccessibilityLabel:DVSAccessibilityLabel(@"E-mail field")];
            [tester tapViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Save")];
            [tester waitForViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Profile updated")];
        });
    });
    
});

SPEC_END
