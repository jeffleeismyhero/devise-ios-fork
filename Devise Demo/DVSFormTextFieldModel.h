//
//  DVSFormTableModel.h
//  Devise
//
//  Created by Wojciech Trzasko on 15.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DVSFormTextFieldModel : NSObject

@property (strong, nonatomic, readonly) NSString *value;
@property (assign, nonatomic, readonly) BOOL secured;
@property (assign, nonatomic, readonly) UIKeyboardType keyboardType;

- (instancetype)initWithValue:(NSString *)value secured:(BOOL)secured keyboardType:(UIKeyboardType)keyboardType;

@end
