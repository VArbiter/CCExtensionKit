//
//  UINavigationItem+YMSpacing.m
//  ym_sell_ios
//
//  Created by 冯明庆 on 2017/3/31.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UINavigationItem+YMSpacing.h"

#import <objc/runtime.h>
//#import <objc/message.h>

@implementation UINavigationItem (YMSpacing)
/*
+ (void)load {
    method_exchangeImplementations(class_getClassMethod(self, @selector(setLeftBarButtonItem:)),
                                   class_getClassMethod(self, @selector(ymSetLeftButtonItem:)));
    method_exchangeImplementations(class_getClassMethod(self, @selector(setRightBarButtonItem:)),
                                   class_getClassMethod(self, @selector(ymSetRightButtonItem:)));
}
 */

- (void) ymSetLeftButtonItem : (UIBarButtonItem *) item
                  withOffset : (NSInteger) integerOffset {
    self.integerOffsetLeft = integerOffset;
    [self ymSetLeftButtonItem:item];
}
- (void) ymSetRightButtonItem : (UIBarButtonItem *) item
                   withOffset : (NSInteger) integerOffset {
    self.integerOffsetRight = integerOffset;
    [self ymSetRightButtonItem:item];
}

- (void) ymSetLeftButtonItem : (UIBarButtonItem *) item {
    UIBarButtonItem *itemBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                             target:nil
                                                                             action:nil];
    itemBar.width = self.integerOffsetLeft;
    NSArray *array = [NSArray arrayWithObjects:itemBar,item, nil];
    [self setLeftBarButtonItems:array];
}
- (void) ymSetRightButtonItem : (UIBarButtonItem *) item {
    UIBarButtonItem *itemBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                             target:nil
                                                                             action:nil];
    itemBar.width = self.integerOffsetRight;
    NSArray *array = [NSArray arrayWithObjects:itemBar,item, nil];
    [self setLeftBarButtonItems:array];
}

- (void)setIntegerOffsetLeft:(NSInteger)integerOffsetLeft {
    objc_setAssociatedObject(self, @selector(integerOffsetLeft), @(integerOffsetLeft), OBJC_ASSOCIATION_ASSIGN);
}
- (NSInteger)integerOffsetLeft {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setIntegerOffsetRight:(NSInteger)integerOffsetRight {
    objc_setAssociatedObject(self, @selector(setIntegerOffsetRight:), @(integerOffsetRight), OBJC_ASSOCIATION_ASSIGN);
}
- (NSInteger)integerOffsetRight {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

@end
