//
//  UIScrollView+MQExtension.m
//  MQExtensionKit
//
//  Created by 冯明庆 on 2017/4/1.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UIScrollView+MQExtension.h"

@implementation UIScrollView (MQExtension)

+ (instancetype)mq_common:(CGRect)frame{
    UIScrollView *v = [[UIScrollView alloc] initWithFrame:frame];
    v.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    v.backgroundColor = UIColor.clearColor;
    return v;
}

- (instancetype) mq_content_size : (CGSize) size {
    self.contentSize = size;
    return self;
}
- (instancetype) mq_delegate : (id) delegate {
    self.delegate = delegate;
    return self;
}

/// animated is YES .
- (instancetype) mq_animated_offset : (CGPoint) offset {
    return [self mq_animated_offset:offset animated:YES];
}
- (instancetype) mq_animated_offset : (CGPoint) offset
                           animated : (BOOL) is_animated {
    [self setContentOffset:offset
                  animated:is_animated];
    return self;
}

- (instancetype) mq_hide_vertical_indicator {
    self.showsVerticalScrollIndicator = false;
    return self;
}
- (instancetype) mq_hide_horizontal_indicator {
    self.showsHorizontalScrollIndicator = false;
    return self;
}
- (instancetype) mq_disable_bounces {
    self.bounces = false;
    return self;
}
- (instancetype) mq_disable_scroll {
    self.scrollEnabled = false;
    return self;
}
- (instancetype) mq_disable_scrolls_to_top {
    self.scrollsToTop = false;
    return self;
}

- (instancetype) mq_enable_paging {
    self.pagingEnabled = YES;
    return self;
}
- (instancetype) mq_enable_direction_lock {
    self.directionalLockEnabled = YES;
    return self;
}

- (void)setContent_width:(CGFloat)content_width {
    self.contentSize = CGSizeMake(content_width, self.contentSize.height);
}
- (CGFloat)content_width {
    return self.contentSize.width;
}

- (void)setContent_height:(CGFloat)content_height {
    self.contentSize = CGSizeMake(self.contentSize.width, content_height);
}
- (CGFloat)content_height {
    return self.contentSize.height;
}

- (void)setOffset_x:(CGFloat)offset_x {
    self.contentOffset = CGPointMake(offset_x, self.contentOffset.y);
}
- (CGFloat)offset_x {
    return self.contentOffset.x;
}

- (void)setOffset_y:(CGFloat)offset_y {
    self.contentOffset = CGPointMake(self.contentOffset.x, offset_y);
}
- (CGFloat)offset_y {
    return self.contentOffset.y;
}

- (BOOL)is_reach_end {
    CGFloat f_h = self.frame.size.height;
    CGFloat f_y_offset = self.contentOffset.y;
    CGFloat f_distance_from_bottom = self.contentSize.height - f_y_offset;
    return f_distance_from_bottom < f_h ;
}

- (UIImage *) image_capture {
    CGFloat f_scale = [UIScreen mainScreen].scale;
    
    CGSize b_size = self.bounds.size;
    CGFloat b_width = b_size.width;
    CGFloat b_height = b_size.height;
    
    CGSize content_size = self.contentSize;
    CGFloat content_h = content_size.height;
    CGPoint p_offset = self.contentOffset;
    
    [self setContentOffset:CGPointMake(0, 0)];
    NSMutableArray *a_images = [NSMutableArray array];
    while (content_h > 0) {
        UIGraphicsBeginImageContextWithOptions(b_size, NO, 0.0);
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [a_images addObject:image];
        
        CGFloat offsetY = self.contentOffset.y;
        [self setContentOffset:CGPointMake(0, offsetY + b_height)];
        
        content_h -= b_height;
    }
    
    self.contentOffset = p_offset;
    
    CGSize imageSize = CGSizeMake(content_size.width * f_scale,
                                  content_size.height * f_scale);
    UIGraphicsBeginImageContext(imageSize);
    [a_images enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL *stop) {
        [image drawInRect:CGRectMake(0,
                                     f_scale * b_height * idx,
                                     f_scale * b_width,
                                     f_scale * b_height)];
    }];
    
    UIImage *image_f = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image_f;
}

@end
