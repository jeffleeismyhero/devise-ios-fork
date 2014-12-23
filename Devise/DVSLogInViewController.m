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
        [self setupForViews:defaultOptions];
    }
    return self;
}

- (instancetype)initWithViewsOptions:(DVSLogInViewsOptions)viewsOptions {
    if (self = [super initWithForm:[self formForOptions:viewsOptions]]) {
        [self setupForViews:viewsOptions];
    }
    return self;
}

- (void)setupForViews:(DVSLogInViewsOptions)viewOptions {
    self.userDataSource = [DVSLoginViewUserDataSource new];
    
    BOOL shouldShowNavigationLogInButton = (viewOptions & DVSLogInViewsNavigationLogInButton) == DVSLogInViewsNavigationLogInButton;
    if (shouldShowNavigationLogInButton) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Log In", nil)
                                                                                  style:UIBarButtonItemStylePlain
                                                                                 target:self
                                                                                 action:@selector(navigationLogInButtonTapped:)];
    }
    
    BOOL shouldShowNavigationDismissButton = (viewOptions & DVSLogInViewsNavigationDismissButton) == DVSLogInViewsNavigationDismissButton;
    if (shouldShowNavigationDismissButton) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                              target:self
                                                                                              action:@selector(navigationDismissButtonTapped:)];
    }
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
        [section addFormRow:[XLFormRowDescriptor dvs_emailRowWithTag:DVSEmailTag]];
        [section addFormRow:[XLFormRowDescriptor dvs_passwordRowWithTag:DVSPasswordTag]];
    }
    
    BOOL shouldShowLogInButton = (viewsOptions & DVSLogInViewsLogInButton) == DVSLogInViewsLogInButton;
    if (shouldShowLogInButton) {
        XLFormRowDescriptor *logInButtonRow = [XLFormRowDescriptor dvs_buttonRowWithTag:DVSLogInTag
                                                                                  title:NSLocalizedString(@"Log In", nil)
                                                                                  color:[UIColor blueColor]];
        logInButtonRow.action.formSelector = @selector(logInButtonTapped:);
        
        [section addFormRow:logInButtonRow];
    }
    
    BOOL shouldShowDismissButton = (viewsOptions & DVSLogInViewsDismissButton) == DVSLogInViewsDismissButton;
    if (shouldShowDismissButton) {
        XLFormRowDescriptor *dismissButtonRow = [XLFormRowDescriptor dvs_buttonRowWithTag:DVSDismissTag
                                                                                    title:NSLocalizedString(@"Cancel", nil)
                                                                                    color:[UIColor redColor]];
        dismissButtonRow.action.formSelector = @selector(dismissButtonTapped:);
        
        [section addFormRow:dismissButtonRow];
    }
    
    [form addFormSection:section];
    
    return form;
}

#pragma mark - UIControl events

- (void)logInButtonTapped:(XLFormRowDescriptor *)sender {
    [self performLogInAction];
    [self deselectFormRow:sender];
}

- (void)navigationLogInButtonTapped:(UIBarButtonItem *)sender {
    [self performLogInAction];
}

- (void)dismissButtonTapped:(XLFormRowDescriptor *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self deselectFormRow:sender];
}

- (void)navigationDismissButtonTapped:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Actions

- (void)performLogInAction {
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
}

@end
