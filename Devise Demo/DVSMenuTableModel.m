//
//  DVSMenuTableModel.m
//  Devise
//
//  Created by Wojciech Trzasko on 15.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSMenuTableModel.h"

@interface DVSMenuTableModel ()

@property (strong, nonatomic, readwrite) NSString *title;
@property (strong, nonatomic, readwrite) NSString *subtitle;
@property (strong, nonatomic, readwrite) NSString *segueName;
@property (strong, nonatomic, readwrite) NSString *selectorString;

@end

@implementation DVSMenuTableModel

- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle segueName:(NSString *)segueName {
    return [self initWithTitle:title
                      subtitle:subtitle
                     segueName:segueName
                selectorString:nil];
}

- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle selectorString:(NSString *)selectorString {
    return [self initWithTitle:title
                      subtitle:subtitle
                     segueName:nil
                selectorString:selectorString];
}

- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle segueName:(NSString *)segueName selectorString:(NSString *)selectorString {
    if (self = [super init]) {
        self.title = title;
        self.subtitle = subtitle;
        self.segueName = segueName;
        self.selectorString = selectorString;
    }
    return self;
}

@end
