//
//  UINavigationItem+MQExtension.m
//  MQExtensionKit
//
//  Created by Elwinfrederick on 08/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "UINavigationItem+MQExtension.h"

@implementation UINavigationItem (MQExtension)

@end

#pragma mark - -----

@implementation UINavigationItem (MQExtension_FixedSpace)

- (void) mq_left_offset : (CGFloat) f_offset
                   item : (UIBarButtonItem *) item {
    if (f_offset >= 0) return;
    UIBarButtonItem *item_bar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                             target:nil
                                                                             action:nil];
    item_bar.width = f_offset;
    NSArray *array = [NSArray arrayWithObjects:item_bar, item, nil];
    [self setLeftBarButtonItems:array];
}
- (void) mq_right_offset : (CGFloat) f_offset
                    item : (UIBarButtonItem *) item {
    if (f_offset >= 0) return;
    UIBarButtonItem *item_bar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                             target:nil
                                                                             action:nil];
    item_bar.width = f_offset;
    NSArray *array = [NSArray arrayWithObjects:item_bar, item, nil];
    [self setRightBarButtonItems:array];
}

@end
