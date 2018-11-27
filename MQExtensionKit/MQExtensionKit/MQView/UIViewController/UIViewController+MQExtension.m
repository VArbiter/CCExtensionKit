//
//  UIViewController+MQExtension.m
//  MQExtensionKit
//
//  Created by 冯明庆 on 2017/4/5.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UIViewController+MQExtension.h"

#import "UIView+MQExtension.h"

#import <objc/runtime.h>

@implementation UIViewController (MQExtension) 

- (instancetype) mq_disable_animated {
    objc_setAssociatedObject(self, "_MQ_EXTENSION_CONTROLLER_DISABLE_ANIMATED_", @(false), OBJC_ASSOCIATION_ASSIGN);
    return self;
}
- (instancetype) mq_enable_animated {
    objc_setAssociatedObject(self, "_MQ_EXTENSION_CONTROLLER_DISABLE_ANIMATED_", @(YES), OBJC_ASSOCIATION_ASSIGN);
    return self;
}

- (void) mq_go_back {
    if (self.navigationController) [self mq_pop];
    else if (self.presentingViewController) [self mq_dismiss];
}
- (void) mq_dismiss {
    [self mq_dismiss:.0f];
}
- (void) mq_dismiss : (CGFloat) f_delay {
    [self mq_dismiss:f_delay complete:nil];
}
- (void) mq_dismiss : (CGFloat) f_delay
           complete : (void(^)(void)) complete {
    id o = objc_getAssociatedObject(self, "_MQ_EXTENSION_CONTROLLER_DISABLE_ANIMATED_");
    BOOL b = o ? [o boolValue] : YES;
    if (self.presentingViewController) {
        if (f_delay <= .0f) [self dismissViewControllerAnimated:b
                                                     completion:complete];
    }
    else [self mq_go_back];
}

- (void) mq_pop {
    if (self.navigationController) {
        id o = objc_getAssociatedObject(self, "_MQ_EXTENSION_CONTROLLER_DISABLE_ANIMATED_");
        BOOL b = o ? [o boolValue] : YES;
        [self.navigationController popViewControllerAnimated:b];
    }
    else [self mq_go_back];
}
- (void) mq_pop_to : (__kindof UIViewController *) controller {
    id o = objc_getAssociatedObject(self, "_MQ_EXTENSION_CONTROLLER_DISABLE_ANIMATED_");
    BOOL b = o ? [o boolValue] : YES;
    if (controller
        && [controller isKindOfClass:UIViewController.class]
        && [controller.navigationController.viewControllers containsObject:self]) {
        if (self.navigationController) [self.navigationController popToViewController:controller
                                                                             animated:b];
    }
    else [self mq_go_back];
}
- (void) mq_pop_to_root {
    id o = objc_getAssociatedObject(self, "_MQ_EXTENSION_CONTROLLER_DISABLE_ANIMATED_");
    BOOL b = o ? [o boolValue] : YES;
    if (self.navigationController) [self.navigationController popToRootViewControllerAnimated:b];
    else [self mq_go_back];
}

- (instancetype) mq_push : (__kindof UIViewController *) controller {
    if (!controller || ![controller isKindOfClass:UIViewController.class]) return self;
    if (self.navigationController) return [self mq_push:controller
                                            hide_bottom:YES];
    return [self mq_present:controller];
}
- (instancetype) mq_push : (__kindof UIViewController *) controller
             hide_bottom : (BOOL) is_hide {
    if (!controller || ![controller isKindOfClass:UIViewController.class]) return self;
    if (self.navigationController) {
        id o = objc_getAssociatedObject(self, "_MQ_EXTENSION_CONTROLLER_DISABLE_ANIMATED_");
        BOOL b = o ? [o boolValue] : YES;
        controller.hidesBottomBarWhenPushed = is_hide;
        [self.navigationController pushViewController:controller
                                              animated:b];
        return self;
    }
    return [self mq_present:controller];
}

- (instancetype) mq_present : (__kindof UIViewController *) controller {
    if (!controller || ![controller isKindOfClass:UIViewController.class]) return self;
    return [self mq_present:controller complete:nil];
}
- (instancetype) mq_present : (__kindof UIViewController *) controller
                   complete : (void (^)(void)) complete {
    if (!controller || ![controller isKindOfClass:UIViewController.class]) return self;
    id o = objc_getAssociatedObject(self, "_MQ_EXTENSION_CONTROLLER_DISABLE_ANIMATED_");
    BOOL b = o ? [o boolValue] : YES;
    // solve the delay problem .
    __weak typeof(self) pSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [pSelf presentViewController:controller
                            animated:b
                          completion:complete];
    });
    return self;
}
- (instancetype) mq_present_clear : (__kindof UIViewController *) controller
                         complete : (void (^)(void)) complete {
    if (!controller || ![controller isKindOfClass:UIViewController.class]) return self;
    controller.providesPresentationContextTransitionStyle = YES;
    controller.definesPresentationContext = YES;
    [controller setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    return [self mq_present:controller complete:complete];
}

- (instancetype) mq_add_view_from : (__kindof UIViewController *) controller
                         duration : (CGFloat) f_animation_duration {
    if (!controller || ![controller isKindOfClass:UIViewController.class]) return self;
    for (id item in self.view.subviews) {
        if (item == controller.view) return self;
    }
    id o = objc_getAssociatedObject(self, "_MQ_EXTENSION_CONTROLLER_DISABLE_ANIMATED_");
    BOOL b = o ? [o boolValue] : YES;
    if (b) {
        controller.view.alpha = .01f;
        [self.view addSubview:controller.view];
        [UIView animateWithDuration:(f_animation_duration > .0f ? f_animation_duration : mq_default_animation_common_duration) animations:^{
            controller.view.alpha = 1.f;
        }];
    }
    else [self.view addSubview:controller.view];
    [self addChildViewController:controller];
    return self;
}

+ (void) mq_cover_view_with : (__kindof UIViewController *) controller
                   animated : (BOOL) is_aminated
                   duration : (CGFloat) f_animation_duration {
    UIWindow *w = UIApplication.sharedApplication.delegate.window;
    if (!controller || ![controller isKindOfClass:UIViewController.class]) return ;
    for (id item in w.subviews) {
        if (item == controller.view) return ;
    }
    if (is_aminated) {
        controller.view.alpha = .01f;
        [w addSubview:controller.view];
        [UIView animateWithDuration:(f_animation_duration > .0f ? f_animation_duration : mq_default_animation_common_duration) animations:^{
            controller.view.alpha = 1.f;
        }];
    }
    else [w addSubview:controller.view];
}

- (instancetype) mq_enable_pushing_poping_style_when_present_or_dismiss {
    self.transitioningDelegate = self;
    return self;
}

// - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    MQAnimatedTransitionPresent *animate = MQAnimatedTransitionPresent.alloc.init;
    animate.interval_duration = .2f;
    return animate;
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    MQAnimatedTransitionDismiss *animate = MQAnimatedTransitionDismiss.alloc.init;
    animate.interval_duration = .2f;
    return animate;
}

static NSString * mq_controller_extension_animated_transition_key = @"mq_controller_extension_animated_transition_key";

- (CATransition *) mq_set_animated_transition : (NSString *) s_type
                              coming_position : (NSString *) s_position
                                     duration : (NSTimeInterval) interval {
    
    CATransition *animation = [CATransition animation];
    animation.duration = interval;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = s_type && s_type.length ? s_type : kCATransitionMoveIn;
    animation.subtype = s_position && s_position.length ? s_position : kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:animation
                                                forKey:mq_controller_extension_animated_transition_key];
    
    return animation;
}

- (void) mq_reset_animated_transition : (CATransition *) animation {
    [self.navigationController.view.layer removeAnimationForKey:mq_controller_extension_animated_transition_key];
}

@end

#pragma mark - -----

@interface MQAnimatedTransitionPresent () < CAAnimationDelegate >

@property (nonatomic , assign) id < UIViewControllerContextTransitioning > transition;

@end

@implementation MQAnimatedTransitionPresent

- (instancetype)init {
    if ((self = [super init])) {
        self.interval_duration = mq_default_animation_common_duration;
        self.s_animation_type = kCATransitionFromRight;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.interval_duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    self.transition = transitionContext;
    UIViewController * vc_from = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController * vc_to = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView * view_container = [transitionContext containerView];
    
    [view_container insertSubview:vc_to.view
                     aboveSubview:vc_from.view];
    
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionPush;
    transition.subtype = self.s_animation_type.length > 0 ? self.s_animation_type : kCATransitionFromRight;
    transition.duration = [self transitionDuration:transitionContext];
    transition.delegate = self;
    [vc_to.view.layer addAnimation:transition forKey:@"pushAnimation"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self.transition completeTransition:flag];
}

@end

#pragma mark - -----

@interface MQAnimatedTransitionDismiss () < CAAnimationDelegate >

@property (nonatomic , assign) id < UIViewControllerContextTransitioning > transition;

@end

@implementation MQAnimatedTransitionDismiss

- (instancetype)init {
    if ((self = [super init])) {
        self.interval_duration = mq_default_animation_common_duration;
        self.direction_right = YES;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.interval_duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    self.transition = transitionContext;
    UIViewController * vc_from = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController * vc_to = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView * view_container = [transitionContext containerView];
    
    [view_container insertSubview:vc_to.view
                    belowSubview:vc_from.view];
    
    __weak typeof(self) weak_self = self;
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        CGRect r = vc_from.view.frame;
        if (weak_self.is_direction_right) r.origin.x += r.size.width;
        else r.origin.x -= r.size.width;
        vc_from.view.frame = r;
    } completion:^(BOOL finished) {
        [weak_self.transition completeTransition:finished];
    }];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self.transition completeTransition:flag];
}

@end
