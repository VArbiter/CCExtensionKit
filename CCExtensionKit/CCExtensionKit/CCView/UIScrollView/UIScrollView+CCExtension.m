//
//  UIScrollView+CCExtension.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/1.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UIScrollView+CCExtension.h"

@implementation UIScrollView (CCExtension)

+ (instancetype) ccCommon : (CGRect) rectFrame {
    return [self ccCommon:rectFrame
                  content:rectFrame.size];
}
+ (instancetype) ccCommon : (CGRect) rectFrame
                      content : (CGSize) sizeContent{
    return [self ccCommon:rectFrame
                  content:sizeContent
                 delegate:nil];
}
+ (instancetype) ccCommon : (CGRect) rectFrame
                  content : (CGSize) sizeContent
                 delegate : (id) delegate {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:rectFrame];
    scrollView.contentSize = sizeContent;
    if (delegate) {
        scrollView.delegate = delegate;
    }
    scrollView.showsVerticalScrollIndicator = false;
    scrollView.showsHorizontalScrollIndicator = false;
    scrollView.bounces = false;
    scrollView.pagingEnabled = YES;
    scrollView.directionalLockEnabled = YES;
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.scrollEnabled = YES;
    return scrollView;
}

@end
