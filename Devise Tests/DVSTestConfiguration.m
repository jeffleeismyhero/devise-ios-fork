//
//  DVSTestConfiguration.m
//  
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSTestConfiguration.h"

@interface DVSTestConfiguration ()

@property (assign, nonatomic) BOOL appendPathComponents;

@end

#pragma mark -

@implementation DVSTestConfiguration

- (instancetype)initWithServerURL:(NSURL *)serverURL appendPathComponents:(BOOL)append {
    self = [super initWithServerURL:serverURL];
    if (self == nil) return nil;
    self.appendPathComponents = append;
    return self;
}

- (NSURL *)baseURL {
    return (self.appendPathComponents) ? [super baseURL] : self.serverURL;
}

@end
