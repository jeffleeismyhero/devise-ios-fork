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
@property (strong, nonatomic, readonly) NSString *segueIdentifier;
@property (strong, nonatomic, readonly) NSString *accessibilityLabel;
@property (assign, nonatomic, readonly) SEL selector;
@property (strong, nonatomic, readonly) id target;

- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle accessibilityLabel:(NSString *)accessibilityLabel segueIdentifier:(NSString *)segueIdentifier;
- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle accessibilityLabel:(NSString *)accessibilityLabel target:(id)target selector:(SEL)selector;

@end
