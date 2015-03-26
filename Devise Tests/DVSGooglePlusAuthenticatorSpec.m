//
//  DVSGooglePlusAuthenticatorSpec.m
//  Devise
//
//  Created by Radoslaw Szeja on 13/03/15.
//  Copyright 2015 Netguru Sp. z o.o. All rights reserved.
//

#import <ngrvalidator/NGRValidator/NGRPropertyValidator+NSDate.h>
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#import "NGRPropertyValidator+NSNumber.h"
#import "DVSTestGooglePlusAuthenticator.h"
#import "DVSUserManager.h"
#import "DVSHTTPClient+User.h"
#import "DVSOAuthJSONParameters.h"


SPEC_BEGIN(DVSGooglePlusAuthenticatorSpec)

describe(@"DVSGooglePlusAuthenticator", ^{

    NSString *clientID = @"Fixture Client ID";
    __block DVSTestGooglePlusAuthenticator *authenticator;
    
    context(@"authenticate with client ID", ^{
        
        beforeAll(^{
            authenticator = [[DVSTestGooglePlusAuthenticator alloc] init];
        });
        
        afterAll(^{
            authenticator = nil;
        });
        
        context(@"with success and failure block", ^{
        
            __block BOOL successBlockInvoked = NO;
            __block BOOL failureBlockInvoked = NO;
            __block NSError *receivedError = nil;
            __block GTLServicePlus *googlePlusService;

            beforeAll(^{
                googlePlusService = [authenticator googlePlusServiceWithAuthorizer:nil];
            });

            beforeEach(^{
                [authenticator stub:@selector(googlePlusServiceWithAuthorizer:) andReturn:googlePlusService];
                [authenticator stub:@selector(authenticate) withBlock:nil];
                
                [authenticator authenticateWithClientID:clientID success:^(NSDictionary *dictionary) {
                    successBlockInvoked = YES;
                } failure:^(NSError *error) {
                    receivedError = error;
                    failureBlockInvoked = YES;
                }];
            });

            afterEach(^{
                authenticator.success = nil;
                authenticator.failure = nil;
                
                successBlockInvoked = NO;
                failureBlockInvoked = NO;
                receivedError = nil;
            });

            context(@"succesfully authorized", ^{
                __block GTMOAuth2Authentication *auth = nil;
                
                beforeEach(^{
                    auth = [GTMOAuth2Authentication mock];
                    [auth stub:@selector(accessToken) andReturn:anything()];
                    
                    [DVSOAuthJSONParameters stub:@selector(dictionaryForParametersWithProvider:oAuthToken:userID:userEmail:) andReturn:[NSDictionary mock]];
                });
                
                context(@"succeeded on user data query", ^{
                    
                    beforeEach(^{
                        GTLServiceTicket *ticket = [GTLServiceTicket mock];
                        GTLPlusPerson *person = [GTLPlusPerson mock];
                        
                        [person stub:@selector(identifier) andReturn:anything()];
                        
                        [googlePlusService stub:@selector(executeQuery:completionHandler:) withBlock:^id(NSArray *params) {
                            void(^completion)(GTLServiceTicket *ticket, GTLPlusPerson *person, NSError *error) = params[1];
                            
                            completion(ticket, person, nil);
                            
                            return ticket;
                        }];
                        
                        DVSHTTPClient *httpClient = [DVSUserManager defaultManager].httpClient;
                        [httpClient stub:@selector(signInUsingGoogleUser:parameters:success:failure:) withBlock:^id(NSArray *params) {
                            
                            DVSVoidBlock successBlock = params[2];
                            successBlock();
                            return nil;
                            
                        }];
                        
                        [authenticator finishedWithAuth:auth error:nil];
                    });
                    
                    it(@"should invoke success block", ^{
                        [[theValue(successBlockInvoked) should] equal:theValue(YES)];
                        [[theValue(failureBlockInvoked) should] equal:theValue(NO)];
                    });
                    
                });
                
                context(@"failed on user data query", ^{
                    __block NSError *generatedError = nil;
                    
                    beforeEach(^{
                        generatedError = [NSError mock];
                        
                        [googlePlusService stub:@selector(executeQuery:completionHandler:) withBlock:^id(NSArray *params) {
                            void(^completion)(GTLServiceTicket *ticket, GTLPlusPerson *person, NSError *error) = params[1];
                            
                            completion(nil, nil, generatedError);
                            
                            return nil;
                        }];
                        
                        [authenticator finishedWithAuth:auth error:nil];
                    });
                    
                    afterEach(^{
                        generatedError = nil;
                    });
                    
                    it(@"should invoke failure block", ^{
                        [[theValue(successBlockInvoked) should] equal:theValue(NO)];
                        [[theValue(failureBlockInvoked) should] equal:theValue(YES)];
                    });
                    
                    it(@"should receive error", ^{
                        [[receivedError should] equal:generatedError];
                    });
                    
                });

            });
            
            context(@"unsuccesfully authorized", ^{
                __block NSError *generatedError = nil;
                
                beforeEach(^{
                    generatedError = [NSError mock];
                    [authenticator finishedWithAuth:nil error:generatedError];
                });
                
                afterEach(^{
                    successBlockInvoked = NO;
                    failureBlockInvoked = NO;
                    receivedError = nil;
                    generatedError = nil;
                });
                
                it(@"should invoke failure block", ^{
                    [[theValue(successBlockInvoked) should] equal:theValue(NO)];
                    [[theValue(failureBlockInvoked) should] equal:theValue(YES)];
                });
                
                it(@"should receive error", ^{
                    [[receivedError should] equal:generatedError];
                });
                
            });
            
            context(@"did disconnect during authentication", ^{
                __block NSError *generatedError = nil;

                beforeEach(^{
                    generatedError = [NSError mock];
                    [authenticator didDisconnectWithError:generatedError];
                });
                
                afterEach(^{
                    generatedError = nil;
                });
                
                it(@"should invoke failure block", ^{
                    [[theValue(successBlockInvoked) should] equal:theValue(NO)];
                    [[theValue(failureBlockInvoked) should] equal:theValue(YES)];
                });
                
            });
            
        });
        
    });
    
    context(@"authenticate with GPPSignIn instance", ^{
        
        __block BOOL successBlockInvoked = NO;
        __block BOOL failureBlockInvoked = NO;
        __block NSError *receivedError = nil;
        __block GTLServicePlus *googlePlusService;
        __block GPPSignIn *signIn = nil;

        beforeAll(^{
            authenticator = [[DVSTestGooglePlusAuthenticator alloc] init];
            googlePlusService = [authenticator googlePlusServiceWithAuthorizer:nil];
            signIn = [[GPPSignIn alloc] init];
        });
        
        beforeEach(^{
            [authenticator stub:@selector(googlePlusServiceWithAuthorizer:) andReturn:googlePlusService];
            [authenticator stub:@selector(authenticate) withBlock:nil];
            
            [authenticator authenticateWithClientID:clientID success:^(NSDictionary *dictionary) {
                successBlockInvoked = YES;
            } failure:^(NSError *error) {
                receivedError = error;
                failureBlockInvoked = YES;
            }];
        });
        
        afterEach(^{
            successBlockInvoked = NO;
            failureBlockInvoked = NO;
            receivedError = nil;
        });
        
        afterAll(^{
            authenticator = nil;
            googlePlusService = nil;
            signIn = nil;
        });
        
        context(@"succesfully authorized", ^{
            __block GTMOAuth2Authentication *auth = nil;
            
            beforeEach(^{
                auth = [GTMOAuth2Authentication mock];
                [auth stub:@selector(accessToken) andReturn:anything()];
                
                [DVSOAuthJSONParameters stub:@selector(dictionaryForParametersWithProvider:oAuthToken:userID:userEmail:) andReturn:[NSDictionary mock]];
            });
            
            context(@"succeeded on user data query", ^{
                
                beforeEach(^{
                    GTLServiceTicket *ticket = [GTLServiceTicket mock];
                    GTLPlusPerson *person = [GTLPlusPerson mock];
                    
                    [person stub:@selector(identifier) andReturn:anything()];
                    
                    [googlePlusService stub:@selector(executeQuery:completionHandler:) withBlock:^id(NSArray *params) {
                        void(^completion)(GTLServiceTicket *ticket, GTLPlusPerson *person, NSError *error) = params[1];
                        
                        completion(ticket, person, nil);
                        
                        return ticket;
                    }];
                    
                    DVSHTTPClient *httpClient = [DVSUserManager defaultManager].httpClient;
                    [httpClient stub:@selector(signInUsingGoogleUser:parameters:success:failure:) withBlock:^id(NSArray *params) {
                        
                        DVSVoidBlock successBlock = params[2];
                        successBlock();
                        return nil;
                        
                    }];
                    
                    [authenticator finishedWithAuth:auth error:nil];
                });
                
                it(@"should invoke success block", ^{
                    [[theValue(successBlockInvoked) should] equal:theValue(YES)];
                    [[theValue(failureBlockInvoked) should] equal:theValue(NO)];
                });
                
            });
            
            context(@"failed on user data query", ^{
                __block NSError *generatedError = nil;
                
                beforeEach(^{
                    generatedError = [NSError mock];
                    
                    [googlePlusService stub:@selector(executeQuery:completionHandler:) withBlock:^id(NSArray *params) {
                        void(^completion)(GTLServiceTicket *ticket, GTLPlusPerson *person, NSError *error) = params[1];
                        
                        completion(nil, nil, generatedError);
                        
                        return nil;
                    }];
                    
                    [authenticator finishedWithAuth:auth error:nil];
                });
                
                afterEach(^{
                    generatedError = nil;
                });
                
                it(@"should invoke failure block", ^{
                    [[theValue(successBlockInvoked) should] equal:theValue(NO)];
                    [[theValue(failureBlockInvoked) should] equal:theValue(YES)];
                });
                
                it(@"should receive error", ^{
                    [[receivedError should] equal:generatedError];
                });
                
            });
            
        });
        
        context(@"unsuccesfully authorized", ^{
            __block NSError *generatedError = nil;
            
            beforeEach(^{
                generatedError = [NSError mock];
                [authenticator finishedWithAuth:nil error:generatedError];
            });
            
            afterEach(^{
                successBlockInvoked = NO;
                failureBlockInvoked = NO;
                receivedError = nil;
                generatedError = nil;
            });
            
            it(@"should invoke failure block", ^{
                [[theValue(successBlockInvoked) should] equal:theValue(NO)];
                [[theValue(failureBlockInvoked) should] equal:theValue(YES)];
            });
            
            it(@"should receive error", ^{
                [[receivedError should] equal:generatedError];
            });
            
        });
        
        context(@"did disconnect during authentication", ^{
            __block NSError *generatedError = nil;
            
            beforeEach(^{
                generatedError = [NSError mock];
                [authenticator didDisconnectWithError:generatedError];
            });
            
            afterEach(^{
                generatedError = nil;
            });
            
            it(@"should invoke failure block", ^{
                [[theValue(successBlockInvoked) should] equal:theValue(NO)];
                [[theValue(failureBlockInvoked) should] equal:theValue(YES)];
            });
            
        });
        
    });
    
});

SPEC_END
