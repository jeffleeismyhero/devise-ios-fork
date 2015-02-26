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

#pragma mark - Equality

- (BOOL)isEqual:(id)object {
    if (self == object) return YES;
    if (![object isKindOfClass:[self class]]) return NO;
    
    DVSUser *user = (DVSUser *)object;
    
    BOOL haveEqualId = [self isProperty:self.identifier equalTo:user.identifier];
    BOOL haveEqualEmail = [self isProperty:self.email equalTo:user.email];
    BOOL haveEqualSessionToken = [self isProperty:self.sessionToken equalTo:user.sessionToken];
    
    return haveEqualId && haveEqualEmail && haveEqualSessionToken;
}

- (BOOL)isProperty:(NSObject *)ownedProperty equalTo:(NSObject *)property {
    return [ownedProperty isEqual:property] || (!ownedProperty && !property);
}

- (NSUInteger)hash {
    return [self.identifier hash] ^ [self.email hash] ^ [self.sessionToken hash];
}

@end
