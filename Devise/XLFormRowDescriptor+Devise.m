//
//  XLFormRowDescriptor+Devise.m
//  Devise
//
//  Created by Wojciech Trzasko on 23.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "XLFormRowDescriptor+Devise.h"

#import "XLForm.h"

@implementation XLFormRowDescriptor (Devise)

+ (XLFormRowDescriptor *)dvs_emailRowWithTag:(NSString *)tag {
    return [XLFormRowDescriptor formRowDescriptorWithTag:tag
                                                 rowType:XLFormRowDescriptorTypeEmail
                                                   title:NSLocalizedString(@"E-mail", nil)];
}

+ (XLFormRowDescriptor *)dvs_passwordRowWithTag:(NSString *)tag {
    return [XLFormRowDescriptor formRowDescriptorWithTag:tag
                                                 rowType:XLFormRowDescriptorTypePassword
                                                   title:NSLocalizedString(@"Password", nil)];
}

+ (XLFormRowDescriptor *)dvs_buttonRowWithTag:(NSString *)tag title:(NSString *)title color:(UIColor *)color {
    return [self dvs_buttonRowWithTag:tag title:title color:color selector:nil];
}

+ (XLFormRowDescriptor *)dvs_buttonRowWithTag:(NSString *)tag title:(NSString *)title color:(UIColor *)color selector:(SEL)selector {
    XLFormRowDescriptor *buttonRow = [XLFormRowDescriptor formRowDescriptorWithTag:tag
                                                                           rowType:XLFormRowDescriptorTypeButton
                                                                             title:title];
    [buttonRow dvs_customizeTextWithColor:color alignment:NSTextAlignmentCenter];
    buttonRow.action.formSelector = selector;
    
    return buttonRow;
}

- (void)dvs_customizeTextWithColor:(UIColor *)color alignment:(NSTextAlignment)alignment {
    [self.cellConfig setObject:color forKey:@"textLabel.textColor"];
    [self.cellConfig setObject:@(alignment) forKey:@"textLabel.textAlignment"];
}

@end
