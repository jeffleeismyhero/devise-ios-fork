//
//  XLFormRowDescriptor+Devise.m
//  Devise
//
//  Created by Wojciech Trzasko on 23.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "XLFormRowDescriptor+Devise.h"

#import "DVSAccessibilityLabels.h"
#import "XLForm.h"

@implementation XLFormRowDescriptor (Devise)

#pragma mark - Custom textFields

+ (XLFormRowDescriptor *)dvs_emailRowWithTag:(NSString *)tag {
    XLFormRowDescriptor *emailRow = [XLFormRowDescriptor formRowDescriptorWithTag:tag
                                                                          rowType:XLFormRowDescriptorTypeEmail
                                                                            title:NSLocalizedString(@"E-mail", nil)];
    [emailRow dvs_setAccessibilityLabel:NSLocalizedString(DVSAccessibilityLabelEmailTextField, nil)];
    
    return emailRow;
}

+ (XLFormRowDescriptor *)dvs_passwordRowWithTag:(NSString *)tag {
    XLFormRowDescriptor *passwordRow = [XLFormRowDescriptor formRowDescriptorWithTag:tag
                                                                             rowType:XLFormRowDescriptorTypePassword
                                                                               title:NSLocalizedString(@"Password", nil)];
    [passwordRow dvs_setAccessibilityLabel:NSLocalizedString(DVSAccessibilityLabelPasswordTextField, nil)];
    
    return passwordRow;
}

#pragma mark - Custom buttons

+ (XLFormRowDescriptor *)dvs_buttonRowWithTag:(NSString *)tag title:(NSString *)title accessibilityLabel:(NSString *)accessiblityLabel color:(UIColor *)color {
    return [self dvs_buttonRowWithTag:tag title:title accessibilityLabel:accessiblityLabel color:color action:nil];
}

+ (XLFormRowDescriptor *)dvs_buttonRowWithTag:(NSString *)tag title:(NSString *)title accessibilityLabel:(NSString *)accessiblityLabel color:(UIColor *)color action:(void (^)(XLFormRowDescriptor *))action {
    XLFormRowDescriptor *buttonRow = [XLFormRowDescriptor formRowDescriptorWithTag:tag
                                                                           rowType:XLFormRowDescriptorTypeButton
                                                                             title:title];
    [buttonRow dvs_customizeTextWithColor:color alignment:NSTextAlignmentCenter];
    [buttonRow dvs_setAccessibilityLabel:accessiblityLabel];
    buttonRow.action.formBlock = action;
    
    return buttonRow;
}

#pragma mark - Private methods

- (void)dvs_customizeTextWithColor:(UIColor *)color alignment:(NSTextAlignment)alignment {
    [self.cellConfig setObject:color forKey:@"textLabel.textColor"];
    [self.cellConfig setObject:@(alignment) forKey:@"textLabel.textAlignment"];
}

- (void)dvs_setAccessibilityLabel:(NSString *)accessibilityLabel {
    if ([self.rowType isEqualToString:XLFormRowDescriptorTypeButton]) {
        [self dvs_setAccessibilityLabel:accessibilityLabel forControllWithName:@""];
    } else if ([self.rowType isEqualToString:XLFormRowDescriptorTypeText]
               || [self.rowType isEqualToString:XLFormRowDescriptorTypeEmail]
               || [self.rowType isEqualToString:XLFormRowDescriptorTypePassword]) {
        [self dvs_setAccessibilityLabel:accessibilityLabel forControllWithName:@"textField."];
    } else {
        NSAssert(NO, @"Row type not supported.");
    }
}

- (void)dvs_setAccessibilityLabel:(NSString *)accessibilityLabel forControllWithName:(NSString *)controllName {
    [self.cellConfig setObject:accessibilityLabel forKey:[NSString stringWithFormat:@"%@accessibilityLabel", controllName]];
}

@end
