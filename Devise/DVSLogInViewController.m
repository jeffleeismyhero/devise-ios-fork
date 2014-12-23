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
#import "XLFormRowDescriptor+Devise.h"

static NSString * const DVSTitleTag = @"title";
static NSString * const DVSEmailTag = @"email";
static NSString * const DVSPasswordTag = @"password";
static NSString * const DVSLogInTag = @"login";
static NSString * const DVSDismissTag = @"dismiss";

@interface DVSLogInViewController ()

@property (strong, nonatomic) DVSLoginViewUserDataSource *userDataSource;

@end

@implementation DVSLogInViewController

#pragma mark - Initialization

- (instancetype)init {
    DVSLogInViewsOptions defaultOptions = [self defaultViewsOptions];
    if (self = [super initWithForm:[self formForOptions:defaultOptions]]) {
        [self initialSetup];
    }
    return self;
}

- (instancetype)initWithViewsOptions:(DVSLogInViewsOptions)viewsOptions {
    if (self = [super initWithForm:[self formForOptions:viewsOptions]]) {
        [self initialSetup];
    }
    return self;
}

- (void)initialSetup {
    self.userDataSource = [DVSLoginViewUserDataSource new];
}

- (DVSLogInViewsOptions)defaultViewsOptions {
    return DVSLogInViewsEmailAndPassword | DVSLogInViewsLogInButton;
}

#pragma mark - Form initialization

- (XLFormDescriptor *)formForOptions:(DVSLogInViewsOptions)viewsOptions {
    XLFormDescriptor *form = [XLFormDescriptor formDescriptorWithTitle:NSLocalizedString(@"Log In", nil)];
    
    XLFormSectionDescriptor *section = [XLFormSectionDescriptor formSectionWithTitle:NSLocalizedString(@"Log In", nil)];
    
    BOOL shouldShowEmailAndPassword = (viewsOptions & DVSLogInViewsEmailAndPassword) == DVSLogInViewsEmailAndPassword;
    if (shouldShowEmailAndPassword) {
        [section addFormRow:[XLFormRowDescriptor formRowDescriptorWithTag:DVSEmailTag
                                                                  rowType:XLFormRowDescriptorTypeEmail
                                                                    title:NSLocalizedString(@"E-mail", nil)]];
        [section addFormRow:[XLFormRowDescriptor formRowDescriptorWithTag:DVSPasswordTag
                                                                  rowType:XLFormRowDescriptorTypePassword
                                                                    title:NSLocalizedString(@"Password", nil)]];
    }
    
    BOOL shouldShowLogInButton = (viewsOptions & DVSLogInViewsLogInButton) == DVSLogInViewsLogInButton;
    if (shouldShowLogInButton) {
        XLFormRowDescriptor *logInButtonRow = [XLFormRowDescriptor formRowDescriptorWithTag:DVSLogInTag
                                                                                    rowType:XLFormRowDescriptorTypeButton
                                                                                      title:NSLocalizedString(@"Log In", nil)];
        [logInButtonRow dvs_customizeTextWithColor:[UIColor blueColor] alignment:NSTextAlignmentCenter];
        logInButtonRow.action.formSelector = @selector(logInButtonTapped:);
        
        [section addFormRow:logInButtonRow];
    }
    
    BOOL shouldShowDismissButton = (viewsOptions & DVSLogInViewsDismissButton) == DVSLogInViewsDismissButton;
    if (shouldShowDismissButton) {
        XLFormRowDescriptor *dismissButtonRow = [XLFormRowDescriptor formRowDescriptorWithTag:DVSDismissTag
                                                                                      rowType:XLFormRowDescriptorTypeButton
                                                                                        title:NSLocalizedString(@"Cancel", nil)];
        [dismissButtonRow dvs_customizeTextWithColor:[UIColor redColor] alignment:NSTextAlignmentCenter];
        dismissButtonRow.action.formSelector = @selector(dismissButtonTapped:);
        
        [section addFormRow:dismissButtonRow];
    }
    
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

- (void)dismissButtonTapped:(XLFormRowDescriptor *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self deselectFormRow:sender];
}

@end
