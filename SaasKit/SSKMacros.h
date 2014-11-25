//
//  SSKMacros.h
//  
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#define SSKPragma(pragma) _Pragma(#pragma)
#define SSKWorkInProgress(msg) SSKPragma(message "[WIP] " msg)
#define SSKTemporary(msg) SSKPragma(message "[TEMP] " msg)

#define NSLocalizedFormatString(fmt, ...) [NSString stringWithFormat:NSLocalizedString(fmt, nil), __VA_ARGS__]

#ifdef DEBUG
    #define SSKDLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
    #define SSKDLog(...)
#endif
