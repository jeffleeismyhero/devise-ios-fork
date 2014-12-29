//
//  DVSViewController.h
//  Devise
//
//  Created by Wojciech Trzasko on 23.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "XLFormViewController.h"

@interface DVSBaseViewController : XLFormViewController

- (BOOL)shouldShow:(NSUInteger)option basedOn:(NSUInteger)value;

@end
