//
//  OHHTTPStubs+DeviseDemoTests.h
//  Devise
//
//  Created by Wojciech Trzasko on 08.01.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

#import "OHHTTPStubs.h"

@interface OHHTTPStubs (DeviseDemoTests)

+ (id<OHHTTPStubsDescriptor>)dvs_stubUserRegisterRequestsWithOptions:(NSDictionary *)options;
+ (id<OHHTTPStubsDescriptor>)dvs_stubUserLogInRequestsWithOptions:(NSDictionary *)options;
+ (id<OHHTTPStubsDescriptor>)dvs_stubUserRemindPasswordRequestsWithOptions:(NSDictionary *)options;
+ (id<OHHTTPStubsDescriptor>)dvs_stubUserDeleteRequestsWithOptions:(NSDictionary *)options;
+ (id<OHHTTPStubsDescriptor>)dvs_stubUserUpdateRequestsWithOptions:(NSDictionary *)options;

@end
