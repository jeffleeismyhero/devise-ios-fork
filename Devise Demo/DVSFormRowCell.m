//
//  DVSDemoFormTableViewCell.m
//  Devise
//
//  Created by Wojciech Trzasko on 11.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSFormRowCell.h"

@interface DVSFormRowCell ()

@property (weak, nonatomic, readwrite) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic, readwrite) IBOutlet UITextField *valueTextField;

@end

@implementation DVSFormRowCell

#pragma mark - UITextField events

- (IBAction)testFieldChanged:(UITextField *)sender {
    if ([self.delegate respondsToSelector:@selector(formTableViewCellDidChangeValue:)]) {
        [self.delegate formTableViewCellDidChangeValue:self];
    }
}

@end
