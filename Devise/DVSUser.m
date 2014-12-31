//
//  DVSUser.m
//  
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSConfiguration.h"
#import "DVSHTTPClient.h"
#import "DVSHTTPClient+User.h"
#import "DVSUser.h"
#import "DVSUser+Persistence.h"

@interface DVSUser ()

@property (strong, nonatomic) NSArray *additionalRequestParameters;
- (void)setUpDefaultAdditionalRequestParameters;

@property (strong, nonatomic, readwrite) NSString *identifier;
@property (strong, nonatomic, readwrite) NSString *sessionToken;

@end

@implementation DVSUser

#pragma mark - Object lifecycle

- (instancetype)init {
    self = [super init];
    if (self == nil) return nil;
    [self setUpDefaultAdditionalRequestParameters];
    self.httpClient = [[DVSHTTPClient alloc] initWithConfiguration:[[self class] configuration]];
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, id: %@, sessionToken: %@, email: %@>", NSStringFromClass([self class]), self, self.identifier, self.sessionToken, self.email];
}

#pragma mark - Additional parameters management

- (void)setUpDefaultAdditionalRequestParameters {
    NSInteger capacity = 5;
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:capacity];
    for (int i = 0; i < capacity; i++) {
        array[i] = [NSMutableDictionary dictionary];
    }
    self.additionalRequestParameters = [array copy];
}

- (id)requestParameterForKey:(NSString *)key action:(DVSActionType)action {
    return self.additionalRequestParameters[action][key];
}

- (NSDictionary *)requestParametersForAction:(DVSActionType)action {
    return self.additionalRequestParameters[action];
}

- (void)setRequestParameter:(id)parameter forKey:(NSString *)key action:(DVSActionType)action {
    self.additionalRequestParameters[action][key] = parameter;
}

- (void)setRequestParameters:(NSDictionary *)parameters forAction:(DVSActionType)action {
    [self.additionalRequestParameters[action] addEntriesFromDictionary:parameters];
}

#pragma mark - Configuration

+ (DVSConfiguration *)configuration {
    return [DVSConfiguration sharedConfiguration];
}

@end