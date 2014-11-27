//
//  NSURL+SaasKit.m
//  SaasKit
//
//  Created by Patryk Kaczmarek on 27.11.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "NSURL+SaasKit.h"

@implementation NSURL (SaasKit)

- (BOOL)ssk_hasValidSyntax {
    return (self && self.scheme && self.host);
}

@end
