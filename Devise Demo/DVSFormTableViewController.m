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
static NSString * const DVSTableModelValueKey = @"value";
static NSString * const DVSTableModelSecuredKey = @"secured";

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
    [self addFormWithTitleToDataSource:title secured:NO];
}

- (void)addFormWithTitleToDataSource:(NSString *)title secured:(BOOL)secured {
    [self.dataSourceTitlesArray addObject:title];
    self.dataSourceValuesDictionary[title] = @{ DVSTableModelValueKey: @"",
                                                DVSTableModelSecuredKey: [NSNumber numberWithBool:secured] };
}

- (NSString *)getValueForTitle:(NSString *)title {
    return self.dataSourceValuesDictionary[title][DVSTableModelValueKey];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceTitlesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DVSDemoFormTableViewCell *cell = (DVSDemoFormTableViewCell *)[tableView dequeueReusableCellWithIdentifier:DVSDefaultCellId forIndexPath:indexPath];
    
    NSString *title = self.dataSourceTitlesArray[indexPath.item];
    cell.titleLabel.text = title;
    cell.delegate = self;
    cell.valueTextField.secureTextEntry = ((NSNumber *)self.dataSourceValuesDictionary[title][DVSTableModelSecuredKey]).boolValue;
    
    return cell;
}

#pragma mark - DVSDemoFormTableViewCellDelegate

- (void)formTableViewCell:(DVSDemoFormTableViewCell *)cell changedValue:(NSString *)string {
    NSNumber *isSecured = self.dataSourceValuesDictionary[cell.titleLabel.text][DVSTableModelSecuredKey];
    self.dataSourceValuesDictionary[cell.titleLabel.text] = @{ DVSTableModelValueKey: string,
                                                               DVSTableModelSecuredKey: isSecured };
}

@end
