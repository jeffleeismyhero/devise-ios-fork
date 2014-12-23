//
//  DVSViewController.m
//  Devise
//
//  Created by Wojciech Trzasko on 23.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSBaseViewController.h"

NSString * const DVSFormEmailTag = @"email";
NSString * const DVSFormPasswordTag = @"password";
NSString * const DVSFormProceedButtonTag = @"proceedButton";
NSString * const DVSFormDismissButtonTag = @"dismissButton";

@interface DVSBaseViewController ()

@property (nonatomic, copy) void (^leftNavigationBarActionBlock)();
@property (nonatomic, copy) void (^rightNavigationBarActionBlock)();

@end

@implementation DVSBaseViewController

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

@end
