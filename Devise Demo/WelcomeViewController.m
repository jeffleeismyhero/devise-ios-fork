//
//  WelcomeViewController.m
//  Devise
//
//  Created by Grzegorz Lesiak on 20/11/14.
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import "WelcomeViewController.h"

static NSString * const DVSRegisterSegue = @"register";
static NSString * const DVSLoginSegue = @"login";
static NSString * const DVSDefaultWelcomeCell = @"defaultCell";

@interface WelcomeViewController ()

@property (nonatomic,strong) NSArray * tableDataSource;

@end

@implementation WelcomeViewController

- (NSArray*) tableDataSource {
    if ( !_tableDataSource) {
        _tableDataSource = @[ @{@"title":@"Sign up", @"sub":@"Create new account", @"segue":DVSRegisterSegue},
                              @{@"title":@"Log in", @"sub":@"Already registered?", @"segue":DVSLoginSegue} ];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DVSDefaultWelcomeCell forIndexPath:indexPath];
    
    NSDictionary *dataDictionary = self.tableDataSource[indexPath.row];
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
