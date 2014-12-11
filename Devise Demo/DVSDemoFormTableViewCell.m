//
//  DVSDemoFormTableViewCell.m
//  Devise
//
//  Created by Wojciech Trzasko on 11.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSDemoFormTableViewCell.h"

@interface DVSDemoFormTableViewCell ()

@property (weak, nonatomic, readwrite) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic, readwrite) IBOutlet UITextField *valueTextField;

@end

@implementation DVSDemoFormTableViewCell

#pragma mark - UITextField events

- (IBAction)testFieldChanged:(id)sender {
    if ([self.delegate respondsToSelector:@selector(formTableViewCell:changedValue:)]) {
        UITextField *senderTextField = (UITextField *)sender;
        [self.delegate formTableViewCell:self changedValue:senderTextField.text];
    }
}

@end
