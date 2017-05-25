//
//  UINavigationItem+CCSpacing.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/3/31.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UINavigationItem+CCSpacing.h"

#import <objc/runtime.h>
//#import <objc/message.h>

@implementation UINavigationItem (CCSpacing)
/*
+ (void)load {
    method_exchangeImplementations(class_getClassMethod(self, @selector(setLeftBarButtonItem:)),
                                   class_getClassMethod(self, @selector(ccSetLeftButtonItem:)));
    method_exchangeImplementations(class_getClassMethod(self, @selector(setRightBarButtonItem:)),
                                   class_getClassMethod(self, @selector(ccSetRightButtonItem:)));
}
 */

- (void) ccSetLeftButtonItem : (UIBarButtonItem *) item
                  withOffset : (NSInteger) integerOffset {
    self.integerOffsetLeft = integerOffset;
    [self ccSetLeftButtonItem:item];
}
- (void) ccSetRightButtonItem : (UIBarButtonItem *) item
                   withOffset : (NSInteger) integerOffset {
    self.integerOffsetRight = integerOffset;
    [self ccSetRightButtonItem:item];
}

- (void) ccSetLeftButtonItem : (UIBarButtonItem *) item {
    UIBarButtonItem *itemBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                             target:nil
                                                                             action:nil];
    itemBar.width = self.integerOffsetLeft;
    NSArray *array = [NSArray arrayWithObjects:itemBar,item, nil];
    [self setLeftBarButtonItems:array];
}
- (void) ccSetRightButtonItem : (UIBarButtonItem *) item {
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
