//
//  DVSFacebookAuthenticatorSpec.m
//  Devise
//
//  Created by Radoslaw Szeja on 16/03/15.
//  Copyright 2015 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSTestFacebookAuthenticator.h"


SPEC_BEGIN(DVSFacebookAuthenticatorSpec)

describe(@"DVSFacebookAuthenticator", ^{
    
    __block DVSTestFacebookAuthenticator *authenticator;
    __block BOOL success;
    __block BOOL failure;
    
    beforeEach(^{
        authenticator = [[DVSTestFacebookAuthenticator alloc] initWithAppID:@"Fixture App ID"];
        success = NO;
        failure = NO;
    });
    
    afterEach(^{
        authenticator = nil;
    });
    
    context(@"succesful access request", ^{
        
        beforeEach(^{
            DVSFacebookAccountStore *facebookAccountStore = [DVSFacebookAccountStore dvs_stubFacebookAccountStore];
            
            [facebookAccountStore stub:@selector(requestAccessWithCompletion:) withBlock:^id(NSArray *params) {
                DVSAccountStoreBlock accountBlock = params[0];
                accountBlock(facebookAccountStore.account, nil);
                return nil;
            }];
            
        });
        
        context(@"successful request response", ^{

            __block NSDictionary *mockParameters = nil;
            __block NSDictionary *receivedParameters = nil;
            __block NSError *receivedError = nil;
            
            beforeEach(^{
                mockParameters = @{@"Fixture Key": @"Fixture Parameter"};
            });
            
            afterEach(^{
                mockParameters = nil;
                receivedParameters = nil;
                receivedError = nil;
            });
            
            context(@"valid response", ^{
                
                beforeEach(^{
                    NSData *responseData = [NSJSONSerialization dataWithJSONObject:mockParameters
                                                                           options:0
                                                                             error:nil];
                    
                    SLRequest *request = [SLRequest dvs_stubSLRequest];
                    
                    [request stub:@selector(performRequestWithHandler:) withBlock:^id(NSArray *params) {
                        SLRequestHandler completionHandler = params[0];
                        completionHandler(responseData, [NSHTTPURLResponse mock], nil);
                        return nil;
                    }];
                    
                    [authenticator stub:@selector(isResponseValid:) andReturn:theValue(YES)];
                    [authenticator stub:@selector(parametersFromUserData:token:) andReturn:mockParameters];
                    
                    
                    [authenticator authenticateWithSuccess:^(NSDictionary *dictionary) {
                        receivedParameters = dictionary;
                        success = YES;
                    } failure:^(NSError *error) {
                        receivedError = error;
                        failure = YES;
                    }];
                });
                
                it(@"should end with success", ^{
                    [[theValue(success) should] beTrue];
                });
                
                it(@"should not end with failure", ^{
                    [[theValue(failure) should] beFalse];
                });
                
                it(@"should receive parameters", ^{
                    [[receivedParameters should] equal:mockParameters];
                });
                
                it(@"should receive nil error", ^{
                    [[receivedError should] beNil];
                });
                
            });
            
            context(@"invalid response", ^{
                
                beforeEach(^{
                    NSData *responseData = [NSJSONSerialization dataWithJSONObject:mockParameters
                                                                           options:0
                                                                             error:nil];
                    
                    SLRequest *request = [SLRequest dvs_stubSLRequest];
                    
                    [request stub:@selector(performRequestWithHandler:) withBlock:^id(NSArray *params) {
                        SLRequestHandler completionHandler = params[0];
                        completionHandler(responseData, [NSHTTPURLResponse mock], nil);
                        return nil;
                    }];

                    [authenticator stub:@selector(isResponseValid:) andReturn:theValue(NO)];
                    
                    [authenticator authenticateWithSuccess:^(NSDictionary *dictionary) {
                        receivedParameters = dictionary;
                        success = YES;
                    } failure:^(NSError *error) {
                        receivedError = error;
                        failure = YES;
                    }];
                });
                
                it(@"should end with failure", ^{
                    [[theValue(failure) should] beTrue];
                });
                
                it(@"should not end with success", ^{
                    [[theValue(success) should] beFalse];
                });
                
                it(@"should receive error", ^{
                    [[receivedError shouldNot] beNil];
                });
                
            });
            
        });
        
        context(@"unsuccessful request response", ^{

            __block NSError *generatedError = nil;
            __block NSError *receivedError = nil;

            beforeEach(^{
                generatedError = [NSError mock];
                
                SLRequest *request = [SLRequest dvs_stubSLRequest];
                
                [request stub:@selector(performRequestWithHandler:) withBlock:^id(NSArray *params) {
                    SLRequestHandler completionHandler = params[0];
                    completionHandler(nil, nil, generatedError);
                    return nil;
                }];
                
                [authenticator authenticateWithSuccess:^(NSDictionary *dictionary) {
                    success = YES;
                } failure:^(NSError *error) {
                    receivedError = error;
                    failure = YES;
                }];
            });
            
            afterEach(^{
                receivedError = nil;
            });
            
            it(@"should end with failure", ^{
                [[theValue(failure) should] beTrue];
            });
            
            it(@"should not end with success", ^{
                [[theValue(success) should] beFalse];
            });
            
            it(@"should receive error", ^{
                [[receivedError should] equal:generatedError];
            });
        
        });
        
    });
    
    context(@"unsuccessful access request", ^{

        __block NSError *generatedError = nil;
        __block NSError *receivedError = nil;
        
        beforeEach(^{
            
            generatedError = [NSError mock];
            
            DVSFacebookAccountStore *facebookAccountStore = [DVSFacebookAccountStore dvs_stubFacebookAccountStore];
            
            [facebookAccountStore stub:@selector(requestAccessWithCompletion:) withBlock:^id(NSArray *params) {
                DVSAccountStoreBlock accountBlock = params[0];
                accountBlock(nil, generatedError);
                return nil;
            }];
            
            [authenticator authenticateWithSuccess:^(NSDictionary *dictionary) {
                success = YES;
            } failure:^(NSError *error) {
                receivedError = error;
                failure = YES;
            }];
        });
        
        afterEach(^{
            generatedError = nil;
            receivedError = nil;
        });
        
        it(@"should end with failure", ^{
            [[theValue(failure) should] beTrue];
        });
        
        
        it(@"should not end with success", ^{
            [[theValue(success) should] beFalse];
        });
        
        it(@"should receive error", ^{
            [[receivedError should] equal:generatedError];
        });
        
    });
    
});

SPEC_END
