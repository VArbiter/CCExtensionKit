//
//  UINavigationItem+CCExtension.m
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 08/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "UINavigationItem+CCExtension.h"

@implementation UINavigationItem (CCExtension)

@end

#pragma mark - -----

@implementation UINavigationItem (CCExtension_FixedSpace)

- (void) ccLeftOffset : (CGFloat) fOffset
                 item : (UIBarButtonItem *) item {
    if (fOffset >= 0) return;
    UIBarButtonItem *itemBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                             target:nil
                                                                             action:nil];
    itemBar.width = fOffset;
    NSArray *array = [NSArray arrayWithObjects:itemBar, item, nil];
    [self setLeftBarButtonItems:array];
}
- (void) ccRightOffset : (CGFloat) fOffset
                  item : (UIBarButtonItem *) item {
    if (fOffset >= 0) return;
    UIBarButtonItem *itemBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                             target:nil
                                                                             action:nil];
    itemBar.width = fOffset;
    NSArray *array = [NSArray arrayWithObjects:itemBar, item, nil];
    [self setRightBarButtonItems:array];
}

@end
