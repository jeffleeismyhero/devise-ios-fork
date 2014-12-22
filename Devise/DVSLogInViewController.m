//
//  DVSLogInViewController.m
//  Devise
//
//  Created by Wojciech Trzasko on 22.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSLogInViewController.h"

#import "DVSLoginViewUserDataSource.h"
#import "DVSUser+Requests.h"

static NSString * const DVSTitleTag = @"title";
static NSString * const DVSEmailTag = @"email";
static NSString * const DVSPasswordTag = @"password";
static NSString * const DVSLogInTag = @"login";

@interface DVSLogInViewController ()

@property (strong, nonatomic) DVSLoginViewUserDataSource *userDataSource;

@end

@implementation DVSLogInViewController

#pragma mark - Initialization

- (instancetype)init {
    if (self = [super initWithForm:[self defaultForm]]) {
        self.userDataSource = [DVSLoginViewUserDataSource new];
    }
    return self;
}

#pragma mark - Form initialization

- (XLFormDescriptor *)defaultForm {
    XLFormDescriptor *form = [XLFormDescriptor formDescriptorWithTitle:NSLocalizedString(@"Log In", nil)];
    
    XLFormSectionDescriptor *section = [XLFormSectionDescriptor formSectionWithTitle:NSLocalizedString(@"Log In", nil)];
    
    [section addFormRow:[XLFormRowDescriptor formRowDescriptorWithTag:DVSEmailTag
                                                              rowType:XLFormRowDescriptorTypeEmail
                                                                title:NSLocalizedString(@"E-mail", nil)]];
    [section addFormRow:[XLFormRowDescriptor formRowDescriptorWithTag:DVSPasswordTag
                                                              rowType:XLFormRowDescriptorTypePassword
                                                                title:NSLocalizedString(@"Password", nil)]];
    
    XLFormRowDescriptor *logInButtonRow = [XLFormRowDescriptor formRowDescriptorWithTag:DVSLogInTag
                                                                                rowType:XLFormRowDescriptorTypeButton
                                                                                  title:NSLocalizedString(@"Log In", nil)];
    [logInButtonRow.cellConfig setObject:[UIColor blueColor] forKey:@"textLabel.textColor"];
    [logInButtonRow.cellConfig setObject:@(NSTextAlignmentCenter) forKey:@"textLabel.textAlignment"];
    logInButtonRow.action.formSelector = @selector(logInButtonTapped:);
    [section addFormRow:logInButtonRow];
    
    [form addFormSection:section];
    
    return form;
}

#pragma mark - UIControl events

- (void)logInButtonTapped:(XLFormRowDescriptor *)sender {
    NSDictionary *formValues = [self formValues];
    
    DVSUser *user = [DVSUser new];
    
    user.email = formValues[DVSEmailTag];
    user.password = formValues[DVSPasswordTag];
    user.dataSource = self.userDataSource;
    
    [user loginWithSuccess:^{
        if ([self.delegate respondsToSelector:@selector(logInViewController:didLogInUser:)]) {
            [self.delegate logInViewController:self didLogInUser:[DVSUser localUser]];
        }
    } failure:^(NSError *error) {
        if ([self.delegate respondsToSelector:@selector(logInViewController:didFailedWithError:)]) {
            [self.delegate logInViewController:self didFailedWithError:error];
        }
    }];
    
    [self deselectFormRow:sender];
}

@end
