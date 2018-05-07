//
//  UIScrollView+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/1.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (CCExtension)

+ (instancetype) cc_common : (CGRect) frame ;

- (instancetype) cc_content_size : (CGSize) size ;
- (instancetype) cc_delegate : (id) delegate ;

/// animated is YES . // 启用 动画
- (instancetype) cc_animated_offset : (CGPoint) offSet ;
- (instancetype) cc_animated_offset : (CGPoint) offSet
                           animated : (BOOL) isAnimated ;

- (instancetype) cc_hide_vertical_indicator ;
- (instancetype) cc_hide_horizontal_indicator ;
- (instancetype) cc_disable_bounces ;
- (instancetype) cc_disable_scroll ;
- (instancetype) cc_disable_scrolls_to_top ;

- (instancetype) cc_enable_paging ;
- (instancetype) cc_enable_direction_lock ;

@property (nonatomic , assign) CGFloat content_width ;
@property (nonatomic , assign) CGFloat content_height ;

@property (nonatomic , assign) CGFloat offset_x ;
@property (nonatomic , assign) CGFloat offset_y ;

- (UIImage *) image_capture ;

@end
