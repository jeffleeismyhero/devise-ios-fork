//
//  DVSDemoFormTableViewCell.h
//  Devise
//
//  Created by Wojciech Trzasko on 11.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DVSDemoFormTableViewCellDelegate;

@interface DVSDemoFormTableViewCell : UITableViewCell

@property (weak, nonatomic) id<DVSDemoFormTableViewCellDelegate> delegate;
@property (weak, nonatomic, readonly) UILabel *titleLabel;
@property (weak, nonatomic, readonly) UITextField *valueTextField;

@end

@protocol DVSDemoFormTableViewCellDelegate <NSObject>

- (void)formTableViewCell:(DVSDemoFormTableViewCell *)cell changedValue:(NSString *)string;

@end
