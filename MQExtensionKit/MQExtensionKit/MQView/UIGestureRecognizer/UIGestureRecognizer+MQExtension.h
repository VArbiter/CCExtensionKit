//
//  UIGestureRecognizer+MQExtension.h
//  MQExtensionKit
//
//  Created by Elwinfrederick on 06/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIGestureRecognizer (MQExtension)

+ (instancetype) mq_common ;

- (instancetype) mq_action : (void(^)( __kindof UIGestureRecognizer *gr)) action ;
- (instancetype) mq_target : (id) target
                    action : (void(^)( __kindof UIGestureRecognizer *gr)) action ;

@end

#pragma mark - -----

@interface UITapGestureRecognizer (MQExtension)

/// default 1 tap // 默认点击 1 次
- (instancetype) mq_tap : (void(^)(UITapGestureRecognizer *tapGR)) action ;
- (instancetype) mq_tap : (NSInteger) iCount
                 action : (void(^)(UITapGestureRecognizer *tapGR)) action ;

@end

#pragma mark - -----

@interface UILongPressGestureRecognizer (MQExtension)

/// default .5f seconds // 默认 0.5 秒
- (instancetype) mq_press : (void(^)(UILongPressGestureRecognizer *pressGR)) action ;
- (instancetype) mq_press : (CGFloat) fSeconds
                   action : (void(^)(UILongPressGestureRecognizer *pressGR)) action ;

@end

#pragma mark - -----

@interface UIView (MQExtension_Gesture_Actions)

/// for gesture actions // 添加手势动作
- (instancetype) mq_gesture : (__kindof UIGestureRecognizer *) gesture ;
- (instancetype) mq_tap : (void(^)( __kindof UIView *v , __kindof UITapGestureRecognizer *gr)) action ;
- (instancetype) mq_tap : (NSInteger) iCount
                 action : (void(^)( __kindof UIView *v , __kindof UITapGestureRecognizer *gr)) action ;
- (instancetype) mq_press : (void(^)(__kindof UIView *v , __kindof UILongPressGestureRecognizer *gr)) action ;
- (instancetype) mq_press : (CGFloat) fSeconds
                   action : (void(^)(__kindof UIView *v , __kindof UILongPressGestureRecognizer *gr)) action ;

@end

#pragma mark - -----

@interface UIViewController (MQExtension_Gesture_Actions)

/// make modaled controller can trigger pop action like UINavigationController. // 使得 模态出的控制器可以像导航控制器那样 pop
/// highly recommend use it with [instance mq_enable_pushing_poping_style_when_present_or_dismiss] . // 建议和 "[instance mq_enable_pushing_poping_style_when_present_or_dismiss]" 一起使用
- (instancetype) mq_modal_pop_gesture : (void(^)(__kindof UIViewController *sender ,
                                                 __kindof UIScreenEdgePanGestureRecognizer *edgePanGR)) bEdgePanGR ;

@end
