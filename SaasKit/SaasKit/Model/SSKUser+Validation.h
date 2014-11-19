//
//  SSKUser+Validation.h
//  SaasKit
//
//  Created by Patryk Kaczmarek on 19.11.2014.
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import "SSKUser.h"
#import "SSKError.h"

@interface SSKUser (Validation)

- (BOOL)loginValidationWithError:(SSKError **)error;
- (BOOL)remindPasswordValidationWithError:(SSKError **)error;

@end
