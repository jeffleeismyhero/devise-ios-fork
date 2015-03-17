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
    __block NSString *appID = nil;
    __block BOOL completionCalled = NO;
    
    beforeEach(^{
        authenticator = [[DVSTestFacebookAuthenticator alloc] init];
        appID = @"Fixture App ID";
    });
    
    afterEach(^{
        authenticator = nil;
        appID = nil;
        completionCalled = NO;
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
                    [authenticator stub:@selector(parametersFromUserData:oAuthToken:) andReturn:mockParameters];
                    
                    [authenticator signInUsingFacebookWithAppID:appID completion:^(NSDictionary *parameters, NSError *error) {
                        receivedParameters = parameters;
                        receivedError = error;
                        completionCalled = YES;
                    }];
                });
                
                it(@"should call completion", ^{
                    [[theValue(completionCalled) should] beTrue];
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
                    
                    [authenticator signInUsingFacebookWithAppID:appID completion:^(NSDictionary *parameters, NSError *error) {
                        receivedParameters = parameters;
                        receivedError = error;
                        completionCalled = YES;
                    }];
                });
                
                it(@"should call completion with error", ^{
                    [[theValue(completionCalled) should] beTrue];
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
                
                [authenticator signInUsingFacebookWithAppID:appID completion:^(NSDictionary *parameters, NSError *error) {
                    receivedError = error;
                    completionCalled = YES;
                }];
            });
            
            afterEach(^{
                receivedError = nil;
            });
            
            it(@"should call completion with error", ^{
                [[theValue(completionCalled) should] beTrue];
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
            
            [authenticator signInUsingFacebookWithAppID:appID completion:^(NSDictionary *parameters, NSError *error) {
                receivedError = error;
                completionCalled = YES;
            }];
            
        });
        
        afterEach(^{
            generatedError = nil;
            receivedError = nil;
        });
        
        it(@"should call completion with error", ^{
            [[theValue(completionCalled) should] beTrue];
        });
        
        it(@"should receive error", ^{
            [[receivedError should] equal:generatedError];
        });
        
    });
    
});

SPEC_END
