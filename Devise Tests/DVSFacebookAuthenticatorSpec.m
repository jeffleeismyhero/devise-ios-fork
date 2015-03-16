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
        appID = @"ex@mpl3-App-ID";
    });
    
    afterEach(^{
        authenticator = nil;
        appID = nil;
        completionCalled = NO;
    });
    
    context(@"succesful access request", ^{
        
        beforeEach(^{
            DVSFacebookAccountStore *facebookAccountStore = [[DVSFacebookAccountStore alloc] init];
            ACAccountType *accountType = [facebookAccountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
            ACAccount *account = [[ACAccount alloc] initWithAccountType:accountType];
            
            [DVSFacebookAccountStore stub:@selector(accountForRequestAccess) andReturn:account];
        });
        
        context(@"successful request response", ^{

            __block NSDictionary *mockParameters = nil;
            __block NSDictionary *receivedParameters = nil;
            __block NSError *receivedError = nil;
            
            beforeEach(^{
                [SLRequest stub:@selector(urlResponse) andReturn:[NSHTTPURLResponse mock]];
            });
            
            afterEach(^{
                receivedError = nil;
            });
            
            context(@"valid response", ^{
                
                beforeEach(^{
                    mockParameters = @{@"example": @"parameter"};
                    
                    NSData *responseData = [NSJSONSerialization dataWithJSONObject:mockParameters
                                                                           options:0
                                                                             error:nil];
                    [SLRequest stub:@selector(responseData) andReturn:responseData];
                    
                    [authenticator stub:@selector(isResponseValid:) andReturn:theValue(YES)];
                    [authenticator stub:@selector(parametersFromUserData:oAuthToken:) andReturn:mockParameters];
                    
                    [authenticator signInUsingFacebookWithAppID:appID completion:^(NSDictionary *parameters, NSError *error) {
                        receivedParameters = parameters;
                        receivedError = error;
                        completionCalled = YES;
                    }];
                });
                
                it(@"should call completion", ^{
                    [[theValue(completionCalled) should] equal:theValue(YES)];
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
                    [authenticator stub:@selector(isResponseValid:) andReturn:theValue(NO)];
                    
                    [authenticator signInUsingFacebookWithAppID:appID completion:^(NSDictionary *parameters, NSError *error) {
                        receivedParameters = parameters;
                        receivedError = error;
                        completionCalled = YES;
                    }];
                });
                
                it(@"should call completion with error", ^{
                    [[theValue(completionCalled) should] equal:theValue(YES)];
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
                [SLRequest stub:@selector(responseError) andReturn:generatedError];
                
                [authenticator signInUsingFacebookWithAppID:appID completion:^(NSDictionary *parameters, NSError *error) {
                    receivedError = error;
                    completionCalled = YES;
                }];
            });
            
            afterEach(^{
                receivedError = nil;
            });
            
            it(@"should call completion with error", ^{
                [[theValue(completionCalled) should] equal:theValue(YES)];
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
            
            [DVSFacebookAccountStore stub:@selector(accountForRequestAccess) andReturn:nil];
            [DVSFacebookAccountStore stub:@selector(errorForRequestAccess) andReturn:generatedError];
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
            [[theValue(completionCalled) should] equal:theValue(YES)];
        });
        
        it(@"should receive error", ^{
            [[receivedError should] equal:generatedError];
        });
        
    });
    
});

SPEC_END
