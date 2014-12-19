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
    [self addFormWithTitleToDataSource:title secured:NO keyboardType:UIKeyboardTypeDefault];
}

- (void)addFormWithTitleToDataSource:(NSString *)title secured:(BOOL)secured {
    [self addFormWithTitleToDataSource:title secured:secured keyboardType:UIKeyboardTypeDefault];
}

- (void)addFormWithTitleToDataSource:(NSString *)title keyboardType:(UIKeyboardType)keyboardType {
    [self addFormWithTitleToDataSource:title secured:NO keyboardType:keyboardType];
}

- (void)addFormWithTitleToDataSource:(NSString *)title secured:(BOOL)secured keyboardType:(UIKeyboardType)keyboardType {
    [self.dataSourceTitlesArray addObject:title];
    self.dataSourceValuesDictionary[title] = [[DVSFormTableModel alloc] initWithValue:@""
                                                                              secured:secured
                                                                         keyboardType:keyboardType];
}

- (void)setValue:(NSString *)value forTitle:(NSString *)title {
    DVSFormTableModel *model = (DVSFormTableModel *)self.dataSourceValuesDictionary[title];
    
    NSAssert(model, @"No model for current title");
    
    self.dataSourceValuesDictionary[title] = [[DVSFormTableModel alloc] initWithValue:value
                                                                              secured:model.secured
                                                                         keyboardType:model.keyboardType];
    [self.tableView reloadData];
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
    
    [cell configureForTitle:title model:model];
    cell.delegate = self;
    
    return cell;
}

#pragma mark - DVSDemoFormTableViewCellDelegate

- (void)formTableViewCell:(DVSFormTableViewCell *)cell changedValue:(NSString *)string {
    DVSFormTableModel *model = (DVSFormTableModel *)self.dataSourceValuesDictionary[cell.titleLabel.text];
    self.dataSourceValuesDictionary[cell.titleLabel.text] = [[DVSFormTableModel alloc] initWithValue:string
                                                                                             secured:model.secured
                                                                                        keyboardType:model.keyboardType];
}

@end
