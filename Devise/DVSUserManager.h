//
//  DVSUserManager.h
//  Devise
//
//  Created by Wojciech Trzasko on 11.02.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DVSUser.h"
#import "DVSUserJSONSerializer.h"
#import "DVSHTTPClient.h"

@protocol DVSUserManagerDelegate;
@protocol DVSUserManagerDataSource;

@interface DVSUserManager : NSObject

@property (strong, nonatomic, readonly) DVSUser *user;
@property (nonatomic, copy) NSString *userOriginalEmail;
@property (nonatomic, readonly) DVSUserJSONSerializer *serializer;
@property (weak, nonatomic) id<DVSUserManagerDelegate> delegate;
@property (weak, nonatomic) id<DVSUserManagerDataSource> dataSource;

/**
 *  The HTTP client used by the model for networking purposes.
 */
@property (strong, nonatomic) DVSHTTPClient *httpClient;

- (instancetype)initWithUser:(DVSUser *)user;
- (instancetype)initWithUser:(DVSUser *)user configuration:(DVSConfiguration *)configuration;

+ (instancetype)defaultManager;

/**
 *  Login user asynchronously. When succeed user will be stored locally so
 *  calls to currentUser will return the latest logged in user.
 */
- (void)loginWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;

/**
 *  Reminds user password asynchronously.
 */
- (void)remindPasswordWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;

/**
 *  Registers user asynchronously.
 */
- (void)registerWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;

/**
 *  Signs in user asynchronously via Facebook.
 */
- (void)signInUsingFacebookWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;

/**
 *  Changes user password asynchronously.
 */
- (void)changePasswordWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;

/**
 *  Update user info asynchronously.
 */
- (void)updateWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;

/**
 *  Deletes account associated with user asynchronously. When succeed removes also user related data from keychain.
 */
- (void)deleteAccountWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;

/**
 *  Deletes locally stored user.
 */
- (void)logout;

@end

@protocol DVSUserManagerDelegate <NSObject>

@optional
- (void)userManager:(DVSUserManager *)manager didPrepareValidationRules:(NSMutableArray *)validationRules forAction:(DVSActionType)action;

@end

@protocol DVSUserManagerDataSource <NSObject>

@optional
- (NSArray *)additionalValidationRulesForAction:(DVSActionType)action defaultRules:(NSArray *)defaultRules;

@end
