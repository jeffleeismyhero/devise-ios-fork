//
//  DVSOAuthJSONParameters.h
//  Devise
//
//  Created by Pawel Bialecki on 04.03.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, DVSOAuthProvider) {
    DVSOAuthProviderFacebook,
    DVSOAuthProviderGoogle
};

@interface DVSOAuthJSONParameters : NSObject

+ (NSDictionary *)dictionaryForParametersWithProvider:(DVSOAuthProvider)provider oAuthToken:(NSString *)oAuthToken userID:(NSString *)userID userEmail:(NSString *)email;

@end
