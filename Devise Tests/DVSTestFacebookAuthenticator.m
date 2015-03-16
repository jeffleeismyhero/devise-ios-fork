//
//  DVSTestFacebookAuthenticator.m
//  Devise
//
//  Created by Radoslaw Szeja on 16/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSTestFacebookAuthenticator.h"

@implementation DVSTestFacebookAuthenticator

@end


@implementation DVSFacebookAccountStore (DeviseTests)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
- (void)requestAccessWithCompletion:(DVSAccountStoreBlock)completion {
    if (completion != NULL) {
        ACAccount *account = [[self class] accountForRequestAccess];
        NSError *error = [[self class] errorForRequestAccess];
        completion(account, error);
    }
}
#pragma clang diagnostic pop

+ (ACAccount *)accountForRequestAccess {
    return nil;
}

+ (NSError *)errorForRequestAccess {
    return nil;
}

@end


@implementation SLRequest (DeviseTests)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
- (void)performRequestWithHandler:(SLRequestHandler)handler {
    if (handler != NULL) {
        handler([[self class] responseData], [[self class] urlResponse], [[self class] responseError]);
    }
}
#pragma clang diagnostic pop

+ (NSData *)responseData {
    return nil;
}

+ (NSHTTPURLResponse *)urlResponse {
    return nil;
}

+ (NSError *)responseError {
    return nil;
}

@end