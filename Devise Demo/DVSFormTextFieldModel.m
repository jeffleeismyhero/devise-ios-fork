//
//  DVSFormTableModel.m
//  Devise
//
//  Created by Wojciech Trzasko on 15.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSFormTextFieldModel.h"

@interface DVSFormTextFieldModel ()

@property (strong, nonatomic, readwrite) NSString *value;
@property (assign, nonatomic, readwrite) BOOL secured;
@property (assign, nonatomic, readwrite) UIKeyboardType keyboardType;

@end

@implementation DVSFormTextFieldModel

- (instancetype)initWithValue:(NSString *)value secured:(BOOL)secured keyboardType:(UIKeyboardType)keyboardType {
    if (self = [super init]) {
        self.value = value;
        self.secured = secured;
        self.keyboardType = keyboardType;
    }
    return self;
}

@end
