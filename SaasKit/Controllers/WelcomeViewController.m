//
//  WelcomeViewController.m
//  SaasKit
//
//  Created by Grzegorz Lesiak on 20/11/14.
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import "WelcomeViewController.h"

#define SSKRegisterSegue @"register"
#define SSKLoginSegue @"login"

@interface WelcomeViewController ()

@property (nonatomic,strong) NSArray * tableDataSource;

@end

@implementation WelcomeViewController

- (NSArray*) tableDataSource {
    if ( !_tableDataSource) {
        _tableDataSource = @[ @{@"title":@"Sign up", @"sub":@"Create new account", @"segue":SSKRegisterSegue},
                              @{@"title":@"Log in", @"sub":@"Already registered?", @"segue":SSKLoginSegue} ];
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

static NSString * const defaultCell = @"defaultCell";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: defaultCell forIndexPath:indexPath];
    NSDictionary * dataDictionary = self.tableDataSource[indexPath.row];
    cell.textLabel.text = dataDictionary[@"title"];
    cell.detailTextLabel.text = dataDictionary[@"sub"];
    return cell;
}

#pragma mark - Table view delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary * dataDictionary = self.tableDataSource[indexPath.row];
    [self performSegueWithIdentifier:dataDictionary[@"segue"] sender:self];
}

@end
