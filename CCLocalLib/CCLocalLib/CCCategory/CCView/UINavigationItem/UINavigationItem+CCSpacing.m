//
//  UINavigationItem+CCSpacing.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/3/31.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UINavigationItem+CCSpacing.h"

#import <objc/runtime.h>

@implementation UINavigationItem (CCSpacing)

- (void) ccLeft : (UIBarButtonItem *) item
         offset : (NSInteger) integerOffset {
    self.iOffsetLeft = integerOffset;
    [self ccLeft:item];
}
- (void) ccRight : (UIBarButtonItem *) item
          offset : (NSInteger) integerOffset {
    self.iOffsetRight = integerOffset;
    [self ccRight:item];
}

- (void) ccLeft : (UIBarButtonItem *) item {
    UIBarButtonItem *itemBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                             target:nil
                                                                             action:nil];
    itemBar.width = self.iOffsetLeft;
    NSArray *array = [NSArray arrayWithObjects:itemBar,item, nil];
    [self setLeftBarButtonItems:array];
}
- (void) ccRight : (UIBarButtonItem *) item {
    UIBarButtonItem *itemBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                             target:nil
                                                                             action:nil];
    itemBar.width = self.iOffsetRight;
    NSArray *array = [NSArray arrayWithObjects:itemBar,item, nil];
    [self setLeftBarButtonItems:array];
}

- (void)setIOffsetLeft:(NSInteger)iOffsetLeft {
    objc_setAssociatedObject(self, @selector(iOffsetLeft), @(iOffsetLeft), OBJC_ASSOCIATION_ASSIGN);
}
- (NSInteger)iOffsetLeft {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setIOffsetRight:(NSInteger)iOffsetRight {
    objc_setAssociatedObject(self, @selector(iOffsetRight), @(iOffsetRight), OBJC_ASSOCIATION_ASSIGN);
}
- (NSInteger)iOffsetRight {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

@end
