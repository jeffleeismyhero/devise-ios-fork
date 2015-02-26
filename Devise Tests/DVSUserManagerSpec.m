//
//  DVSUserManagerSpec.m
//  Devise
//
//  Created by Pawel Bialecki on 26.02.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSUserManager.h"
#import "DVSUserPersistenceManager.h"
#import "DVSTestUser.h"
#import "DVSTestConfiguration.h"

SPEC_BEGIN(DVSUserManagerSpec)

describe(@"DVSUserManagerSpec", ^{
    
    __block DVSUserManager *userManager = nil;
    
    context(@"when newly initialized", ^{
        
        beforeEach(^{
            userManager = [DVSUserManager defaultManager];
        });
        
        it(@"should be initialized as shared manager", ^{
            [[expectFutureValue(userManager) should] beIdenticalTo:[DVSUserManager defaultManager]];
        });
        
    });
    
    __block DVSUserPersistenceManager *persistanceManager = nil;
    __block DVSTestUser *testUser = nil;
    __block DVSTestConfiguration *testConfiguration = nil;
    
    beforeEach(^{
        NSURL *serverURL = [NSURL URLWithString:@"http://devise-tests/"];
        testConfiguration = [[DVSTestConfiguration alloc] initWithServerURL:serverURL appendPathComponents:NO];
        
        [[testUser class] setConfiguration:testConfiguration];
        testUser = [[DVSTestUser alloc] init];
        userManager = [[DVSUserManager alloc] initWithUser:testUser configuration:testConfiguration];
        persistanceManager = [DVSUserPersistenceManager sharedPersistenceManager];
    });
    
    describe(@"registering a user", ^{
        
        __block id<OHHTTPStubsDescriptor> stub = nil;
        
        beforeAll(^{
            stub = [OHHTTPStubs dvs_stubUserRegisterRequestsWithOptions:nil];
        });
        
        afterAll(^{
            [OHHTTPStubs removeStub:stub];
        });
        
        context(@"using correct data", ^{
            
            beforeEach(^{
                testUser.email = @"john.appleseed@example.com";
                testUser.password = @"$eCR3t";
            });
            
            it(@"should succeed", ^{
                __block BOOL success = NO;
                [userManager registerWithSuccess:^{
                    success = YES;
                } failure:nil];
                [[expectFutureValue(theValue(success)) shouldEventually] beTrue];
            });
            
            it(@"should fill the user object", ^{
                [userManager registerWithSuccess:nil failure:nil];
                [[expectFutureValue(testUser.identifier) shouldEventually] beNonNil];
                [[expectFutureValue(testUser.sessionToken) shouldEventually] beNonNil];
            });
            
            it(@"should save the user locally", ^{
                [userManager registerWithSuccess:nil failure:nil];
                [[expectFutureValue(persistanceManager.localUser) shouldEventually] equal:testUser];
            });
            
        });
       
    describe(@"validation", ^{
            
        context(@"using no email", ^{
                
            beforeEach(^{
                testUser.email = nil;
                testUser.password = @"$eCR3t";
            });
                
            it(@"should fail", ^{
                __block BOOL failure = NO;
                [userManager registerWithSuccess:nil failure:^(NSError *error) {
                    failure = YES;
                }];
                [[expectFutureValue(theValue(failure)) shouldEventually] beTrue];
            });
                
        });
            
        context(@"using email with invalid syntax", ^{
                
            beforeEach(^{
                testUser.email = @"john.appleseed.example.com";
                testUser.password = @"$eCR3t";
            });
                
            it(@"should fail", ^{
                __block BOOL failure = NO;
                [userManager registerWithSuccess:nil failure:^(NSError *error) {
                    failure = YES;
                }];
                [[expectFutureValue(theValue(failure)) shouldEventually] beTrue];
            });
                
        });
            
        context(@"using no password", ^{
                
            beforeEach(^{
                testUser.email = @"john.appleseed@example.com";
                testUser.password = nil;
            });
                
            it(@"should fail", ^{
                __block BOOL failure = NO;
                [userManager registerWithSuccess:nil failure:^(NSError *error) {
                    failure = YES;
                }];
                [[expectFutureValue(theValue(failure)) shouldEventually] beTrue];
            });
                
        });
            
    });
        
    describe(@"updating user's email", ^{
            
        __block id<OHHTTPStubsDescriptor> stub = nil;
            
        beforeAll(^{
            stub = [OHHTTPStubs dvs_stubUserUpdateRequestsWithOptions:nil];
        });
            
        afterAll(^{
            [OHHTTPStubs removeStub:stub];
        });
            
        context(@"when authorized", ^{
                
            beforeEach(^{
                testUser.identifier = @"1";
                testUser.email = @"john.appleseed@example.com";
                testUser.sessionToken = @"xXx_s3ss10N_t0K3N_xXx";
                [persistanceManager setLocalUser:testUser];
            });
                
            context(@"using correct data", ^{
                    
                beforeEach(^{
                    testUser.email = @"john.appleseed@example.com";
                });
                    
                it(@"should succeed", ^{
                    __block BOOL success = NO;
                    [userManager updateWithSuccess:^{
                        success = YES;
                    } failure:nil];
                    [[expectFutureValue(theValue(success)) shouldEventually] beTrue];
                });
                    
            });
                
        describe(@"validation", ^{
                    
            context(@"using no email", ^{
                        
                beforeEach(^{
                    testUser.email = nil;
                });
                        
                it(@"should fail", ^{
                    __block BOOL failure = NO;
                    [userManager updateWithSuccess:nil failure:^(NSError *error) {
                        failure = YES;
                    }];
                    [[expectFutureValue(theValue(failure)) shouldEventually] beTrue];
                });
                        
            });
                    
            context(@"using email with invalid syntax", ^{
                        
                beforeEach(^{
                    testUser.email = @"john.appleseed.example.com";
                });
                        
                it(@"should fail", ^{
                    __block BOOL failure = NO;
                    [userManager updateWithSuccess:nil failure:^(NSError *error) {
                        failure = YES;
                    }];
                    [[expectFutureValue(theValue(failure)) shouldEventually] beTrue];
                });
                        
            });
                    
        });
                
    });
        
    describe(@"deleting a user", ^{
            
        __block id<OHHTTPStubsDescriptor> stub = nil;
            
        beforeAll(^{
            stub = [OHHTTPStubs dvs_stubUserDeleteRequestsWithOptions:nil];
        });
            
        afterAll(^{
            [OHHTTPStubs removeStub:stub];
        });
            
        context(@"when authorized", ^{
                
            beforeEach(^{
                testUser.identifier = @"1";
                testUser.email = @"john.appleseed@example.com";
                testUser.sessionToken = @"xXx_s3ss10N_t0K3N_xXx";
                [persistanceManager setLocalUser:testUser];
            });
                
            context(@"using correct data", ^{
                    
                it(@"should succeed", ^{
                    __block BOOL success = NO;
                    [userManager deleteAccountWithSuccess:^{
                        success = YES;
                    } failure:nil];
                    [[expectFutureValue(theValue(success)) shouldEventually] beTrue];
                });
                    
                it(@"should remove the locally saved user", ^{
                    [userManager deleteAccountWithSuccess:nil failure:nil];
                    [[expectFutureValue(persistanceManager.localUser) shouldEventually] beNil];
                });
                    
            });
                
        });
            
    });
        
    describe(@"changing password of a user", ^{
        
        __block id<OHHTTPStubsDescriptor> stub = nil;
        
        beforeAll(^{
            stub = [OHHTTPStubs dvs_stubUserChangePasswordRequestsWithOptions:nil];
        });
        
        afterAll(^{
            [OHHTTPStubs removeStub:stub];
        });
        
        context(@"when authorized", ^{
            
            beforeEach(^{
                testUser.identifier = @"1";
                testUser.email = @"john.appleseed@example.com";
                testUser.sessionToken = @"xXx_s3ss10N_t0K3N_xXx";
                [persistanceManager setLocalUser:testUser];
            });
            
            context(@"using correct data", ^{
                
                beforeEach(^{
                    testUser.password = @"n3w_$eCR3t";
                });
                
                it(@"should succeed", ^{
                    __block BOOL success = NO;
                    [userManager changePasswordWithSuccess:^{
                        success = YES;
                    } failure:nil];
                    [[expectFutureValue(theValue(success)) shouldEventually] beTrue];
                });
                
            });
            
            describe(@"validation", ^{
                
                context(@"using no password", ^{
                    
                    beforeEach(^{
                        testUser.password = nil;
                    });
                    
                    it(@"should fail", ^{
                        __block BOOL failure = NO;
                        [userManager changePasswordWithSuccess:nil failure:^(NSError *error) {
                            failure = YES;
                        }];
                        [[expectFutureValue(theValue(failure)) shouldEventually] beTrue];
                    });
                    
                });
                
            });
            
        });
        
    });
    
    describe(@"reminding password to a user", ^{
        
        __block id<OHHTTPStubsDescriptor> stub = nil;
        
        beforeAll(^{
            stub = [OHHTTPStubs dvs_stubUserRemindPasswordRequestsWithOptions:nil];
        });
        
        afterAll(^{
            [OHHTTPStubs removeStub:stub];
        });
        
        context(@"using correct data", ^{
            
            beforeEach(^{
                testUser.email = @"john.appleseed@example.com";
            });
            
            it(@"should succeed", ^{
                __block BOOL success = NO;
                [userManager remindPasswordWithSuccess:^{
                    success = YES;
                } failure:nil];
                [[expectFutureValue(theValue(success)) shouldEventually] beTrue];
            });
            
        });
        
        describe(@"validation", ^{
            
            context(@"using no email", ^{
                
                beforeEach(^{
                    testUser.email = nil;
                });
                
                it(@"should fail", ^{
                    __block BOOL failure = NO;
                    [userManager remindPasswordWithSuccess:nil failure:^(NSError *error) {
                        failure = YES;
                    }];
                    [[expectFutureValue(theValue(failure)) shouldEventually] beTrue];
                });
                
            });
            
            context(@"using email with invalid syntax", ^{
                
                beforeEach(^{
                    testUser.email = @"john.appleseed.example.com";
                });
                
                it(@"should fail", ^{
                    __block BOOL failure = NO;
                    [userManager remindPasswordWithSuccess:nil failure:^(NSError *error) {
                        failure = YES;
                    }];
                    [[expectFutureValue(theValue(failure)) shouldEventually] beTrue];
                });
                
            });
            
        });
        
    });
    
    describe(@"loggin out a user", ^{
        
        context(@"when authorized", ^{
            
            beforeEach(^{
                testUser.identifier = @"1";
                testUser.email = @"john.appleseed@example.com";
                testUser.sessionToken = @"xXx_s3ss10N_t0K3N_xXx";
                [persistanceManager setLocalUser:testUser];
            });
            
            it(@"should remove locally saved user", ^{
                [userManager logout];
                [[expectFutureValue(persistanceManager.localUser) shouldNotEventually] beIdenticalTo:testUser];
            });
        });
    });
    
    describe(@"serialized user", ^{
        
        __block DVSTestUser *decodedUser;
        __block NSMutableData *archivedData;
        
        beforeEach(^{
            testUser.identifier = @"1";
            testUser.email = @"john.appleseed@example.com";
            testUser.sessionToken = @"xXx_s3ss10N_t0K3N_xXx";
            testUser.name = @"John";
            [persistanceManager setLocalUser:testUser];
            
            archivedData = [NSMutableData data];
            NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:archivedData];
            NSString *userObjectKey = @"userKey";
            
            [archiver encodeObject:testUser forKey:userObjectKey];
            [archiver finishEncoding];
            
            NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:[archivedData copy]];
            decodedUser = (DVSTestUser *)[unarchiver decodeObjectOfClass:[DVSTestUser class] forKey:userObjectKey];
        });
        
        it(@"should have been saved", ^{
            [[expectFutureValue(@([archivedData length])) shouldEventually] beGreaterThan:@0];
        });
        
        it(@"should equal after decode", ^{
            [[expectFutureValue(decodedUser) shouldEventually] equal:testUser];
        });
        
        it(@"should have additional parameter", ^{
            [[expectFutureValue(decodedUser.name) shouldEventually] beNonNil];
        });
        
    });
        
});
        
});
    
});


SPEC_END
