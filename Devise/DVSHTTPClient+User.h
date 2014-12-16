//
//  DVSHTTPClient+User.h
//  
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DVSHTTPClient.h"
#import "DVSTypedefs.h"

@class DVSUser;

@interface DVSHTTPClient (User)

/**
 *  Registers a user.
 *
 *  @param user    A user which you want to register.
 *  @param success An option success block executed when the request finishes.
 *  @param failure An option failure block executed when the request fails.
 */
- (void)registerUser:(DVSUser *)user success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;

/**
 *  Logs in a user.
 *
 *  @param user    A user which you want to log in.
 *  @param success An option completion block executed when the request finishes.
 *  @param failure An option failure block executed when the request fails.
 */
- (void)logInUser:(DVSUser *)user success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;

/**
 *  Updates a user.
 *
 *  @param user    A user which you want to update.
 *  @param success An option completion block executed when the request finishes.
 *  @param failure An option failure block executed when the request fails.
 */
- (void)updateUser:(DVSUser *)user success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;

/**
 *  Deletes a user.
 *
 *  @param user    A user which you want to delete.
 *  @param success An option completion block executed when the request finishes.
 *  @param failure An option failure block executed when the request fails.
 */
- (void)deleteUser:(DVSUser *)user success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;

/**
 *  Changes password of a user.
 *
 *  @param user    A user of which the password you would like to change.
 *  @param success An option completion block executed when the request finishes.
 *  @param failure An option failure block executed when the request fails.
 */
- (void)changePasswordOfUser:(DVSUser *)user success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;

/**
 *  Reminds password to a user.
 *
 *  @param user    A user to which you want to remind password.
 *  @param success An option completion block executed when the request finishes.
 *  @param failure An option failure block executed when the request fails.
 */
- (void)remindPasswordToUser:(DVSUser *)user success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;

/**
 *  Sets the authorization token and email headers.
 *
 *  @param token The authorization token to use.
 *  @param email The authorization email to use.
 */
- (void)setAuthorizationToken:(NSString *)token email:(NSString *)email;

@end
