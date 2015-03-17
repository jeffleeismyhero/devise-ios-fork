//
//  DVSTestFacebookAuthenticator.m
//  Devise
//
//  Created by Radoslaw Szeja on 16/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSTestFacebookAuthenticator.h"

@implementation DVSTestFacebookAuthenticator

@end


@implementation DVSFacebookAccountStore (DeviseStubs)

+ (instancetype)dvs_stubFacebookAccountStore {
    DVSFacebookAccountStore *facebookAccountStore = [[DVSFacebookAccountStore alloc] init];
    
    [[self class] stub:@selector(alloc) andReturn:facebookAccountStore];
    [facebookAccountStore stub:@selector(initWithAppIDkey:permissions:) andReturn:facebookAccountStore];
    
    ACAccountType *accountType = [facebookAccountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    ACAccount *account = [[ACAccount alloc] initWithAccountType:accountType];

    [facebookAccountStore stub:@selector(account) andReturn:account];
    
    return facebookAccountStore;
}

@end


@implementation SLRequest (DeviseStubs)

+ (instancetype)dvs_stubSLRequest {
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                            requestMethod:SLRequestMethodGET
                                                      URL:[NSURL URLWithString:@"http://example.org"]
                                               parameters:nil];
    
    [SLRequest stub:@selector(requestForServiceType:requestMethod:URL:parameters:) andReturn:request];
    return request;
}

@end
