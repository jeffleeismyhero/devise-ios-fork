//
//  DVSTestUser.m
//  
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSTestConfiguration.h"
#import "DVSTestUser.h"

@implementation DVSTestUser

@synthesize identifier = _identifier;
@synthesize sessionToken = _sessionToken;

- (NSArray *)propertiesToPersistByName {
    return @[ @"name" ];
}

@end
