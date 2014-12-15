//
//  DVSFormTableViewController.m
//  Devise
//
//  Created by Wojciech Trzasko on 11.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSFormTableViewController.h"

#import "DVSFormTableViewCell.h"
#import "DVSFormTableModel.h"

static NSString * const DVSDefaultCellId = @"defaultCell";

@interface DVSFormTableViewController () <DVSFormTableViewCellDelegate>

@property (strong, nonatomic) NSMutableArray *dataSourceTitlesArray;
@property (strong, nonatomic) NSMutableDictionary *dataSourceValuesDictionary;

@end

@implementation DVSFormTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSourceTitlesArray = [NSMutableArray array];
    self.dataSourceValuesDictionary = [NSMutableDictionary dictionary];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DVSFormTableViewCell class])
                                               bundle:nil]
         forCellReuseIdentifier:DVSDefaultCellId];
}

#pragma mark - DataSource helpers

- (void)addFormWithTitleToDataSource:(NSString *)title {
    [self addFormWithTitleToDataSource:title secured:NO];
}

- (void)addFormWithTitleToDataSource:(NSString *)title secured:(BOOL)secured {
    [self.dataSourceTitlesArray addObject:title];
    self.dataSourceValuesDictionary[title] = [[DVSFormTableModel alloc] initWithValue:@"" secured:secured];
}

- (NSString *)getValueForTitle:(NSString *)title {
    DVSFormTableModel *model = (DVSFormTableModel *)self.dataSourceValuesDictionary[title];
    return model.value;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceTitlesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DVSFormTableViewCell *cell = (DVSFormTableViewCell *)[tableView dequeueReusableCellWithIdentifier:DVSDefaultCellId forIndexPath:indexPath];
    
    NSString *title = self.dataSourceTitlesArray[indexPath.item];
    DVSFormTableModel *model = self.dataSourceValuesDictionary[title];
    
    cell.titleLabel.text = title;
    cell.delegate = self;
    cell.valueTextField.text = model.value;
    cell.valueTextField.secureTextEntry = model.secured;
    
    return cell;
}

#pragma mark - DVSDemoFormTableViewCellDelegate

- (void)formTableViewCell:(DVSFormTableViewCell *)cell changedValue:(NSString *)string {
    DVSFormTableModel *model = (DVSFormTableModel *)self.dataSourceValuesDictionary[cell.titleLabel.text];
    self.dataSourceValuesDictionary[cell.titleLabel.text] = [[DVSFormTableModel alloc] initWithValue:string
                                                                                             secured:model.secured];
}

@end
