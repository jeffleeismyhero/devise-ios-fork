//
//  DVSUserPersistenceSpec.m
//  Devise
//
//  Created by Radoslaw Szeja on 17/03/15.
//  Copyright 2015 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSTestUser.h"
#import "DVSUser+Persistence.h"


SPEC_BEGIN(DVSUserPersistenceSpec)

describe(@"DVSUserPersistence", ^{

    __block DVSTestUser *testUser = nil;
    __block NSData *encodedUser = nil;
    __block DVSTestUser *decodedUser = nil;
    
    afterEach(^{
        testUser = nil;
        encodedUser = nil;
        decodedUser = nil;
    });
    
    context(@"encoded user", ^{
        
        __block NSString *identifier = nil;
        __block NSString *email = nil;
        __block NSString *sessionToken = nil;
        __block NSString *name = nil;
        
        beforeEach(^{
            
            identifier = @"Fixture Identifier";
            email = @"example@address.org";
            sessionToken = @"Fixture Token";
            name = @"Fixture Name";
            
            testUser = [[DVSTestUser alloc] init];
            testUser.identifier = identifier;
            testUser.email = email;
            testUser.password = @"Fixture password";
            testUser.sessionToken = sessionToken;
            testUser.name = name;
            
            encodedUser = [NSKeyedArchiver archivedDataWithRootObject:testUser];
            decodedUser = [NSKeyedUnarchiver unarchiveObjectWithData:encodedUser];
            
        });
        
        afterEach(^{
            
            identifier = nil;
            email = nil;
            sessionToken = nil;
            name = nil;
            
        });
        
        it(@"should be decoded correctly", ^{
            [[decodedUser should] equal:testUser];
        });
        
        it(@"should have correct properties", ^{
            [[decodedUser.identifier    should] equal:identifier];
            [[decodedUser.email         should] equal:email];
            [[decodedUser.sessionToken  should] equal:sessionToken];
            [[decodedUser.name          should] equal:name];
            [[decodedUser.password      should] beNil];
        });
        
    });
    
});

SPEC_END
