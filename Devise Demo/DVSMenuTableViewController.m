//
//  DVSMenuTableViewController.m
//  Devise
//
//  Created by Wojciech Trzasko on 09.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSMenuTableViewController.h"

static NSString * const DVSDefaultCell = @"defaultCell";

NSString * const DVSTableModelTitleKey = @"title";
NSString * const DVSTableModelSubtitleKey = @"sub";
NSString * const DVSTableModelSegueKey = @"segue";
NSString * const DVSTableModelSelectorStringKey = @"selector";

@interface DVSMenuTableViewController ()

@property (nonatomic,strong) NSMutableArray *dataSourceArray;

@end

@implementation DVSMenuTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSourceArray = [NSMutableArray array];
}

#pragma mark - Abstract methods

- (NSString *)defaultCellId {
    NSAssert(NO, @"Abstract method called.");
    return @"";
}

- (NSArray *)tableDataSource {
    return [self.dataSourceArray copy];
}

#pragma mark - Menu entries

- (void)addMenuEntryWithTitle:(NSString *)title subtitle:(NSString *)subtitle segue:(NSString *)segue {
    [self addMenuEntryWithTitle:title subtitle:subtitle segue:segue selectorString:@""];
}

- (void)addMenuEntryWithTitle:(NSString *)title subtitle:(NSString *)subtitle selector:(SEL)selector {
    [self addMenuEntryWithTitle:title subtitle:subtitle segue:@"" selectorString:NSStringFromSelector(selector)];
}

- (void)addMenuEntryWithTitle:(NSString *)title subtitle:(NSString *)subtitle segue:(NSString *)segue selectorString:(NSString *)selectorString {
    
    [self.dataSourceArray addObject:@{DVSTableModelTitleKey: title,
                                      DVSTableModelSubtitleKey: subtitle,
                                      DVSTableModelSegueKey: segue,
                                      DVSTableModelSelectorStringKey: selectorString}];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self defaultCellId] forIndexPath:indexPath];
    
    NSDictionary *dataDictionary = self.dataSourceArray[indexPath.row];
    
    cell.textLabel.text = dataDictionary[DVSTableModelTitleKey];
    cell.detailTextLabel.text = dataDictionary[DVSTableModelSubtitleKey];
    
    return cell;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Menu";
}

#pragma mark - TableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dataDictionary = self.dataSourceArray[indexPath.row];
    
    NSString *selectorString = dataDictionary[DVSTableModelSelectorStringKey];
    if (selectorString && ![selectorString isEqual:@""]) {
        SEL selector = NSSelectorFromString(selectorString);
        if (selector) {
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self performSelector:selector];
            #pragma clang diagnostic pop
            return;
        }
    }
    
    NSString *segue = dataDictionary[DVSTableModelSegueKey];
    if (segue && ![segue isEqualToString:@""]) {
        [self performSegueWithIdentifier:segue sender:self];
    }
}

@end
