//
//  UIAlertView+DeviseDemo.m
//  Devise
//
//  Created by Wojciech Trzasko on 09.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "UIAlertView+DeviseDemo.h"

#import "NSError+DeviseDemo.h"

@implementation UIAlertView (DeviseDemo)

+ (UIAlertView *)dvs_alertViewForError:(NSError *)error statusDescriptionsDictionary:(NSDictionary *)dictionary {
    NSInteger errorCode = [error dvs_urlStatusCode];
    NSString *descripionForCode = dictionary[@(errorCode)];
    if (descripionForCode) {
        return [self dvs_alertViewForErrorLocalizedDescription:descripionForCode];
    } else {
        return [self dvs_alertViewForError:error];
    }
}

+ (UIAlertView *)dvs_alertViewForError:(NSError *)error {
    return [self dvs_alertViewForErrorLocalizedDescription:error.localizedDescription];
}

+ (UIAlertView *)dvs_alertViewForErrorLocalizedDescription:(NSString *)localizedDescription {
    return [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                      message:localizedDescription
                                     delegate:nil
                            cancelButtonTitle:NSLocalizedString(@"Close", nil)
                            otherButtonTitles:nil];
}

@end
