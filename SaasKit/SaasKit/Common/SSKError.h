//
//  SSKError.h
//  SaasKit
//
//  Created by Patryk Kaczmarek on 19.11.2014.
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSKErrorTranslate.h"

@interface SSKError : NSError

+ (instancetype)errorWithCode:(SSKErrorCode)code;

@end
