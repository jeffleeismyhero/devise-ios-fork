//
//  DVSProfileEditViewSpec.m
//  Devise
//
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

SPEC_BEGIN(DVSProfileEditViewSpec)

describe(@"tapping save button", ^{
    
    void (^tapSaveAndWaitForError)() = ^void() {
        [tester tapViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Save")];
        [tester dvs_waitForErrorView];
        [tester dvs_closeErrorPopup];
    };
    
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
    
    context(@"when email text field is empty", ^{
        
        beforeEach(^{
            [tester clearTextFromViewWithAccessibilityLabel:DVSAccessibilityLabel(@"E-mail field")];
        });
        
        it(@"should show error message", ^{
            tapSaveAndWaitForError();
        });
    });
    
    context(@"when email text field has invalid data", ^{
        
        beforeEach(^{
            [tester clearTextFromViewWithAccessibilityLabel:DVSAccessibilityLabel(@"E-mail field")];
            [tester enterText:@"john.appleseed.example.com" intoViewWithAccessibilityLabel:DVSAccessibilityLabel(@"E-mail field")];
        });
        
        it(@"should show error message", ^{
            tapSaveAndWaitForError();
        });
    });
    
    context(@"when email text field has valid data", ^{
        
        beforeEach(^{
            [tester clearTextFromViewWithAccessibilityLabel:DVSAccessibilityLabel(@"E-mail field")];
            [tester enterText:@"john.appleseed@example.com" intoViewWithAccessibilityLabel:DVSAccessibilityLabel(@"E-mail field")];
        });
        
        it(@"should show success message", ^{
            [tester tapViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Save")];
            [tester waitForViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Profile updated")];
            [tester tapViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Close")];
        });
    });
});

SPEC_END
