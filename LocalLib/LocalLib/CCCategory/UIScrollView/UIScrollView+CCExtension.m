//
//  UIScrollView+CCExtension.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/1.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UIScrollView+CCExtension.h"

@implementation UIScrollView (CCExtension)

+ (instancetype) ccInitWithFrame : (CGRect) rectFrame {
    return [self ccInitWithFrame:rectFrame
                 withContentSize:rectFrame.size];
}
+ (instancetype) ccInitWithFrame : (CGRect) rectFrame
                 withContentSize : (CGSize) sizeContent{
    return [self ccInitWithFrame:rectFrame
                 withContentSize:sizeContent
                    withDelegate:nil];
}
+ (instancetype) ccInitWithFrame : (CGRect) rectFrame
                 withContentSize : (CGSize) sizeContent
                    withDelegate : (id) delegate {
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
