//
//  DVSSignUpFields.h
//  Devise
//
//  Created by Wojciech Trzasko on 30.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#ifndef Devise_DVSSignUpFields_h
#define Devise_DVSSignUpFields_h

typedef NS_OPTIONS(NSInteger, DVSSignUpFields) {
    DVSSignUpFieldEmailAndPassword           = 1 << 0,
    DVSSignUpFieldSignUpButton               = 1 << 1,
    DVSSignUpFieldDismissButton              = 1 << 2,
    DVSSignUpFieldNavigationSignUpButton     = 1 << 3,
    DVSSignUpFieldNavigationDismissButton    = 1 << 4
};

#endif
