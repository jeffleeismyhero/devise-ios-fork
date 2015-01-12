//
//  DVSSignUpSpec.m
//  Devise
//
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

SPEC_BEGIN(DVSSignUpSpec)

describe(@"tapping sign up button", ^{
    
    void (^tapSaveAndWaitForError)() = ^void() {
        [tester dvs_tapConfirmSignUpButton];
        [tester dvs_waitForErrorView];
        [tester dvs_closeErrorPopup];
    };
    
    __block id<OHHTTPStubsDescriptor> stub = nil;
    
    beforeAll(^{
        stub = [OHHTTPStubs dvs_stubUserRegisterRequestsWithOptions:nil];
    });
    
    afterAll(^{
        [OHHTTPStubs removeStub:stub];
    });
    
    beforeEach(^{
        [tester dvs_moveToSignUp];
    });
    
    afterEach(^{
        [tester dvs_moveBackToWelcome];
    });
    
    context(@"when e-mail text field is empty", ^{
        
        beforeEach(^{
            [tester dvs_enterValidPassword];
        });
        
        it(@"should show error", ^{
            tapSaveAndWaitForError();
        });
    });
    
    context(@"when e-mail text field has invalid data", ^{
        
        beforeEach(^{
            [tester dvs_enterValidPassword];
            [tester enterText:@"john.appleseed.example.com" intoViewWithAccessibilityLabel:DVSAccessibilityLabel(DVSAccessibilityLabelEmailTextField)];
        });
        
        it(@"should show error message", ^{
            tapSaveAndWaitForError();
        });
    });
    
    context(@"when password text field is empty", ^{
        
        beforeEach(^{
            [tester dvs_enterValidEmail];
        });
        
        it(@"should show error message", ^{
            tapSaveAndWaitForError();
        });
        
    });
    
    context(@"when password text field is too short", ^{
        
        beforeEach(^{
            [tester dvs_enterValidEmail];
            [tester enterText:@"$ec" intoViewWithAccessibilityLabel:DVSAccessibilityLabelPasswordTextField];
        });
        
        it(@"should error message", ^{
            tapSaveAndWaitForError();
        });
    });
    
    context(@"when e-mail and password text fields have valid data", ^{
        
        beforeEach(^{
            [tester dvs_enterValidPassword];
            [tester dvs_enterValidEmail];
        });
        
        afterEach(^{
            [tester dvs_tapLogOutButton];
        });
        
        it(@"should move to home", ^{
            [tester dvs_tapConfirmSignUpButton];
            [tester waitForViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Home")];
        });
    });
});

SPEC_END
