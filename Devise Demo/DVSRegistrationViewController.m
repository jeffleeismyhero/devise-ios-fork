//
//  RegistrationViewController.m
//  Devise
//
//  Created by Patryk Kaczmarek on 19.11.2014.
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import "DVSRegistrationViewController.h"
#import <Devise/Devise.h>

#import "DVSMacros.h"
#import "DVSDemoUser.h"
#import "DVSUser+Demo.h"
#import "UIAlertView+Devise.h"
#import "DVSDemoFormTableViewCell.h"

static NSString * const DVSEnterSegue = @"DisplayHomeView";
static NSString * const DVSDefaultCellId = @"defaultCell";

static NSString * const DVSRegistrationUsernameTitle = @"Username";
static NSString * const DVSRegistrationPasswordTitle = @"Password";
static NSString * const DVSRegistrationEmailTitle = @"Email";
static NSString * const DVSRegistrationFirstNameTitle = @"First name";
static NSString * const DVSRegistrationLastNameTitle = @"Last name";
static NSString * const DVSRegistrationPhone = @"Phone";

@interface DVSRegistrationViewController () <DVSDemoFormTableViewCellDelegate>

@property (strong, nonatomic) NSMutableArray *dataSourceTitlesArray;
@property (strong, nonatomic) NSMutableDictionary *dataSourceValuesDictionary;

@end

@implementation DVSRegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSourceTitlesArray = [NSMutableArray array];
    self.dataSourceValuesDictionary = [NSMutableDictionary dictionary];
    
    [self addFormWithTitleToDataSource:DVSRegistrationUsernameTitle];
    [self addFormWithTitleToDataSource:DVSRegistrationPasswordTitle];
    [self addFormWithTitleToDataSource:DVSRegistrationEmailTitle];
    [self addFormWithTitleToDataSource:DVSRegistrationFirstNameTitle];
    [self addFormWithTitleToDataSource:DVSRegistrationLastNameTitle];
    [self addFormWithTitleToDataSource:DVSRegistrationPhone];
}

#pragma mark - DataSource helpers

- (void)addFormWithTitleToDataSource:(NSString *)title {
    [self.dataSourceTitlesArray addObject:title];
    self.dataSourceValuesDictionary[title] = @"";
}

- (NSString *)getValueForTitle:(NSString *)title {
    return self.dataSourceValuesDictionary[title];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceTitlesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DVSDemoFormTableViewCell *cell = (DVSDemoFormTableViewCell *)[tableView dequeueReusableCellWithIdentifier:DVSDefaultCellId forIndexPath:indexPath];
    
    cell.titleLabel.text = self.dataSourceTitlesArray[indexPath.item];
    cell.delegate = self;
    
    return cell;
}

#pragma mark - DVSDemoFormTableViewCellDelegate

- (void)formTableViewCell:(DVSDemoFormTableViewCell *)cell changedValue:(NSString *)string {
    self.dataSourceValuesDictionary[cell.titleLabel.text] = string;
}

#pragma mark - Touch

- (IBAction)signUpTouched:(UIBarButtonItem *)sender {
    DVSDemoUser *newUser = [[DVSDemoUser alloc] init];
    
    newUser.username = [self getValueForTitle:DVSRegistrationUsernameTitle];
    newUser.password = [self getValueForTitle:DVSRegistrationPasswordTitle];
    newUser.email = [self getValueForTitle:DVSRegistrationEmailTitle];
    newUser.firstName = [self getValueForTitle:DVSRegistrationFirstNameTitle];
    newUser.lastName = [self getValueForTitle:DVSRegistrationLastNameTitle];
    newUser.phone = [self getValueForTitle:DVSRegistrationPhone];
    
    [newUser registerWithSuccess:^{
        [self performSegueWithIdentifier:DVSEnterSegue sender:self];
    } failure:^(NSError *error) {
        [[UIAlertView dvs_alertViewForError:error] show];
    }];
}

@end
