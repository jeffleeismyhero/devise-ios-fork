//
//  DVSFormTableModel.m
//  Devise
//
//  Created by Wojciech Trzasko on 15.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSFormTableModel.h"

@implementation DVSFormTableModel

- (instancetype)initWithValue:(NSString *)value secured:(BOOL)secured keyboardType:(UIKeyboardType)keyboardType {
    if (self = [super init]) {
        _value = value;
        _secured = secured;
        _keyboardType = keyboardType;
    }
    return self;
}

@end
