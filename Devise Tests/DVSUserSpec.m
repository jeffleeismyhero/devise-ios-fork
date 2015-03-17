//
//  DVSUserSpec.m
//
//  Copyright 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSTestConfiguration.h"
#import "DVSTestUser.h"

SPEC_BEGIN(DVSUserSpec)

describe(@"DVSUser", ^{

    __block DVSTestUser *testUser = nil;
    
    context(@"when initialized", ^{

        __block DVSActionType action = -1;

        beforeEach(^{
            testUser = [[DVSTestUser alloc] init];
        });
        
        afterEach(^{
            testUser = nil;
            action = -1;
        });
        
        describe(@"set single additional parameter for action", ^{
           
            __block id additionalParameter = nil;
            __block NSString *parameterKey = nil;
            __block NSDictionary *expectedParameters = nil;
            
            beforeEach(^{
                additionalParameter = @"0xff0000";
                parameterKey = @"color";
                expectedParameters = @{parameterKey: additionalParameter};
            });
            
            afterEach(^{
                additionalParameter = nil;
                parameterKey = nil;
            });
            
            context(@"login", ^{
                
                beforeEach(^{
                    action = DVSActionLogin;
                    [testUser setRequestParameter:additionalParameter forKey:parameterKey action:action];
                });
                
                it(@"should return correct parameters", ^{
                    NSDictionary *resultParameters = [testUser requestParametersForAction:action];
                    [[resultParameters should] equal:expectedParameters];
                });
                
            });
            
            context(@"registration", ^{
                
                beforeEach(^{
                    action = DVSActionRegistration;
                    [testUser setRequestParameter:additionalParameter forKey:parameterKey action:action];
                });
                
                it(@"should return correct parameters", ^{
                    NSDictionary *resultParameters = [testUser requestParametersForAction:action];
                    [[resultParameters should] equal:expectedParameters];
                });
                
            });
            
            context(@"remind password", ^{
                
                beforeEach(^{
                    action = DVSActionRemindPassword;
                    [testUser setRequestParameter:additionalParameter forKey:parameterKey action:action];
                });
                
                it(@"should return correct parameters", ^{
                    NSDictionary *resultParameters = [testUser requestParametersForAction:action];
                    [[resultParameters should] equal:expectedParameters];
                });
                
            });
            
            context(@"change password", ^{
                
                beforeEach(^{
                    action = DVSActionChangePassword;
                    [testUser setRequestParameter:additionalParameter forKey:parameterKey action:action];
                });
                
                it(@"should return correct parameters", ^{
                    NSDictionary *resultParameters = [testUser requestParametersForAction:action];
                    [[resultParameters should] equal:expectedParameters];
                });
                
            });
            
            context(@"update", ^{
                
                beforeEach(^{
                    action = DVSActionUpdate;
                    [testUser setRequestParameter:additionalParameter forKey:parameterKey action:action];
                });
                
                it(@"should return correct parameters", ^{
                    NSDictionary *resultParameters = [testUser requestParametersForAction:action];
                    [[resultParameters should] equal:expectedParameters];
                });
                
            });
            
        });
        
        describe(@"set additional parameters for action", ^{
            
            __block NSDictionary *additionalParameters = nil;
            
            beforeEach(^{
                additionalParameters = @{@"color" : @"0xff0000"};
            });
            
            afterEach(^{
                additionalParameters = nil;
            });
            
            context(@"login", ^{
                
                beforeEach(^{
                    action = DVSActionLogin;
                    [testUser setRequestParameters:additionalParameters forAction:action];
                });
                
                it(@"should return correct parameters", ^{
                    NSDictionary *resultParameters = [testUser requestParametersForAction:action];
                    [[resultParameters should] equal:additionalParameters];
                });

            });
            
            context(@"registration", ^{
                
                beforeEach(^{
                    action = DVSActionRegistration;
                    [testUser setRequestParameters:additionalParameters forAction:action];
                });
                
                it(@"should return correct parameters", ^{
                    NSDictionary *resultParameters = [testUser requestParametersForAction:action];
                    [[resultParameters should] equal:additionalParameters];
                });

            });
            
            context(@"remind password", ^{
                
                beforeEach(^{
                    action = DVSActionRemindPassword;
                    [testUser setRequestParameters:additionalParameters forAction:action];
                });
                
                it(@"should return correct parameters", ^{
                    NSDictionary *resultParameters = [testUser requestParametersForAction:action];
                    [[resultParameters should] equal:additionalParameters];
                });

            });

            context(@"change password", ^{
                
                beforeEach(^{
                    action = DVSActionChangePassword;
                    [testUser setRequestParameters:additionalParameters forAction:action];
                });
                
                it(@"should return correct parameters", ^{
                    NSDictionary *resultParameters = [testUser requestParametersForAction:action];
                    [[resultParameters should] equal:additionalParameters];
                });

            });
            
            context(@"update", ^{
                
                beforeEach(^{
                    action = DVSActionUpdate;
                    [testUser setRequestParameters:additionalParameters forAction:action];
                });
                
                it(@"should return correct parameters", ^{
                    NSDictionary *resultParameters = [testUser requestParametersForAction:action];
                    [[resultParameters should] equal:additionalParameters];
                });

            });
            
        });
        
    });
    
});

SPEC_END
