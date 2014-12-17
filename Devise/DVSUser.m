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
#import "DVSValidator.h"

@interface DVSUser ()

@property (strong, nonatomic) DVSHTTPClient *httpClient;

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

#pragma mark - Additional parameters management

- (void)setUpDefaultAdditionalRequestParameters {
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:5];
    for (int i = 0; i <= DVSActionUpdate; i++) {
        array[i] = [NSMutableDictionary dictionary];
    }
    self.additionalRequestParameters = [array copy];
}

- (id)objectForKey:(NSString *)key action:(DVSActionType)actionType {
    return self.additionalRequestParameters[actionType][key];
}

- (NSDictionary *)objectsForAction:(DVSActionType)actionType {
    return self.additionalRequestParameters[actionType];
}

- (void)setObject:(id)object forKey:(NSString *)key action:(DVSActionType)actionType {
    self.additionalRequestParameters[actionType][key] = object;
}

- (void)setObjects:(NSDictionary *)objects forAction:(DVSActionType)actionType {
    [self.additionalRequestParameters[actionType] addEntriesFromDictionary:objects];
}

#pragma mark - Configuration

+ (DVSConfiguration *)configuration {
    return [DVSConfiguration sharedConfiguration];
}

@end