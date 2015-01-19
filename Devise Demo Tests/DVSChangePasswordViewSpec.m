//
//  DVSChangePasswordViewSpec.m
//  Devise
//
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

SPEC_BEGIN(DVSChangePasswordViewSpec)

describe(@"Change password screen", ^{
    
    describe(@"tapping save button", ^{
        
        __block id<OHHTTPStubsDescriptor> stub = nil;
        
        beforeAll(^{
            stub = [OHHTTPStubs dvs_stubUserChangePasswordRequestsWithOptions:nil];
            [tester dvs_login];
            
        });
        
        afterAll(^{
            [OHHTTPStubs removeStub:stub];
            [tester dvs_tapLogOutButton];
        });
        
        beforeEach(^{
            [tester tapViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Change password")];
            [tester waitForViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Current password field")];
        });
        
        afterEach(^{
            [tester tapViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Home")];
            [tester waitForViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Change password")];
        });
        
        it(@"should show error message when current password confirm field is empty", ^{
            [tester tapViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Save")];
            [tester waitForViewWithAccessibilityLabel:NSLocalizedString(@"Current password is required.", nil)];
            [tester dvs_closeErrorPopup];
        });
        
        context(@"when current password confirm field don't match current password", ^{
            
            beforeEach(^{
                [tester enterText:@"$eC" intoViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Current password field")];
            });
            
            it(@"should show error message", ^{
                [tester tapViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Save")];
                [tester waitForViewWithAccessibilityLabel:NSLocalizedString(@"Password confirm and current password do not match.", nil)];
                [tester dvs_closeErrorPopup];
            });
        });

        context(@"when new password is empty", ^{
            
            beforeEach(^{
                [tester enterText:DVSValidPassword intoViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Current password field")];
            });
            
            it(@"should show error message", ^{
                [tester tapViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Save")];
                [tester waitForViewWithAccessibilityLabel:NSLocalizedString(@"Password is required.", nil)];
                [tester dvs_closeErrorPopup];
            });
        });
        
        context(@"when new password is not confirmed", ^{
            
            beforeEach(^{
                [tester enterText:DVSValidPassword intoViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Current password field")];
                [tester enterText:@"n3w_pa$$word" intoViewWithAccessibilityLabel:DVSAccessibilityLabel(@"New password field")];
            });
            
            it(@"should show error message", ^{
                [tester tapViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Save")];
                [tester waitForViewWithAccessibilityLabel:NSLocalizedString(@"New password confirm is required.", nil)];
                [tester dvs_closeErrorPopup];
            });
            
        });

        context(@"when new password and confirm don't match", ^{
            
            beforeEach(^{
                [tester enterText:DVSValidPassword intoViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Current password field")];
                [tester enterText:@"n3w_pa$$word" intoViewWithAccessibilityLabel:DVSAccessibilityLabel(@"New password field")];
                [tester enterText:@"not_n3w_pa$$word" intoViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Confirm password field")];
            });
            
            it(@"should show error message", ^{
                [tester tapViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Save")];
                [tester waitForViewWithAccessibilityLabel:NSLocalizedString(@"Passwords do not match.", nil)];
                [tester dvs_closeErrorPopup];
            });
            
        });
        
        context(@"when all fields are valid", ^{
            
            beforeEach(^{
                [tester enterText:DVSValidPassword intoViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Current password field")];
                [tester enterText:@"n3w_pa$$word" intoViewWithAccessibilityLabel:DVSAccessibilityLabel(@"New password field")];
                [tester enterText:@"n3w_pa$$word" intoViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Confirm password field")];
            });
            
            it(@"should show success message", ^{
                [tester tapViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Save")];
                [tester waitForViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Password changed")];
                [tester tapViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Close")];
            });
        });
    });
});

SPEC_END