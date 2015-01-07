//
//  DVSMenuTableViewController.m
//  Devise
//
//  Created by Wojciech Trzasko on 09.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSMenuTableViewController.h"

#import "DVSMenuTableModel.h"

static NSString * const DVSDefaultCell = @"defaultCell";

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

#pragma mark - Menu entries

- (void)addMenuEntryWithTitle:(NSString *)title subtitle:(NSString *)subtitle segue:(NSString *)segue {
    [self addMenuEntryWithTitle:title subtitle:subtitle accessibilityLabel:title segue:segue];
}

- (void)addMenuEntryWithTitle:(NSString *)title subtitle:(NSString *)subtitle accessibilityLabel:(NSString *)accessibilityLabel segue:(NSString *)segue {
    [self.dataSourceArray addObject:[[DVSMenuTableModel alloc] initWithTitle:title
                                                                    subtitle:subtitle
                                                          accessibilityLabel:accessibilityLabel
                                                             segueIdentifier:segue]];
}

- (void)addMenuEntryWithTitle:(NSString *)title subtitle:(NSString *)subtitle target:(id)target action:(SEL)selector {
    [self addMenuEntryWithTitle:title subtitle:subtitle accessibilityLabel:title target:target action:selector];
}

- (void)addMenuEntryWithTitle:(NSString *)title subtitle:(NSString *)subtitle accessibilityLabel:(NSString *)accesibilityLabel target:(id)target action:(SEL)selector {
    [self.dataSourceArray addObject:[[DVSMenuTableModel alloc] initWithTitle:title
                                                                    subtitle:subtitle
                                                          accessibilityLabel:title
                                                                      target:target
                                                                    selector:selector]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self defaultCellId] forIndexPath:indexPath];
    
    DVSMenuTableModel *model = (DVSMenuTableModel *)self.dataSourceArray[indexPath.row];
    
    cell.textLabel.text = model.title;
    cell.accessibilityLabel = model.accessibilityLabel;
    cell.detailTextLabel.text = model.subtitle;
    
    return cell;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return NSLocalizedString(@"Menu", nil);
}

#pragma mark - TableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DVSMenuTableModel *model = (DVSMenuTableModel *)self.dataSourceArray[indexPath.row];
    
    if (model.selector && model.target) {
        [self performSelectorWithModel:model];
    } else if (model.segueIdentifier) {
        [self performSegueWithModel:model];
    }
}

- (void)performSelectorWithModel:(DVSMenuTableModel *)model {
    if (model.selector && model.target) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [model.target performSelector:model.selector];
        #pragma clang diagnostic pop
    }
}

- (void)performSegueWithModel:(DVSMenuTableModel *)model {
    // Prevent performing segue multiple times. Bug connected with:
    // http://stackoverflow.com/questions/5687991/tableview-didselectrowatindexpath-called-twice
    if (self.navigationController.topViewController != self) {
        return;
    }
    [self performSegueWithIdentifier:model.segueIdentifier sender:self];
}

@end
