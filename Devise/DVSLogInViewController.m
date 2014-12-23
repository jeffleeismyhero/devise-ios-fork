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

- (void)setupForViews:(DVSLogInViewsOptions)viewsOptions {
    self.userDataSource = [DVSLoginViewUserDataSource new];
    
    __weak typeof(self) weakSelf = self;
    
    if ([self shouldShow:DVSLogInViewsDismissButton basedOn:viewsOptions]) {
        [self setupLeftNavigationBarButtonWithTitle:NSLocalizedString(@"Cancel", nil)
                                             action:^{
                                                 [weakSelf dismissViewControllerAnimated:YES completion:nil];
                                             }];
    }
    
    if ([self shouldShow:DVSLogInViewsNavigationLogInButton basedOn:viewsOptions]) {
        [self setupRightNavigationBarButtonWithTitle:NSLocalizedString(@"Log In", nil) action:^{
            [weakSelf performLogInAction];
        }];
    }
}

- (DVSLogInViewsOptions)defaultViewsOptions {
    return DVSLogInViewsEmailAndPassword | DVSLogInViewsLogInButton;
}

#pragma mark - Form initialization

- (XLFormDescriptor *)formForOptions:(DVSLogInViewsOptions)viewsOptions {
    XLFormDescriptor *form = [XLFormDescriptor formDescriptorWithTitle:NSLocalizedString(@"Log In", nil)];
    
    XLFormSectionDescriptor *section = [XLFormSectionDescriptor formSectionWithTitle:NSLocalizedString(@"Log In", nil)];
    
    if ([self shouldShow:DVSLogInViewsEmailAndPassword basedOn:viewsOptions]) {
        [self addEmailAndPasswordToSection:section];
    }
    
    __weak typeof(self) weakSelf = self;

    if ([self shouldShow:DVSLogInViewsLogInButton basedOn:viewsOptions]) {
        [self addProceedButtonToSection:section
                                  title:NSLocalizedString(@"Log In", nil)
                                 action:^{
                                     [weakSelf performLogInAction];
                                 }];
    }
    
    if ([self shouldShow:DVSLogInViewsDismissButton basedOn:DVSLogInViewsDismissButton]) {
        [self addDismissButtonToSection:section
                                  title:NSLocalizedString(@"Cancel", nil)
                                 action:^{
                                     [weakSelf dismissViewControllerAnimated:YES completion:nil];
                                 }];
    }
    
    [form addFormSection:section];
    
    return form;
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
