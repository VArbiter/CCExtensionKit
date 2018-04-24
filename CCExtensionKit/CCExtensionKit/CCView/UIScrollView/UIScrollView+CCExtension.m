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

- (instancetype) cc_content_size : (CGSize) size {
    self.contentSize = size;
    return self;
}
- (instancetype) cc_delegate : (id) delegate {
    self.delegate = delegate;
    return self;
}

/// animated is YES .
- (instancetype) cc_animated_offset : (CGPoint) offSet {
    return [self cc_animated_offset:offSet animated:YES];
}
- (instancetype) cc_animated_offset : (CGPoint) offSet
                           animated : (BOOL) isAnimated {
    [self setContentOffset:offSet
                  animated:isAnimated];
    return self;
}

- (instancetype) cc_hide_vertical_indicator {
    self.showsVerticalScrollIndicator = false;
    return self;
}
- (instancetype) cc_hide_horizontal_indicator {
    self.showsHorizontalScrollIndicator = false;
    return self;
}
- (instancetype) cc_disable_bounces {
    self.bounces = false;
    return self;
}
- (instancetype) cc_disable_scroll {
    self.scrollEnabled = false;
    return self;
}
- (instancetype) cc_disable_scrolls_to_top {
    self.scrollsToTop = false;
    return self;
}

- (instancetype) cc_enable_paging {
    self.pagingEnabled = YES;
    return self;
}
- (instancetype) cc_enable_direction_lock {
    self.directionalLockEnabled = YES;
    return self;
}

@end
