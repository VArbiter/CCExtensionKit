//
//  UIViewController+MQExtension.h
//  MQExtensionKit
//
//  Created by 冯明庆 on 2017/4/5.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (MQExtension) < UIViewControllerTransitioningDelegate >

/// remove all animated for pushing && presenting . // 移除所有的 push 和 presenting 动画
- (instancetype) mq_disable_animated ;
- (instancetype) mq_enable_animated ;

/// first detect if nagvigation pop back enable , // 首先检测 导航栏的 pop 是否起效
/// then detect if dismiss enable . // 然后检测 dismiss 是否奇效
/// respose the first findout . // 调用第一个找到的

- (void) mq_go_back ;
- (void) mq_dismiss ;
- (void) mq_dismiss : (CGFloat) fDelay ;
- (void) mq_dismiss : (CGFloat) fDelay
           complete : (void(^)(void)) complete ;

- (void) mq_pop ;
- (void) mq_pop_to : (__kindof UIViewController *) controller ;
- (void) mq_pop_to_root ;

/// default enable animated && Hide bottom bar // 默认启用动画和隐藏底部栏
- (instancetype) mq_push : (__kindof UIViewController *) controller ;
- (instancetype) mq_push : (__kindof UIViewController *) controller
                hide_bottom : (BOOL) isHide ;

- (instancetype) mq_present : (__kindof UIViewController *) controller ;
- (instancetype) mq_present : (__kindof UIViewController *) controller
                   complete : (void (^)(void)) complete ;
/// clear color == backgroundColor // 背景色为透明色
- (instancetype) mq_present_clear : (__kindof UIViewController *) controller
                         complete : (void (^)(void)) complete;

/// deafult enable animated , fade in , fade out . // 默认渐变进入 , 渐变出
- (instancetype) mq_add_view_from : (__kindof UIViewController *) controller
                         duration : (CGFloat) fAnimationDuration ;

/// note : [UIApplication sharedApplication].delegate.window is the super view // 父视图为 [UIApplication sharedApplication].delegate.window
+ (void) mq_cover_view_with : (__kindof UIViewController *) controller
                   animated : (BOOL) isAminated
                   duration : (CGFloat) fAnimationDuration ;

/// current controller that shows on screen . (only the main window) // 当前 main window 上所显示的控制器
+ (__kindof UIViewController *) mq_current ;
+ (__kindof UIViewController *) mq_current_root ;
+ (__kindof UINavigationController *) mq_current_navigation;
+ (__kindof UIViewController *) mq_current_from : (UIViewController *) controller ;

/// when have muti windows . // 如果有多个 window 的话 .
+ (__kindof UIViewController *) mq_windowed_current ;

/// make present modeled push / dismiss modeled pop // 使得 模态动画像是 导航栏的 push / pop
/// only works in present . // 只针对 模态有效
/// note : invoke it in the controller is about to presented . not the presenting one . // 在将要被模态出的控制器使用 , 不是当前的控制器
- (instancetype) mq_enable_pushing_poping_style_when_present_or_dismiss ;

/// a simple animation for navigation controller when pushed . // 简单的 push 动画
- (CATransition *) mq_set_animated_transition : (NSString *) s_type
                              coming_position : (NSString *) s_position
                                     duration : (NSTimeInterval) interval ;

/// remove the animation you used with "[UIViewController mq_set_animated_transition:coming_position:duration:]"
/// 去除你在 "[UIViewController mq_set_animated_transition:coming_position:duration:]" 使用的动画 
- (void) mq_reset_animated_transition : (CATransition *) animation ;

@end

#pragma mark - -----

@interface MQAnimatedTransitionPresent : NSObject < UIViewControllerAnimatedTransitioning >

@property (nonatomic , assign) NSTimeInterval intervalDuration ;
@property (nonatomic , copy) NSString * s_animation_type; // default kCATransitionFromRight // 默认 kCATransitionFromRight

@end

#pragma mark - -----

@interface MQAnimatedTransitionDismiss : NSObject < UIViewControllerAnimatedTransitioning >

@property (nonatomic , assign) NSTimeInterval intervalDuration ;
@property (nonatomic , assign , getter=isDirectionRight) BOOL directionRight; // default YES // 默认为 YES

@end
