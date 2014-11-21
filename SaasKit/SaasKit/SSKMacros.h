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
        #define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
    #else
        #define DLog(...)
    #endif

    #define SSKPragma(pragma) _Pragma(#pragma)
    #define SSKDeprecated(msg) SSKPragma(message "[Deprecated] " msg " (to be removed ASAP)")
    #define SSKWorkInProgress(msg) SSKPragma(message "[TODO] " msg)
    #define SSKTemporary(msg) SSKPragma(message "[Temporary] " msg " (to be fixed ASAP)")
    #define SSKBackendIssue(msg) SSKPragma(message "[Temporary] " msg " (waiting for backend to fix)")

    #define NSLocalizedFormatString(fmt, ...) [NSString stringWithFormat:NSLocalizedString(fmt, nil), __VA_ARGS__]

#endif

#endif
