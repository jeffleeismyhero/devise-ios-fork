//
//  DVSViewController.m
//  Devise
//
//  Created by Wojciech Trzasko on 23.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSBaseViewController.h"

#import "XLFormRowDescriptor+Devise.h"

NSString * const DVSFormEmailTag = @"email";
NSString * const DVSFormPasswordTag = @"password";
NSString * const DVSFormProceedButtonTag = @"proceedButton";
NSString * const DVSFormDismissButtonTag = @"dismissButton";

@interface DVSBaseViewController ()

@property (nonatomic, copy) void (^leftNavigationBarActionBlock)();
@property (nonatomic, copy) void (^rightNavigationBarActionBlock)();
@property (nonatomic, copy) void (^proceedButtonActionBlock)();
@property (nonatomic, copy) void (^dismissButtonActionBlock)();

@end

@implementation DVSBaseViewController

#pragma mark - Form controlls

- (void)addEmailAndPasswordToSection:(XLFormSectionDescriptor *)section {
    [section addFormRow:[XLFormRowDescriptor dvs_emailRowWithTag:DVSFormEmailTag]];
    [section addFormRow:[XLFormRowDescriptor dvs_passwordRowWithTag:DVSFormPasswordTag]];
}

- (void)addProceedButtonToSection:(XLFormSectionDescriptor *)section title:(NSString *)title action:(void (^)())actionBlock {
    [section addFormRow:[XLFormRowDescriptor dvs_buttonRowWithTag:DVSFormProceedButtonTag
                                                            title:title
                                                            color:[UIColor blueColor]
                                                         selector:@selector(proceedButtonTapped:)]];
    self.proceedButtonActionBlock = actionBlock;
}

- (void)addDismissButtonToSection:(XLFormSectionDescriptor *)section title:(NSString *)title action:(void (^)())actionBlock {
    [section addFormRow:[XLFormRowDescriptor dvs_buttonRowWithTag:DVSFormDismissButtonTag
                                                            title:title
                                                            color:[UIColor redColor]
                                                         selector:@selector(dismissButtonTapped:)]];
    self.dismissButtonActionBlock = actionBlock;
}

#pragma mark - Navigation bar buttons

- (void)setupLeftNavigationBarButtonWithTitle:(NSString *)title action:(void (^)())actionBlock {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(leftNavigationBarButtonTapped:)];
    self.leftNavigationBarActionBlock = actionBlock;
}

- (void)setupRightNavigationBarButtonWithTitle:(NSString *)title action:(void (^)())actionBlock {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(leftNavigationBarButtonTapped:)];
    self.rightNavigationBarActionBlock = actionBlock;
}

#pragma mark - UIControl events

- (void)proceedButtonTapped:(XLFormRowDescriptor *)sender {
    if (self.proceedButtonActionBlock) {
        self.proceedButtonActionBlock();
    }
    [self deselectFormRow:sender];
}

- (void)dismissButtonTapped:(XLFormRowDescriptor *)sender {
    if (self.dismissButtonActionBlock) {
        self.dismissButtonActionBlock();
    }
    [self deselectFormRow:sender];
}

- (void)leftNavigationBarButtonTapped:(UIBarButtonItem *)sender {
    if (self.leftNavigationBarActionBlock) {
        self.leftNavigationBarActionBlock();
    }
}

- (void)rightNavigationBarButtonTapped:(UIBarButtonItem *)sender {
    if (self.rightNavigationBarActionBlock) {
        self.rightNavigationBarActionBlock();
    }
}

#pragma mark - Helpers

- (BOOL)shouldShow:(NSUInteger)option basedOn:(NSUInteger)value {
    return (value & option) == option;
}

@end
