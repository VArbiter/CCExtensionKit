//
//  UIScrollView+CCExtension.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/1.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UIScrollView+CCExtension.h"

@implementation UIScrollView (CCExtension)

+ (instancetype)common:(CGRect)frame{
    UIScrollView *v = [[UIScrollView alloc] initWithFrame:frame];
    v.backgroundColor = UIColor.clearColor;
    return v;
}

- (instancetype) ccContentSize : (CGSize) size {
    self.contentSize = size;
    return self;
}
- (instancetype) ccDelegateT : (id) delegate {
    self.delegate = delegate;
    return self;
}

/// animated is YES .
- (instancetype) ccAnimatedOffset : (CGPoint) offSet {
    return [self ccAnimatedOffset:offSet animated:YES];
}
- (instancetype) ccAnimatedOffset : (CGPoint) offSet
                         animated : (BOOL) isAnimated {
    [self setContentOffset:offSet
                  animated:isAnimated];
    return self;
}

- (instancetype) hideVerticalIndicator {
    self.showsVerticalScrollIndicator = false;
    return self;
}
- (instancetype) hideHorizontalIndicator {
    self.showsHorizontalScrollIndicator = false;
    return self;
}
- (instancetype) disableBounces {
    self.bounces = false;
    return self;
}
- (instancetype) disableScroll {
    self.scrollEnabled = false;
    return self;
}
- (instancetype) disableScrollsToTop {
    self.scrollsToTop = false;
    return self;
}

- (instancetype) enablePaging {
    self.pagingEnabled = YES;
    return self;
}
- (instancetype) enableDirectionLock {
    self.directionalLockEnabled = YES;
    return self;
}

@end
