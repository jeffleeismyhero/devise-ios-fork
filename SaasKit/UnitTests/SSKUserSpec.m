//
//  SSKUserSpec.m
//  SaasKit
//
//  Created by Patryk Kaczmarek on 24.11.2014.
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import "Kiwi.h"
#import "SaasKit.h"
#import "SSKErrorTranslate.h"
#import "SSKAPIManager.h"

SPEC_BEGIN(SSKUserSpec)

describe(@"User", ^{
    
    __block NSError *testError = nil;
    __block SSKUser *user;
    __block SSKAPIManager *apiManager;
    
    beforeAll(^{
        [SaasKit initializeKitWithServerPath:@"www.wp.pl"];
    });
    
    beforeEach(^{
        user = [SSKUser user];
        user.username = @"username";
        user.password = @"password";
    });
    
    afterEach(^{
        user = nil;
        apiManager = nil;
        testError = nil;
    });
    
    it(@"instance should exist", ^{
        [user shouldNotBeNil];
    });
    
    context(@"when trying remind password", ^{
        beforeEach(^{
            [SSKAPIManager stub:@selector(remindPasswordForUser:withSuccess:failure:) withBlock:^id(NSArray *params) {
                SSKVoidBlock successBlock = params[1];
                successBlock();
                return nil;
            }];
        });
        
        it(@"with wrong email syntax, should return error with correct code", ^{
            user.email = @"email";
            [user remindPasswordWithSuccess:^{
                testError = nil;
            } failure:^(NSError *error) {
                testError = error;
            }];
            [[expectFutureValue (theValue (testError.code)) shouldEventually] equal:(theValue(SSKErrorEmailSyntaxError))];
        });
        
        it(@"with correct email syntax, should not return error", ^{
            user.email = @"email@gmail.com";
            [user remindPasswordWithSuccess:^{
                testError = nil;
            } failure:^(NSError *error) {
                testError = error;
            }];
            [[expectFutureValue(testError) shouldEventually] beNil];
        });
    });
});

SPEC_END