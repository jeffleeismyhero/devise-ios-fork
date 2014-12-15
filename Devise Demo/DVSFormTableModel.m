//
//  DVSFormTableModel.m
//  Devise
//
//  Created by Wojciech Trzasko on 15.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSFormTableModel.h"

@interface DVSFormTableModel ()

@property (strong, nonatomic, readwrite) NSString *value;
@property (assign, nonatomic, readwrite) BOOL secured;

@end

@implementation DVSFormTableModel

- (instancetype)initWithValue:(NSString *)value secured:(BOOL)secured {
    if (self = [super init]) {
        self.value = value;
        self.secured = secured;
    }
    return self;
}

@end
