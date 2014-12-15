//
//  DVSMenuTableViewController.h
//  Devise
//
//  Created by Wojciech Trzasko on 09.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const DVSTableModelTitleKey;
extern NSString * const DVSTableModelSubtitleKey;
extern NSString * const DVSTableModelSegueKey;

@interface DVSMenuTableViewController : UITableViewController

- (NSString *)defaultCellId;

- (void)addMenuEntryWithTitle:(NSString *)title subtitle:(NSString *)subtitle segue:(NSString *)segue;
- (void)addMenuEntryWithTitle:(NSString *)title subtitle:(NSString *)subtitle selector:(SEL)selector;

@end
