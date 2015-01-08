//
//  DVSSignUpSpec.m
//  Devise
//
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

SPEC_BEGIN(DVSSignUpSpec)

describe(@"sign up screen", ^{
    
    beforeAll(^{
        [tester dvs_moveToSignUp];
    });
    
    afterAll(^{
        [tester dvs_moveBackToWelcome];
    });
    
    describe(@"error message", ^{
        
        context(@"for e-mail field", ^{
            
            it(@"should be shown when empty", ^{
                
            });
            
            it(@"should be shown when has wrong syntax", ^{
                
            });
            
            it(@"should not be shown when valid", ^{
                
            });
            
        });
        
        context(@"for password field", ^{
            
            it(@"should be shown when empty", ^{
                
            });
            
            it(@"should be shown when is too short", ^{
                
            });
            
            it(@"should not be shown when valid", ^{
                
            });
            
        });
    });
    
});

SPEC_END
