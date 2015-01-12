//
//  DVSPasswordRemindViewSpec.m
//  Devise
//
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

SPEC_BEGIN(DVSPasswordRemindViewSpec)

describe(@"tapping remind button", ^{
   
    void (^tapRemindAndWaitForError)() = ^void() {
        [tester tapViewWithAccessibilityLabel:DVSAccessibilityLabel(DVSAccessibilityLabelConfirmRemindPasswordButton)];
        [tester dvs_waitForErrorView];
        [tester dvs_closeErrorPopup];
    };
    
    __block id<OHHTTPStubsDescriptor> stub = nil;
    
    beforeAll(^{
        stub = [OHHTTPStubs dvs_stubUserRemindPasswordRequestsWithOptions:nil];
        [tester dvs_moveToLogIn];
    });
    
    afterAll(^{
        [OHHTTPStubs removeStub:stub];
        [tester dvs_moveBackToWelcome];
    });
    
    beforeEach(^{
        [tester tapViewWithAccessibilityLabel:DVSAccessibilityLabel(DVSAccessibilityLabelMoveToPasswordRemindButton)];
    });
    
    afterEach(^{
        [tester tapViewWithAccessibilityLabel:DVSAccessibilityLabel(DVSAccessibilityLabelCancelRemindPasswordButton)];
    });
    
    it(@"should show error message when e-mail field is empty", ^{
        tapRemindAndWaitForError();
    });
    
    context(@"when e-mail text field has invalid data", ^{
        
        beforeEach(^{
            [tester enterText:@"john.appleseed.example.com" intoViewWithAccessibilityLabel:DVSAccessibilityLabel(DVSAccessibilityLabelEmailTextField)];
        });
        
        it(@"should show error message", ^{
            tapRemindAndWaitForError();
        });
        
    });
    
    context(@"when email text field has valid data", ^{
        
        beforeAll(^{
            [tester enterText:DVSValidEmail intoViewWithAccessibilityLabel:DVSAccessibilityLabel(DVSAccessibilityLabelEmailTextField)];
        });
        
        it(@"should show success message", ^{
            [tester tapViewWithAccessibilityLabel:DVSAccessibilityLabel(DVSAccessibilityLabelConfirmRemindPasswordButton)];
            [tester waitForViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Remind successful")];
            [tester tapViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Close")];
        });
        
    });
    
});

SPEC_END
