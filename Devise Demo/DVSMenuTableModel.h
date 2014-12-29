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
@property (assign, nonatomic, readonly) SEL selector;
@property (strong, nonatomic, readonly) id target;

- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle segueName:(NSString *)segueName;
- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle target:(id)target selector:(SEL)selector;

@end
