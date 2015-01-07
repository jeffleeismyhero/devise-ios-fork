//
//  DVSMenuTableModel.m
//  Devise
//
//  Created by Wojciech Trzasko on 15.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSMenuTableModel.h"

@implementation DVSMenuTableModel

- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle accessibilityLabel:(NSString *)accessibilityLabel segueIdentifier:(NSString *)segueIdentifier {
    return [self initWithTitle:title
                      subtitle:subtitle
            accessibilityLabel:accessibilityLabel
               segueIdentifier:segueIdentifier
                        target:nil
                      selector:nil];
}

- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle accessibilityLabel:(NSString *)accessibilityLabel target:(id)target selector:(SEL)selector {
    return [self initWithTitle:title
                      subtitle:subtitle
            accessibilityLabel:accessibilityLabel
               segueIdentifier:nil
                        target:target
                      selector:selector];
}

- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle accessibilityLabel:(NSString *)accessibilityLabel segueIdentifier:(NSString *)segueIdentifier target:(id)target selector:(SEL)selector {
    if (self = [super init]) {
        _title = title;
        _subtitle = subtitle;
        _accessibilityLabel = accessibilityLabel;
        _segueIdentifier = segueIdentifier;
        _target = target;
        _selector = selector;
    }
    return self;
}

@end
