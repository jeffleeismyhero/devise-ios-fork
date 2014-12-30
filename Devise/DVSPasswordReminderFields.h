//
//  DVSPasswordReminderFields.h
//  Devise
//
//  Created by Wojciech Trzasko on 30.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#ifndef Devise_DVSPasswordReminderFields_h
#define Devise_DVSPasswordReminderFields_h

typedef NS_OPTIONS(NSInteger, DVSPasswordReminderFields) {
    DVSPasswordReminderFieldDismissButton              = 1 << 0,
    DVSPasswordReminderFieldNavigationDismissButton    = 1 << 1
};

#endif
