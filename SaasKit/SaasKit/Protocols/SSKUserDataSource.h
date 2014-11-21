//
//  SSKUserParamsDataSource.h
//  SaasKit
//
//  Created by Patryk Kaczmarek on 21.11.2014.
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SSKRequestType) {
    SSKRequestGET,
    SSKRequestPOST
};

@protocol SSKUserDataSource <NSObject>

@optional

#pragma mark - Login
- (SSKRequestType)requestTypeForUserLogin:(SSKUser *)user;  // Default is POST
- (NSString *)nameForUsernameInUserLogin:(SSKUser *)user;   // Default is "username" if not implemented
- (NSString *)nameForEmailInUserLogin:(SSKUser *)user;      // Default is "email" if not implemented
- (NSString *)nameForPasswordInUserLogin:(SSKUser *)user;   // Default is "password" if not implemented

#pragma mark - Remind Passwords
- (SSKRequestType)requestTypeForUserRemindPassword:(SSKUser *)user;  // Default is POST
- (NSString *)nameForEmailInUserRemindPassword:(SSKUser *)user; // Default is "email" if not implemented
- (NSString *)nameForPasswordInRemindPassword:(SSKUser *)user;  // Default is "password" if not implemented

#pragma mark - Register
- (SSKRequestType)requestTypeForUserRegistration:(SSKUser *)user;   // Default is POST
- (NSString *)nameForUsernameInUserRegistration:(SSKUser *)user;    // Default is "username" if not implemented
- (NSString *)nameForEmailInUserRegistration:(SSKUser *)user;       // Default is "email" if not implemented
- (NSString *)nameForPasswordInRegistration:(SSKUser *)user;        // Default is "password" if not implemented

@end
