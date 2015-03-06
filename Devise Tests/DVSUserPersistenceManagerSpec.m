//
//  DVSUserPersistenceManagerSpec.m
//  Devise
//
//  Created by Radoslaw Szeja on 04/03/15.
//  Copyright 2015 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSTestUserPersistenceManager.h"
#import "UICKeyChainStore/UICKeyChainStore.h"

#import "DVSTestUser.h"
#import "DVSTestConfiguration.h"

SPEC_BEGIN(DVSUserPersistenceManagerSpec)

describe(@"DVSUserPersistenceManager", ^{
    
    __block DVSTestUserPersistenceManager *manager = nil;
    __block DVSTestUser *testUser = nil;

    beforeEach(^{
        manager = [DVSTestUserPersistenceManager sharedPersistenceManager];
    });

    context(@"when newly initialized", ^{
        __block DVSConfiguration *testConfiguration = nil;

        beforeEach(^{
            NSURL *serverURL = [NSURL URLWithString:@"http://example.com/"];
            testConfiguration = [[DVSTestConfiguration alloc] initWithServerURL:serverURL];
        });
        
        it(@"should be initilized", ^{
            [[manager should] beIdenticalTo:[DVSTestUserPersistenceManager sharedPersistenceManager]];
        });
        
        it(@"should use shared configuration", ^{
            [[manager.configuration should] beIdenticalTo:[DVSConfiguration sharedConfiguration]];
        });
        
        it(@"should use custom configuration", ^{
            manager = [[DVSTestUserPersistenceManager alloc] initWithConfiguration:testConfiguration];
            [[manager.configuration should] beIdenticalTo:testConfiguration];
        });

        it(@"should have non nil local user", ^{
            [[manager.localUser should] beNonNil];
        });

    });
    
    describe(@"local user", ^{
        
        beforeEach(^{
            testUser = [[DVSTestUser alloc] init];
            testUser.email = @"john.appleseed@example.com";
        });
        
        context(@"no user assigned before", ^{
            
            beforeEach(^{
                manager.localUser = nil;
                manager = [[DVSTestUserPersistenceManager alloc] initWithConfiguration:[DVSConfiguration sharedConfiguration]];
            });
            
            it(@"should have non nil user", ^{
                [[manager.localUser shouldNot] beNil];
                [[manager.localUser.email should] beNil];
            });
        });
        
        context(@"read from persistence store", ^{
            
            beforeEach(^{
                manager.localUser = testUser;
                manager = [[DVSTestUserPersistenceManager alloc] initWithConfiguration:[DVSConfiguration sharedConfiguration]];

                DVSConfiguration *configuration = [DVSConfiguration sharedConfiguration];
                NSData *archivedTestUser = [NSKeyedArchiver archivedDataWithRootObject:testUser];
                [given([UICKeyChainStore dataForKey:configuration.resourceName service:configuration.keychainServiceName]) willReturn:archivedTestUser];
            });
            
            it(@"should be same as test user", ^{
                DVSUser *user = manager.localUser;
                [[user should] equal:testUser];
                [[user.email should] equal:testUser.email];
            });
            
        });
        
        context(@"new user assigned", ^{
            
            beforeEach(^{
                manager.localUser = testUser;
            });
            
            it(@"should not be nil", ^{
                [[manager.localUser shouldNot] beNil];
            });
            
            it(@"should be same as new user", ^{
                [[manager.localUser should] beIdenticalTo:testUser];
            });
            
        });
        
        context(@"nil assigned", ^{
            
            beforeEach(^{
                manager.localUser = nil;
            });
            
            it(@"should be nil", ^{
                [[manager.localUser should] beNil];
            });
            
        });
        
    });
});

SPEC_END
