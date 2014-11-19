//
//  SSKErrorTranslate.h
//  SaasKit
//
//  Created by Patryk Kaczmarek on 19.11.2014.
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SSKErrorCode) {
    SSKErrorEmailEmpty = 20001,
    SSKErrorEmailSyntaxError,
    SSKErrorPasswordEmpty,
    SSKErrorUsernameEmpty
};

@interface SSKErrorTranslate : NSObject

+ (NSString *)translateErrorCode:(SSKErrorCode)code;

@end
