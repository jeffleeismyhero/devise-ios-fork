//
//  DVSDemoFormTableViewCell.h
//  Devise
//
//  Created by Wojciech Trzasko on 11.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DVSFormTableViewCellDelegate;

@interface DVSFormRowCell : UITableViewCell

@property (weak, nonatomic) id<DVSFormTableViewCellDelegate> delegate;
@property (weak, nonatomic, readonly) UILabel *titleLabel;
@property (weak, nonatomic, readonly) UITextField *valueTextField;

@end

@protocol DVSFormTableViewCellDelegate <NSObject>

- (void)formTableViewCellDidChangeValue:(DVSFormRowCell *)cell;

@end
