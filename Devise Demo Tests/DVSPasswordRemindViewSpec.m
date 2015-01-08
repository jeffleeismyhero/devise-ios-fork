//
//  DVSPasswordRemindViewSpec.m
//  Devise
//
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

SPEC_BEGIN(DVSPasswordRemindViewSpec)

describe(@"password remind screen", ^{
   
    beforeAll(^{
        [tester dvs_moveToLogIn];
    });
    
    afterAll(^{
        [tester dvs_moveBackToWelcome];
    });
    
    beforeEach(^{
        [tester tapViewWithAccessibilityLabel:DVSAccessibilityLabel(DVSAccessibilityLabelMoveToPasswordRemindButton)];
    });
    
    afterEach(^{
        [tester tapViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Close")];
        [tester tapViewWithAccessibilityLabel:DVSAccessibilityLabel(DVSAccessibilityLabelCancelRemindPasswordButton)];
    });
    
    describe(@"error message", ^{
        
        it(@"should show when e-mail field is empty", ^{
            [tester tapViewWithAccessibilityLabel:DVSAccessibilityLabel(DVSAccessibilityLabelConfirmRemindPasswordButton)];
            [tester waitForViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Error")];
        });
        
        it(@"should show when e-mail field has wrong syntax", ^{
            [tester enterText:@"john.appleseed.example.com" intoViewWithAccessibilityLabel:DVSAccessibilityLabel(DVSAccessibilityLabelEmailTextField)];
            [tester tapViewWithAccessibilityLabel:DVSAccessibilityLabel(DVSAccessibilityLabelConfirmRemindPasswordButton)];
            [tester waitForViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Error")];
        });
    });
    
    describe(@"success message", ^{
        
        it(@"should show when e-mail is valid", ^{
            [tester enterText:@"john.appleseed@example.com" intoViewWithAccessibilityLabel:DVSAccessibilityLabel(DVSAccessibilityLabelEmailTextField)];
            [tester tapViewWithAccessibilityLabel:DVSAccessibilityLabel(DVSAccessibilityLabelConfirmRemindPasswordButton)];
            [tester waitForViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Remind successful")];
        });
    });
    
});

SPEC_END
