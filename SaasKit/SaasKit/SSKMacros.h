//
//  SSKMacros.h
//  SaasKit
//
//  Created by Patryk Kaczmarek on 19.11.2014.
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#ifndef SaasKit_SSKMacros_h
#define SaasKit_SSKMacros_h

#ifdef __OBJC__

    #ifdef DEBUG
        #define SSK_CLS_LOG(__TAG__,__FORMAT__, ...) CLSNSLog((@"[" __TAG__ @"][%@]" __FORMAT__), NSStringFromClass([self class]), ##__VA_ARGS__)
    #else
        #define SSK_CLS_LOG(__TAG__,__FORMAT__, ...) CLSLog((@"[" __TAG__ @"][%@]" __FORMAT__), NSStringFromClass([self class]), ##__VA_ARGS__)
    #endif

    #define NSLog(...) CLS_LOG(__VA_ARGS__)

    // these macros print on console during debug and send to crashylitycs in release build
    // SSKLog(tag, msg) prints ['tag'][Class name] selectorName msg
    #define SSKLog(__TAG__, __MESSAGE__) SSK_CLS_LOG(__TAG__, @" %@ %@", NSStringFromSelector(_cmd), __MESSAGE__)

    // SSKTag(tag) prints ['tag'][Class name] selectorName line
    #define SSKTag(__TAG__) SSKLog(__TAG__, @(__LINE__))

    // SSKMark prints [Mark][Class name] selectorName line
    #define SSKMark() SSKTag(@"Mark")

    // Always logs in the console
    #define SSKMarkConsole(__ADDITIONAL__) CLSNSLog(@"[Mark][%@] %@ %@ %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), @(__LINE__), __ADDITIONAL__)

    #define SSKRand0to1 ((float)arc4random()/0x100000000)
    #define IS_IOS_8() (floor(NSFoundationVersionNumber) >  NSFoundationVersionNumber_iOS_7_1)

    #define SSKPragma(pragma) _Pragma(#pragma)
    #define SSKDeprecated(msg) SSKPragma(message "[Deprecated] " msg " (to be removed ASAP)")
    #define SSKWorkInProgress(msg) SSKPragma(message "[WIP] " msg)
    #define SSKTemporary(msg) SSKPragma(message "[Temporary] " msg " (to be fixed ASAP)")

    #define NSLocalizedFormatString(fmt, ...) [NSString stringWithFormat:NSLocalizedString(fmt, nil), __VA_ARGS__]

#endif

#endif
