//
//  NSURL+SaasKit.m
//  SaasKit
//
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "NSURL+SaasKit.h"

@implementation NSURL (SaasKit)

- (BOOL)ssk_hasValidSyntax {
    return (self.scheme && self.host);
}

@end
