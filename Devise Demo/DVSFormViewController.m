//
//  DVSFormTableViewController.m
//  Devise
//
//  Created by Wojciech Trzasko on 11.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSFormViewController.h"

#import "DVSFormRow.h"
#import "DVSFormRowCell.h"
#import "DVSFormRowCell+Model.h"

static NSString * const DVSDefaultCellId = @"defaultCell";

@interface DVSFormViewController () <DVSFormTableViewCellDelegate>

@property (strong, nonatomic) NSMutableArray *dataSourceArray;

@end

@implementation DVSFormViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSourceArray = [NSMutableArray array];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DVSFormRowCell class])
                                               bundle:nil]
         forCellReuseIdentifier:DVSDefaultCellId];
}

#pragma mark - DataSource helpers

- (void)addFormWithTitleToDataSource:(NSString *)title accessibilityLabel:(NSString *)accessibilityLabel secured:(BOOL)secured {
    [self addFormWithTitleToDataSource:title
                    accessibilityLabel:accessibilityLabel
                               secured:secured
                          keyboardType:UIKeyboardTypeDefault];
}

- (void)addFormWithTitleToDataSource:(NSString *)title accessibilityLabel:(NSString *)accessibilityLabel keyboardType:(UIKeyboardType)keyboardType {
    [self addFormWithTitleToDataSource:title
                    accessibilityLabel:accessibilityLabel
                               secured:NO
                          keyboardType:keyboardType];
}

- (void)addFormWithTitleToDataSource:(NSString *)title accessibilityLabel:(NSString *)accessibilityLabel secured:(BOOL)secured keyboardType:(UIKeyboardType)keyboardType {
    DVSFormRow *model = [[DVSFormRow alloc] initWithTitle:title
                                       accessibilityLabel:accessibilityLabel
                                                    value:@""
                                                  secured:secured
                                             keyboardType:keyboardType];
    [self.dataSourceArray addObject:model];
}

- (void)setValue:(NSString *)value forTitle:(NSString *)title {
    DVSFormRow *model = [self formTableModelForTitle:title];
    
    NSAssert(model, @"No model for current title");
    
    NSUInteger indexOfModel = [self.dataSourceArray indexOfObject:model];
    self.dataSourceArray[indexOfModel] = [[DVSFormRow alloc] initWithTitle:model.title
                                                        accessibilityLabel:model.accessibilityLabel
                                                                     value:value
                                                                   secured:model.secured
                                                              keyboardType:model.keyboardType];
}

- (NSString *)valueForTitle:(NSString *)title {
    return [self formTableModelForTitle:title].value;
}

- (DVSFormRow *)formTableModelForTitle:(NSString *)title {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.title = %@", title];
    return [[[self dataSourceArray] filteredArrayUsingPredicate:predicate] firstObject];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DVSFormRowCell *cell = (DVSFormRowCell *)[tableView dequeueReusableCellWithIdentifier:DVSDefaultCellId forIndexPath:indexPath];
    
    DVSFormRow *model = (DVSFormRow *)self.dataSourceArray[indexPath.item];
    
    cell.delegate = self;
    [cell configureWithRow:model];
    
    return cell;
}

#pragma mark - DVSDemoFormTableViewCellDelegate

- (void)formTableViewCellDidChangeValue:(DVSFormRowCell *)cell {
    [self setValue:cell.valueTextField.text forTitle:cell.titleLabel.text];
}

@end
