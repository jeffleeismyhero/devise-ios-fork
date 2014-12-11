//
//  DVSDemoFormTableViewCell.m
//  Devise
//
//  Created by Wojciech Trzasko on 11.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSDemoFormTableViewCell.h"

@interface DVSDemoFormTableViewCell () <UITextFieldDelegate>

@property (weak, nonatomic, readwrite) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic, readwrite) IBOutlet UITextField *valueTextField;

@end

@implementation DVSDemoFormTableViewCell

- (void)awakeFromNib {
    self.valueTextField.delegate = self;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(formTableViewCell:changedValue:)]) {
        [self.delegate formTableViewCell:self changedValue:textField.text];
    }
}

@end
