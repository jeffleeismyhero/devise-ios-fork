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

static DVSConfiguration *_dvs_testUser_configuration = nil;

+ (DVSConfiguration *)configuration {
    if (_dvs_testUser_configuration != nil) return _dvs_testUser_configuration;
    return (_dvs_testUser_configuration = [[DVSTestConfiguration alloc] initWithServerURL:nil appendPathComponents:NO]);
}

+ (void)setConfiguration:(DVSConfiguration *)configuration {
    _dvs_testUser_configuration = configuration;
}

@end
