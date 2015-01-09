//
//  DVSFormRowCell+Model.m
//  Devise
//
//  Created by Wojciech Trzasko on 23.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSFormRowCell+Model.h"

@implementation DVSFormRowCell (Model)

- (void)configureWithRow:(DVSFormRow *)row {
    self.titleLabel.text = row.title;
    self.valueTextField.text = row.value;
    self.valueTextField.secureTextEntry = row.secured;
    self.valueTextField.keyboardType = row.keyboardType;
    self.valueTextField.accessibilityLabel = row.accessibilityLabel;
}

@end
