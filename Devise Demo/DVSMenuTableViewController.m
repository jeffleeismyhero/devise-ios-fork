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

@implementation DVSMenuTableViewController

#pragma mark - Abstract methods

- (NSString *)defaultCellId {
    NSAssert(NO, @"Abstract method called.");
    return @"";
}

- (NSArray *)tableDataSource {
    NSAssert(NO, @"Abstract method called.");
    return @[];
}

#pragma mark - TableView data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self tableDataSource].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self defaultCellId] forIndexPath:indexPath];
    
    NSDictionary *dataDictionary = [self tableDataSource][indexPath.row];
    
    cell.textLabel.text = dataDictionary[DVSTableModelTitleKey];
    cell.detailTextLabel.text = dataDictionary[DVSTableModelSubtitleKey];
    
    return cell;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Menu";
}

#pragma mark - TableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dataDictionary = [self tableDataSource][indexPath.row];
    [self performSegueWithIdentifier:dataDictionary[DVSTableModelSegueKey] sender:self];
}

@end
