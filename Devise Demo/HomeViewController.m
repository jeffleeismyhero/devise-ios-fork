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

static NSString * const DVSHomeModelTitleKey = @"title";
static NSString * const DVSHomeModelSubtitleKey = @"sub";
static NSString * const DVSHomeModelSegueKey = @"segue";

@interface HomeViewController ()

@property (nonatomic,strong) NSArray * tableDataSource;

@end

@implementation HomeViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDataSource];
}

#pragma mark - Setup

- (void)setupDataSource {
    self.tableDataSource = @[ @{DVSHomeModelTitleKey: @"Change password",
                                DVSHomeModelSubtitleKey: @"Do you feel your password is bad?",
                                DVSHomeModelSegueKey: DVSPasswordChangeSegue},
                              ];
}

#pragma mark - Button callbacks

- (IBAction)logoutTouched:(UIBarButtonItem *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
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
    cell.textLabel.text = dataDictionary[DVSHomeModelTitleKey];
    cell.detailTextLabel.text = dataDictionary[DVSHomeModelSubtitleKey];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary * dataDictionary = self.tableDataSource[indexPath.row];
    [self performSegueWithIdentifier:dataDictionary[DVSHomeModelSegueKey] sender:self];
}

@end
