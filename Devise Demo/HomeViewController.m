//
//  HomeViewController.m
//  Devise
//
//  Created by Grzegorz Lesiak on 20/11/14.
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import "HomeViewController.h"


static NSString * const DVSPasswordChangeSegue = @"password change";
static NSString * const DVSHomeDefaultCell = @"defaultCell";

@interface HomeViewController ()

@property (nonatomic,strong) NSArray * tableDataSource;

@end

@implementation HomeViewController

- (IBAction)logoutTouched:(UIBarButtonItem *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (NSArray*)tableDataSource {
    if (!_tableDataSource) {
        _tableDataSource = @[ @{@"title": @"Change password",
                                @"sub": @"Do you feel your password is bad?",
                                @"segue": DVSPasswordChangeSegue} ];
    }
    return _tableDataSource;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableDataSource count];
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Menu";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DVSHomeDefaultCell forIndexPath:indexPath];
    NSDictionary * dataDictionary = self.tableDataSource[indexPath.row];
    cell.textLabel.text = dataDictionary[@"title"];
    cell.detailTextLabel.text = dataDictionary[@"sub"];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary * dataDictionary = self.tableDataSource[indexPath.row];
    [self performSegueWithIdentifier:dataDictionary[@"segue"] sender:self];
}

@end
