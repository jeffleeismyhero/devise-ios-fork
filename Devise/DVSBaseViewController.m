//
//  DVSViewController.m
//  Devise
//
//  Created by Wojciech Trzasko on 23.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSBaseViewController.h"

@implementation DVSBaseViewController

- (void)attachViewController:(UIViewController *)controller {
    [controller willMoveToParentViewController:self];
    [self addChildViewController:controller];
    [self.view addSubview:controller.view];
    [self.view layoutIfNeeded];
    [controller didMoveToParentViewController:self];
}

@end
