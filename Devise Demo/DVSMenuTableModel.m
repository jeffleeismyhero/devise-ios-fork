//
//  DVSMenuTableModel.m
//  Devise
//
//  Created by Wojciech Trzasko on 15.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSMenuTableModel.h"

@implementation DVSMenuTableModel

- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle segueName:(NSString *)segueName {
    return [self initWithTitle:title
                      subtitle:subtitle
                     segueName:segueName
                        target:nil
                selectorString:nil];
}

- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle target:(id)target selectorString:(NSString *)selectorString {
    return [self initWithTitle:title
                      subtitle:subtitle
                     segueName:nil
                        target:target
                selectorString:selectorString];
}

- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle segueName:(NSString *)segueName target:(id)target selectorString:(NSString *)selectorString {
    if (self = [super init]) {
        _title = title;
        _subtitle = subtitle;
        _segueIdentifier = segueName;
        _target = target;
        _selectorString = selectorString;
    }
    return self;
}

@end
