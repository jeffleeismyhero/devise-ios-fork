//
//  DVSMenuTableModel.h
//  Devise
//
//  Created by Wojciech Trzasko on 15.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DVSMenuTableModel : NSObject

@property (strong, nonatomic, readonly) NSString *title;
@property (strong, nonatomic, readonly) NSString *subtitle;
@property (strong, nonatomic, readonly) NSString *segueName;
@property (strong, nonatomic, readonly) NSString *selectorString;

- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle segueName:(NSString *)segueName;
- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle selectorString:(NSString *)selector;

@end
