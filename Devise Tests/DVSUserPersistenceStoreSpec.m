//
//  DVSUserPersistenceStoreSpec.m
//  Devise
//
//  Created by Radoslaw Szeja on 04/03/15.
//  Copyright 2015 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSTestUserPersistenceStore.h"
#import "UICKeyChainStore/UICKeyChainStore.h"

#import "DVSTestUser.h"
#import "DVSTestConfiguration.h"

SPEC_BEGIN(DVSUserPersistenceStoreSpec)

describe(@"DVSUserPersistenceStore", ^{
    
    __block DVSTestUserPersistenceStore *persistenceStore = nil;
    __block DVSConfiguration *testConfiguration = nil;
    __block DVSTestUser *testUser = nil;

    beforeEach(^{
        NSURL *serverURL = [NSURL URLWithString:@"http://example.com/"];
        testConfiguration = [[DVSTestConfiguration alloc] initWithServerURL:serverURL];
        persistenceStore = [[DVSTestUserPersistenceStore alloc] initWithConfiguration:testConfiguration];
    });

    context(@"when newly initialized", ^{
        
        it(@"should use custom configuration", ^{
            [[persistenceStore.configuration should] beIdenticalTo:testConfiguration];
        });

        it(@"should have non nil local user", ^{
            [[persistenceStore.localUser should] beNonNil];
        });
    });
    
    describe(@"local user", ^{
        
        beforeEach(^{
            testUser = [[DVSTestUser alloc] init];
            testUser.email = @"john.appleseed@example.com";
        });
        
        context(@"no user assigned before", ^{
            
            beforeEach(^{
                persistenceStore.localUser = nil;
                persistenceStore = [[DVSTestUserPersistenceStore alloc] initWithConfiguration:[DVSConfiguration sharedConfiguration]];
            });
            
            it(@"should have non nil user", ^{
                [[persistenceStore.localUser shouldNot] beNil];
                [[persistenceStore.localUser.email should] beNil];
            });
        });
        
        context(@"read from persistence store", ^{
            
            beforeEach(^{
                persistenceStore.localUser = testUser;
                persistenceStore = [[DVSTestUserPersistenceStore alloc] initWithConfiguration:[DVSConfiguration sharedConfiguration]];

                DVSConfiguration *configuration = [DVSConfiguration sharedConfiguration];
                NSData *archivedTestUser = [NSKeyedArchiver archivedDataWithRootObject:testUser];
                [given([UICKeyChainStore dataForKey:configuration.resourceName service:configuration.keychainServiceName]) willReturn:archivedTestUser];
            });
            
            it(@"should be same as test user", ^{
                DVSUser *user = persistenceStore.localUser;
                [[user should] equal:testUser];
                [[user.email should] equal:testUser.email];
            });
            
        });
        
        context(@"new user assigned", ^{
            
            beforeEach(^{
                persistenceStore.localUser = testUser;
            });
            
            it(@"should not be nil", ^{
                [[persistenceStore.localUser shouldNot] beNil];
            });
            
            it(@"should be same as new user", ^{
                [[persistenceStore.localUser should] beIdenticalTo:testUser];
            });
            
        });
        
        context(@"nil assigned", ^{
            
            beforeEach(^{
                persistenceStore.localUser = nil;
            });
            
            it(@"should be nil", ^{
                [[persistenceStore.localUser should] beNil];
            });
            
        });
        
    });
});

SPEC_END
