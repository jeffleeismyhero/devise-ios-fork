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

    #define SSKPragma(pragma) _Pragma(#pragma)
    #define SSKDeprecated(msg) STPragma(message "[Deprecated] " msg " (to be removed ASAP)")
    #define SSKWorkInProgress(msg) STPragma(message "[WIP] " msg)
    #define SSKTemporary(msg) STPragma(message "[Temporary] " msg " (to be fixed ASAP)")

#endif

#endif
