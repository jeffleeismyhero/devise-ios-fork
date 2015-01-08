//
//  DVSSignUpSpec.m
//  Devise
//
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

SPEC_BEGIN(DVSSignUpSpec)

describe(@"sign up screen", ^{
    
    beforeEach(^{
        [tester dvs_moveToSignUp];
    });
    
    afterEach(^{
        [tester dvs_moveBackToWelcome];
    });
    
    describe(@"error message", ^{
        
        __block id<OHHTTPStubsDescriptor> stub = nil;
        
        beforeAll(^{
            stub = [OHHTTPStubs dvs_stubUserRegisterRequestsWithOptions:nil];
        });
        
        afterAll(^{
            [OHHTTPStubs removeStub:stub];
        });
        
        describe(@"for e-mail field", ^{
            
            beforeEach(^{
                [tester dvs_enterValidPassword];
                [tester dvs_closeSoftwareKeyboard];
            });
            
            context(@"should be shown", ^{
                
                afterEach(^{
                    [tester dvs_closeErrorPopup];
                });
                
                it(@"when empty", ^{
                    [tester dvs_tapConfirmSignUpButton];
                    [tester waitForViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Error")];
                });
                
                it(@"when has wrong syntax", ^{
                    [tester enterText:@"john.appleseed.example.com" intoViewWithAccessibilityLabel:DVSAccessibilityLabel(DVSAccessibilityLabelEmailTextField)];
                    [tester dvs_tapConfirmSignUpButton];
                    [tester waitForViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Error")];
                });
                
            });
            
            context(@"should not be shown", ^{
                
                afterEach(^{
                    [tester dvs_tapLogOutButton];
                });
                
                it(@"should not be shown when valid", ^{
                    [tester dvs_enterValidEmail];
                    [tester dvs_tapConfirmSignUpButton];
                    [tester waitForAbsenceOfViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Error")];
                });
            });
            
        });
        
        context(@"for password field", ^{
            
            beforeEach(^{
                [tester dvs_enterValidEmail];
                [tester dvs_closeSoftwareKeyboard];
            });
            
            context(@"should be shown", ^{
                
                afterEach(^{
                    [tester dvs_closeErrorPopup];
                });
                
                it(@"when empty", ^{
                    [tester dvs_tapConfirmSignUpButton];
                    [tester waitForViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Error")];
                });
                
                it(@"when is too short", ^{
                    [tester enterText:@"$ec" intoViewWithAccessibilityLabel:DVSAccessibilityLabelPasswordTextField];
                    [tester dvs_tapConfirmSignUpButton];
                    [tester waitForViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Error")];
                });
            });
            
            context(@"should not be shown", ^{
                
                afterEach(^{
                    [tester dvs_tapLogOutButton];
                });
                
                it(@"when valid", ^{
                    [tester dvs_enterValidPassword];
                    [tester dvs_tapConfirmSignUpButton];
                    [tester waitForAbsenceOfViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Error")];
                });
            });
        });
    });
    
});

SPEC_END
