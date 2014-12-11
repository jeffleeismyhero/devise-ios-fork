//
//  DVSAPIManager.h
//  
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DVSTypedefs.h"

@class DVSUser;

@interface DVSAPIManager : NSObject

/**
 *  User registration.
 *
 *  @param user    The User you want to register.
 *  @param success The success block executed when the request finishes with success.
 *  @param failure The failure block executed when the request finishes with success.
 */
+ (void)registerUser:(DVSUser *)user withSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;

/**
 *  user profile updating.
 *
 *  @param user    The User which is associated with account you want to update.
 *  @param success The success block executed when the request finishes with success.
 *  @param failure The failure block executed when the request finishes with success.
 */
+ (void)updateUser:(DVSUser *)user withSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;

/**
 *  User signing in.
 *
 *  @param user    The User which is associated with account you want to sign in.
 *  @param success The success block executed when the request finishes with success.
 *  @param failure The failure block executed when the request finishes with success.
 */
+ (void)loginUser:(DVSUser *)user withSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;

/**
 *  User password reminder.
 *
 *  @param user    The User which is associated with account you want to reset password.
 *  @param success The success block executed when the request finishes with success.
 *  @param failure The failure block executed when the request finishes with success.
 */
+ (void)remindPasswordForUser:(DVSUser *)user withSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;

/**
 *  User password changer.
 *
 *  @param user    The User which is associated with account you want to change password.
 *  @param success The success block executed when the request finishes with success.
 *  @param failure The failure block executed when the request finishes with success.
 */
+ (void)changePasswordForUser:(DVSUser *)user withSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;

/**
 *  Account deleting
 *
 *  @param user    The User which is associated with account you want to delete.
 *  @param success The success block executed when the request finishes with success.
 *  @param failure The failure block executed when the request finishes with success.
 */
+ (void)deleteUser:(DVSUser *)user withSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;

@end
