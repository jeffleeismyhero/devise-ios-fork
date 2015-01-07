//
//  DVSMenuTableViewController.h
//  Devise
//
//  Created by Wojciech Trzasko on 09.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DVSMenuTableViewController : UITableViewController

- (NSString *)defaultCellId;

- (void)addMenuEntryWithTitle:(NSString *)title subtitle:(NSString *)subtitle segue:(NSString *)segue;
- (void)addMenuEntryWithTitle:(NSString *)title subtitle:(NSString *)subtitle target:(id)target action:(SEL)selector;
- (void)addMenuEntryWithTitle:(NSString *)title subtitle:(NSString *)subtitle accessibilityLabel:(NSString *)accessibilityLabel segue:(NSString *)segue;
- (void)addMenuEntryWithTitle:(NSString *)title subtitle:(NSString *)subtitle accessibilityLabel:(NSString *)accesibilityLabel target:(id)target action:(SEL)selector;

@end
