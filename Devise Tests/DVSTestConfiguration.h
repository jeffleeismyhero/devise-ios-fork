//
//  DVSTestConfiguration.h
//  
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <Devise/Devise.h>
#import <Foundation/Foundation.h>

@interface DVSTestConfiguration : DVSConfiguration

/**
 *  Initializes a test configuration object.
 *
 *  @param serverURL The server base URL to use.
 *  @param append    Whether to append path components when computing base URL.
 */
- (instancetype)initWithServerURL:(NSURL *)serverURL appendPathComponents:(BOOL)append;

@end
