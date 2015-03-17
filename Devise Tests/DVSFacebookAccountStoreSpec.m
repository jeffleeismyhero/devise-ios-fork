//
//  DVSFacebookAccountStoreSpec.m
//  Devise
//
//  Created by Radoslaw Szeja on 16/03/15.
//  Copyright 2015 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSTestFacebookAccountStore.h"


SPEC_BEGIN(DVSFacebookAccountStoreSpec)

describe(@"DVSFacebookAccountStore", ^{
    
    __block DVSTestFacebookAccountStore *facebookAccountStore = nil;
    
    context(@"when initilized", ^{
        
        __block NSString *appIDKey = nil;
        __block NSArray *permissions = nil;
        
        beforeEach(^{
            appIDKey = @"@pp!dk3y";
            permissions = @[@"email"];
            facebookAccountStore = [[DVSTestFacebookAccountStore alloc] initWithAppIDkey:appIDKey permissions:permissions];
            
            ACAccountType *accountType = [facebookAccountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
            ACAccount *account = [[ACAccount alloc] initWithAccountType:accountType];
            
            [facebookAccountStore stub:@selector(account) andReturn:account];
        });
        
        afterEach(^{
            facebookAccountStore = nil;
        });
        
        it(@"should have options", ^{
            NSDictionary *options = @{
              ACFacebookAppIdKey : appIDKey,
              ACFacebookPermissionsKey : permissions,
              ACFacebookAudienceKey : ACFacebookAudienceOnlyMe
            };
            
            [[facebookAccountStore.options should] equal:options];
        });
        
        describe(@"request access", ^{
            __block ACAccount *receivedAccount = nil;
            __block NSError *receivedError = nil;

            afterEach(^{
                receivedAccount = nil;
                receivedError = nil;
            });
            
            context(@"access to account granted", ^{
                
                beforeEach(^{
                    [facebookAccountStore stub:@selector(requestAccessToAccountsWithType:options:completion:) withBlock:^id(NSArray *params) {
                        void(^completionHandler)(BOOL granted, NSError *error) = (id)params[2];
                        completionHandler(YES, nil);
                        return nil;
                    }];
                });
                
                context(@"account renewed", ^{
                    
                    beforeEach(^{
                        [facebookAccountStore stub:@selector(renewCredentialsForAccount:completion:) withBlock:^id(NSArray *params) {
                            ACAccountStoreCredentialRenewalHandler completionHandler = (id)params[1];
                            completionHandler(ACAccountCredentialRenewResultRenewed, nil);
                            return nil;
                        }];
                        
                        [facebookAccountStore requestAccessWithCompletion:^(ACAccount *account, NSError *error) {
                            receivedAccount = account;
                            receivedError = error;
                        }];
                    });
                    
                    afterEach(^{
                        receivedAccount = nil;
                        receivedError = nil;
                    });
                    
                    it(@"should receive account", ^{
                        [[receivedAccount shouldNot] beNil];
                    });
                    
                    it(@"should not receive error", ^{
                        [[receivedError should] beNil];
                    });
                    
                });
                
                context(@"account not renewed", ^{
                   
                    __block NSError *generatedError = nil;
                    
                    beforeEach(^{
                        generatedError = [NSError mock];
                        
                        [facebookAccountStore stub:@selector(renewCredentialsForAccount:completion:) withBlock:^id(NSArray *params) {
                            ACAccountStoreCredentialRenewalHandler completionHandler = (id)params[1];
                            completionHandler(ACAccountCredentialRenewResultFailed, generatedError);
                            return nil;
                        }];
                        
                        [facebookAccountStore requestAccessWithCompletion:^(ACAccount *account, NSError *error) {
                            receivedAccount = account;
                            receivedError = error;
                        }];
                    });
                    
                    afterEach(^{
                        receivedAccount = nil;
                        receivedError = nil;
                    });
                    
                    it(@"should not receive account", ^{
                        [[receivedAccount should] beNil];
                    });
                    
                    it(@"should receive error", ^{
                        [[receivedError should] equal:generatedError];
                    });

                });
                
            });
            
            context(@"access to account not granted", ^{
                
                __block NSError *generatedError = nil;
                __block NSError *receivedError = nil;
                
                beforeEach(^{
                    generatedError = [NSError mock];
                    
                    [facebookAccountStore stub:@selector(requestAccessToAccountsWithType:options:completion:) withBlock:^id(NSArray *params) {
                        void(^completionHandler)(BOOL granted, NSError *error) = (id)params[2];
                        completionHandler(NO, generatedError);
                        return nil;
                    }];
                    
                    [facebookAccountStore requestAccessWithCompletion:^(ACAccount *account, NSError *error) {
                        receivedError = error;
                    }];
                });
                
                afterEach(^{
                    generatedError = nil;
                    receivedError = nil;
                });
                
                it(@"should receive error", ^{
                    [[receivedError should] equal:generatedError];
                });
                
            });
            
        });
        
    });
    
});

SPEC_END
