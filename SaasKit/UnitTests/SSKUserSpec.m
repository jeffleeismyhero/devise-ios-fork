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

NSString * const kEmail = @"test@gmail.com";
NSString * const kUsername = @"ZeusTheGod";
NSString * const kPassword = @"MyVeRYStrongPassWoRd";

static NSString * const kIncorrectEmail = @"test@";

SPEC_BEGIN(SSKUserSpec)

describe(@"User", ^{
    
    __block NSError *testError = nil;
    __block SSKUser *user;
    __block SSKAPIManager *apiManager;
    
    beforeAll(^{
        [SaasKit initializeKitWithServerPath:@"www.google.com"];
    });
    
    beforeEach(^{
        user = [SSKUser user];
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
                SSKVoidBlock success = params[1];
                success();
                return nil;
            }];
        });
        
        it([NSString stringWithFormat:@"with wrong email syntax, should return error with code %d", SSKErrorInvalidSyntax], ^{
            user.email = kIncorrectEmail;
            [user remindPasswordWithSuccess:^{
                testError = nil;
            } failure:^(NSError *error) {
                testError = error;
            }];
            [[expectFutureValue(theValue (testError.code)) shouldEventually] equal:(theValue(SSKErrorInvalidSyntax))];
        });
        
        it(@"with correct email syntax, should not return error", ^{
            user.email = kEmail;
            [user remindPasswordWithSuccess:^{
                testError = nil;
            } failure:^(NSError *error) {
                testError = error;
            }];
            [[expectFutureValue(testError) shouldEventually] beNil];
        });
    });
    
    context(@"when trying to login", ^{
        beforeEach(^{
            [SSKAPIManager stub:@selector(loginUser:withSuccess:failure:) withBlock:^id(NSArray *params) {
                SSKVoidBlock success = params[1];
                success();
                return nil;
            }];
            
            //predefine properties to reduce single test declaration above
            user.password = kPassword;
            user.username = kUsername;
            user.email = kEmail;
        });
        
        it([NSString stringWithFormat:@"with wrong email syntax, should return error with code %d", SSKErrorInvalidSyntax], ^{
            user.email = kIncorrectEmail;
            [user loginWithSuccess:^{
                testError = nil;
            } failure:^(NSError *error) {
                testError = error;
            }];
            [[expectFutureValue(theValue (testError.code)) shouldEventually] equal:(theValue(SSKErrorInvalidSyntax))];
        });
        
        it([NSString stringWithFormat:@"with empty username, should return error with code %d", SSKErrorParamEmpty], ^{
            user.username = nil;
            user.loginMethod = SSKLoginUsingUsername;
            [user loginWithSuccess:^{
                testError = nil;
            } failure:^(NSError *error) {
                testError = error;
            }];
            [[expectFutureValue(theValue (testError.code)) shouldEventually] equal:(theValue(SSKErrorParamEmpty))];
        });
        
        it([NSString stringWithFormat:@"with empty password, should return error with code %d", SSKErrorParamEmpty], ^{
            user.password = nil;
            [user loginWithSuccess:^{
                testError = nil;
            } failure:^(NSError *error) {
                testError = error;
            }];
            [[expectFutureValue(theValue (testError.code)) shouldEventually] equal:(theValue(SSKErrorParamEmpty))];
        });
        
        it(@"with correct data, should not return error", ^{
            [user loginWithSuccess:^{
                testError = nil;
            } failure:^(NSError *error) {
                testError = error;
            }];
            [[expectFutureValue(testError) shouldEventually] beNil];
        });
        
    });
});


SPEC_END