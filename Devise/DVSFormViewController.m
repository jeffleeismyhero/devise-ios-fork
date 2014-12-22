//
//  DVSFormTableViewController.m
//  Devise
//
//  Created by Wojciech Trzasko on 11.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSFormViewController.h"

#import "DVSFormTextFieldCell.h"
#import "DVSFormTextFieldModel.h"

static NSString * const DVSDefaultCellId = @"defaultCell";

@interface DVSFormViewController () <DVSFormTableViewCellDelegate>

@property (strong, nonatomic) NSMutableArray *dataSourceTitlesArray;
@property (strong, nonatomic) NSMutableDictionary *dataSourceValuesDictionary;

@end

@implementation DVSFormViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSourceTitlesArray = [NSMutableArray array];
    self.dataSourceValuesDictionary = [NSMutableDictionary dictionary];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DVSFormTextFieldCell class])
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
    self.dataSourceValuesDictionary[title] = [[DVSFormTextFieldModel alloc] initWithValue:@""
                                                                              secured:secured
                                                                         keyboardType:keyboardType];
}

- (void)setValue:(NSString *)value forTitle:(NSString *)title {
    DVSFormTextFieldModel *model = (DVSFormTextFieldModel *)self.dataSourceValuesDictionary[title];
    
    NSAssert(model, @"No model for current title");
    
    self.dataSourceValuesDictionary[title] = [[DVSFormTextFieldModel alloc] initWithValue:value
                                                                              secured:model.secured
                                                                         keyboardType:model.keyboardType];
    [self.tableView reloadData];
}

- (NSString *)getValueForTitle:(NSString *)title {
    DVSFormTextFieldModel *model = (DVSFormTextFieldModel *)self.dataSourceValuesDictionary[title];
    return model.value;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceTitlesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DVSFormTextFieldCell *cell = (DVSFormTextFieldCell *)[tableView dequeueReusableCellWithIdentifier:DVSDefaultCellId forIndexPath:indexPath];
    
    NSString *title = self.dataSourceTitlesArray[indexPath.item];
    DVSFormTextFieldModel *model = self.dataSourceValuesDictionary[title];
    
    cell.titleLabel.text = title;
    cell.delegate = self;
    cell.valueTextField.text = model.value;
    cell.valueTextField.secureTextEntry = model.secured;
    cell.valueTextField.keyboardType = model.keyboardType;
    
    return cell;
}

#pragma mark - DVSDemoFormTableViewCellDelegate

- (void)formTableViewCell:(DVSFormTextFieldCell *)cell changedValue:(NSString *)string {
    DVSFormTextFieldModel *model = (DVSFormTextFieldModel *)self.dataSourceValuesDictionary[cell.titleLabel.text];
    self.dataSourceValuesDictionary[cell.titleLabel.text] = [[DVSFormTextFieldModel alloc] initWithValue:string
                                                                                             secured:model.secured
                                                                                        keyboardType:model.keyboardType];
}

@end
