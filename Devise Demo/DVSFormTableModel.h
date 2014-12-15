//
//  DVSFormTableModel.h
//  Devise
//
//  Created by Wojciech Trzasko on 15.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DVSFormTableModel : NSObject

@property (strong, nonatomic, readonly) NSString *value;
@property (assign, nonatomic, readonly) BOOL secured;

- (instancetype)initWithValue:(NSString *)value secured:(BOOL)secured;

@end
