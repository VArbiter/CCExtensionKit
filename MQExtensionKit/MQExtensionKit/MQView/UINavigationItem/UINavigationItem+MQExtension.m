//
//  UINavigationItem+MQExtension.m
//  MQExtensionKit
//
//  Created by Elwinfrederick on 08/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "UINavigationItem+MQExtension.h"

@implementation UINavigationItem (CCExtension)

@end

#pragma mark - -----

@implementation UINavigationItem (CCExtension_FixedSpace)

- (void) mq_left_offset : (CGFloat) fOffset
                   item : (UIBarButtonItem *) item {
    if (fOffset >= 0) return;
    UIBarButtonItem *itemBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                             target:nil
                                                                             action:nil];
    itemBar.width = fOffset;
    NSArray *array = [NSArray arrayWithObjects:itemBar, item, nil];
    [self setLeftBarButtonItems:array];
}
- (void) mq_right_offset : (CGFloat) fOffset
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
