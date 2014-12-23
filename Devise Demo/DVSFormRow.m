//
//  DVSFormTableModel.m
//  Devise
//
//  Created by Wojciech Trzasko on 15.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSFormRow.h"

@interface DVSFormRow ()

@end

@implementation DVSFormRow

- (instancetype)initWithTitle:(NSString *)title value:(NSString *)value secured:(BOOL)secured keyboardType:(UIKeyboardType)keyboardType {
    if (self = [super init]) {
        _title = title;
        _value = value;
        _secured = secured;
        _keyboardType = keyboardType;
    }
    return self;
}

@end
