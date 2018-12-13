//
//  UIScrollView+MQExtension.h
//  MQExtensionKit
//
//  Created by 冯明庆 on 2017/4/1.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (MQExtension)

+ (instancetype) mq_common : (CGRect) frame ;

- (instancetype) mq_content_size : (CGSize) size ;
- (instancetype) mq_delegate : (id) delegate ;

/// animated is YES . // 启用 动画
- (instancetype) mq_animated_offset : (CGPoint) offset ;
- (instancetype) mq_animated_offset : (CGPoint) offset
                           animated : (BOOL) is_animated ;

- (instancetype) mq_hide_vertical_indicator ;
- (instancetype) mq_hide_horizontal_indicator ;
- (instancetype) mq_disable_bounces ;
- (instancetype) mq_disable_scroll ;
- (instancetype) mq_disable_scrolls_to_top ;

- (instancetype) mq_enable_paging ;
- (instancetype) mq_enable_direction_lock ;

@property (nonatomic , assign) CGFloat content_width ;
@property (nonatomic , assign) CGFloat content_height ;

@property (nonatomic , assign) CGFloat offset_x ;
@property (nonatomic , assign) CGFloat offset_y ;

/// monitor that whether if scrollview reach the end . // 监听是否滚动到底部
@property (nonatomic , readonly) BOOL is_reach_end ;

- (UIImage *) image_capture ;

@end
