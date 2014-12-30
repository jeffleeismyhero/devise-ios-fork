//
//  DVSLogInFields.h
//  Devise
//
//  Created by Wojciech Trzasko on 30.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#ifndef Devise_DVSLogInFields_h
#define Devise_DVSLogInFields_h

typedef NS_OPTIONS(NSInteger, DVSLogInFields) {
    DVSLogInFieldEmailAndPassword           = 1 << 0,
    DVSLogInFieldLogInButton                = 1 << 1,
    DVSLogInFieldDismissButton              = 1 << 2,
    DVSLogInFieldNavigationLogInButton      = 1 << 3,
    DVSLogInFieldNavigationDismissButton    = 1 << 4,
    DVSLogInFieldPasswordReminder           = 1 << 5
};

#endif
