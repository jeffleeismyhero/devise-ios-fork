//
//  DVSFormTableViewController.m
//  Devise
//
//  Created by Wojciech Trzasko on 11.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSFormTableViewController.h"

#import "DVSDemoFormTableViewCell.h"

static NSString * const DVSDefaultCellId = @"defaultCell";

@interface DVSFormTableViewController () <DVSDemoFormTableViewCellDelegate>

@property (strong, nonatomic) NSMutableArray *dataSourceTitlesArray;
@property (strong, nonatomic) NSMutableDictionary *dataSourceValuesDictionary;

@end

@implementation DVSFormTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSourceTitlesArray = [NSMutableArray array];
    self.dataSourceValuesDictionary = [NSMutableDictionary dictionary];
}

#pragma mark - DataSource helpers

- (void)addFormWithTitleToDataSource:(NSString *)title {
    [self.dataSourceTitlesArray addObject:title];
    self.dataSourceValuesDictionary[title] = @"";
}

- (NSString *)getValueForTitle:(NSString *)title {
    return self.dataSourceValuesDictionary[title];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceTitlesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DVSDemoFormTableViewCell *cell = (DVSDemoFormTableViewCell *)[tableView dequeueReusableCellWithIdentifier:DVSDefaultCellId forIndexPath:indexPath];
    
    cell.titleLabel.text = self.dataSourceTitlesArray[indexPath.item];
    cell.delegate = self;
    
    return cell;
}

#pragma mark - DVSDemoFormTableViewCellDelegate

- (void)formTableViewCell:(DVSDemoFormTableViewCell *)cell changedValue:(NSString *)string {
    self.dataSourceValuesDictionary[cell.titleLabel.text] = string;
}

@end
