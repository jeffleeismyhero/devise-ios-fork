//
//  DVSUserJSONSerializerSpec.m
//  Devise
//
//  Created by Radoslaw Szeja on 05/03/15.
//  Copyright 2015 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSTestUserJSONSerializer.h"
#import "DVSUserJSONSerializer+Serialize.h"
#import "DVSTestUser.h"


SPEC_BEGIN(DVSUserJSONSerializerSpec)

describe(@"DVSUserJSONSerializer", ^{

    __block DVSTestUserJSONSerializer *serializer = nil;
    
    context(@"when initialized", ^{
       
        beforeEach(^{
            serializer = [[DVSTestUserJSONSerializer alloc] init];
        });
        
        afterEach(^{
            serializer = nil;
        });
        
        it(@"should have default JSONKeyPathForEmail", ^{
            [[serializer.JSONKeyPathForEmail should] equal:@"email"];
        });
        
        it(@"should have default JSONKeyPathForPassword", ^{
            [[serializer.JSONKeyPathForPassword should] equal:@"password"];
        });
        
        it(@"should have default JSONKeyPathForPasswordConfirmation", ^{
            [[serializer.JSONKeyPathForPasswordConfirmation should] equal:@"passwordConfirmation"];
        });
      
        it(@"should have default JSONKeyPathForRemoteRoot", ^{
            [[serializer.JSONKeyPathForRemoteRoot should] equal:@"user"];
        });
        
        it(@"should have nil user", ^{
            [[serializer.user should] beNil];
        });
        
        describe(@"serialize", ^{
            __block DVSTestUser *testUser = nil;
            __block NSDictionary *testJSON = nil;
            
            beforeEach(^{
                testUser = [[DVSTestUser alloc] init];
            });
            
            afterEach(^{
                testUser = nil;
                testJSON = nil;
            });
            
            context(@"empty user", ^{
                
                beforeEach(^{
                    testJSON = @{ @"user": @{} };
                });
                
                it(@"registration should return empty devise like JSON", ^{
                    NSDictionary *resultJSONForNil = [serializer registerJSONDictionaryForUser:nil];
                    NSDictionary *resultJSON = [serializer registerJSONDictionaryForUser:testUser];
                    [[resultJSONForNil should] equal:testJSON];
                    [[resultJSON should] equal:testJSON];
                });
                
                it(@"login should return empty devise like JSON", ^{
                    NSDictionary *resultJSONForNil = [serializer loginJSONDictionaryForUser:nil];
                    NSDictionary *resultJSON = [serializer loginJSONDictionaryForUser:testUser];
                    [[resultJSONForNil should] equal:testJSON];
                    [[resultJSON should] equal:testJSON];
                });
                
                it(@"remind password should return empty devise like JSON", ^{
                    NSDictionary *resultJSONForNil = [serializer remindPasswordJSONDictionaryForUser:nil];
                    NSDictionary *resultJSON = [serializer remindPasswordJSONDictionaryForUser:testUser];
                    [[resultJSONForNil should] equal:testJSON];
                    [[resultJSON should] equal:testJSON];
                });
                
                
                it(@"change password should return empty devise like JSON", ^{
                    NSDictionary *resultJSONForNil = [serializer changePasswordJSONDictionaryForUser:nil];
                    NSDictionary *resultJSON = [serializer changePasswordJSONDictionaryForUser:testUser];
                    [[resultJSONForNil should] equal:testJSON];
                    [[resultJSON should] equal:testJSON];
                });
                
            });
            
            context(@"non empty user", ^{
                
                beforeEach(^{
                    testUser.name = @"John Appleseed";
                    testUser.email = @"john.appleseed@example.com";
                    testUser.password = @"$eCR3t";
                });
                
                afterEach(^{
                    testJSON = nil;
                });
                
                context(@"for registration", ^{
                    
                    beforeEach(^{
                        testJSON = @{
                            @"user": @{
                                @"email": testUser.email,
                                @"password": testUser.password
                            }
                        };
                    });
                    
                    it(@"should return correct JSON", ^{
                        NSDictionary *resultJSON = [serializer registerJSONDictionaryForUser:testUser];
                        [[resultJSON should] equal:testJSON];
                    });
                    
                });
                
                context(@"for login", ^{
                    
                    beforeEach(^{
                        testJSON = @{
                            @"user": @{
                                @"email": testUser.email,
                                @"password": testUser.password
                            }
                        };
                    });
                    
                    it(@"should return correct JSON", ^{
                        NSDictionary *resultJSON = [serializer loginJSONDictionaryForUser:testUser];
                        [[resultJSON should] equal:testJSON];
                    });
                    
                });
                
                context(@"for remind password", ^{
                    
                    beforeEach(^{
                        testJSON = @{ @"user": @{ @"email": testUser.email } };
                    });
                    
                    it(@"should return correct JSON", ^{
                        NSDictionary *resultJSON = [serializer remindPasswordJSONDictionaryForUser:testUser];
                        [[resultJSON should] equal:testJSON];
                    });
                    
                });
                
                context(@"for change password", ^{
                    
                    beforeEach(^{
                        testJSON = @{
                            @"user": @{
                                @"password": testUser.password,
                                @"passwordConfirmation": testUser.password
                            }
                        };
                    });
                    
                    it(@"should return correct JSON", ^{
                        NSDictionary *resultJSON = [serializer changePasswordJSONDictionaryForUser:testUser];
                        [[resultJSON should] equal:testJSON];
                    });
                    
                });
                
            });
            
        });
        
    });
    
});

SPEC_END
