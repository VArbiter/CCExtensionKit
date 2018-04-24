//
//  UIViewController+CCExtension.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/5.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UIViewController+CCExtension.h"

#import "UIView+CCExtension.h"

#import <objc/runtime.h>

@implementation UIViewController (CCExtension) 

- (instancetype) cc_disable_animated {
    objc_setAssociatedObject(self, "_CC_EXTENSION_CONTROLLER_DISABLE_ANIMATED_", @(false), OBJC_ASSOCIATION_ASSIGN);
    return self;
}
- (instancetype) cc_enable_animated {
    objc_setAssociatedObject(self, "_CC_EXTENSION_CONTROLLER_DISABLE_ANIMATED_", @(YES), OBJC_ASSOCIATION_ASSIGN);
    return self;
}

- (void) cc_go_back {
    if (self.navigationController) [self cc_pop];
    else if (self.presentingViewController) [self cc_dismiss];
}
- (void) cc_dismiss {
    [self cc_dismiss:.0f];
}
- (void) cc_dismiss : (CGFloat) fDelay {
    [self cc_dismiss:fDelay complete:nil];
}
- (void) cc_dismiss : (CGFloat) fDelay
           complete : (void(^)(void)) complete {
    id o = objc_getAssociatedObject(self, "_CC_EXTENSION_CONTROLLER_DISABLE_ANIMATED_");
    BOOL b = o ? [o boolValue] : YES;
    if (self.presentingViewController) {
        if (fDelay <= .0f) [self dismissViewControllerAnimated:b
                                                    completion:complete];
    }
    else [self cc_go_back];
}

- (void) cc_pop {
    if (self.navigationController) {
        id o = objc_getAssociatedObject(self, "_CC_EXTENSION_CONTROLLER_DISABLE_ANIMATED_");
        BOOL b = o ? [o boolValue] : YES;
        [self.navigationController popViewControllerAnimated:b];
    }
    else [self cc_go_back];
}
- (void) cc_pop_to : (__kindof UIViewController *) controller {
    id o = objc_getAssociatedObject(self, "_CC_EXTENSION_CONTROLLER_DISABLE_ANIMATED_");
    BOOL b = o ? [o boolValue] : YES;
    if (controller
        && [controller isKindOfClass:UIViewController.class]
        && [controller.navigationController.viewControllers containsObject:self]) {
        if (self.navigationController) [self.navigationController popToViewController:controller
                                                                             animated:b];
    }
    else [self cc_go_back];
}
- (void) cc_pop_to_root {
    id o = objc_getAssociatedObject(self, "_CC_EXTENSION_CONTROLLER_DISABLE_ANIMATED_");
    BOOL b = o ? [o boolValue] : YES;
    if (self.navigationController) [self.navigationController popToRootViewControllerAnimated:b];
    else [self cc_go_back];
}

- (instancetype) cc_push : (__kindof UIViewController *) controller {
    if (!controller || ![controller isKindOfClass:UIViewController.class]) return self;
    if (self.navigationController) return [self cc_push:controller
                                            hide_bottom:YES];
    return [self cc_present:controller];
}
- (instancetype) cc_push : (__kindof UIViewController *) controller
             hide_bottom : (BOOL) isHide {
    if (!controller || ![controller isKindOfClass:UIViewController.class]) return self;
    if (self.navigationController) {
        id o = objc_getAssociatedObject(self, "_CC_EXTENSION_CONTROLLER_DISABLE_ANIMATED_");
        BOOL b = o ? [o boolValue] : YES;
        controller.hidesBottomBarWhenPushed = isHide;
        [self.navigationController pushViewController:controller
                                              animated:b];
        return self;
    }
    return [self cc_present:controller];
}

- (instancetype) cc_present : (__kindof UIViewController *) controller {
    if (!controller || ![controller isKindOfClass:UIViewController.class]) return self;
    return [self cc_present:controller complete:nil];
}
- (instancetype) cc_present : (__kindof UIViewController *) controller
                   complete : (void (^)(void)) complete {
    if (!controller || ![controller isKindOfClass:UIViewController.class]) return self;
    id o = objc_getAssociatedObject(self, "_CC_EXTENSION_CONTROLLER_DISABLE_ANIMATED_");
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
- (instancetype) cc_present_clear : (__kindof UIViewController *) controller
                         complete : (void (^)(void)) complete {
    if (!controller || ![controller isKindOfClass:UIViewController.class]) return self;
    controller.providesPresentationContextTransitionStyle = YES;
    controller.definesPresentationContext = YES;
    [controller setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    return [self cc_present:controller complete:complete];
}

- (instancetype) cc_add_view_from : (__kindof UIViewController *) controller
                         duration : (CGFloat) fAnimationDuration {
    if (!controller || ![controller isKindOfClass:UIViewController.class]) return self;
    for (id item in self.view.subviews) {
        if (item == controller.view) return self;
    }
    id o = objc_getAssociatedObject(self, "_CC_EXTENSION_CONTROLLER_DISABLE_ANIMATED_");
    BOOL b = o ? [o boolValue] : YES;
    if (b) {
        controller.view.alpha = .01f;
        [self.view addSubview:controller.view];
        [UIView animateWithDuration:(fAnimationDuration > .0f ? fAnimationDuration : _CC_DEFAULT_ANIMATION_COMMON_DURATION_) animations:^{
            controller.view.alpha = 1.f;
        }];
    }
    else [self.view addSubview:controller.view];
    [self addChildViewController:controller];
    return self;
}

+ (void) cc_cover_view_with : (__kindof UIViewController *) controller
                   animated : (BOOL) isAminated
                   duration : (CGFloat) fAnimationDuration {
    UIWindow *w = UIApplication.sharedApplication.delegate.window;
    if (!controller || ![controller isKindOfClass:UIViewController.class]) return ;
    for (id item in w.subviews) {
        if (item == controller.view) return ;
    }
    if (isAminated) {
        controller.view.alpha = .01f;
        [w addSubview:controller.view];
        [UIView animateWithDuration:(fAnimationDuration > .0f ? fAnimationDuration : _CC_DEFAULT_ANIMATION_COMMON_DURATION_) animations:^{
            controller.view.alpha = 1.f;
        }];
    }
    else [w addSubview:controller.view];
}

+ (__kindof UIViewController *) cc_current {
    return [self cc_current_from:UIViewController.cc_current_root];
}
+ (__kindof UIViewController *) cc_current_root {
    return UIApplication.sharedApplication.delegate.window.rootViewController;
}
+ (__kindof UINavigationController *) cc_current_navigation {
    return self.cc_current.navigationController;
}
+ (__kindof UIViewController *) cc_current_from : (UIViewController *) controller {
    if ([controller isKindOfClass:UINavigationController.class]) {
        UINavigationController *nvc = (UINavigationController *)controller;
        return [self cc_current_from:nvc.viewControllers.lastObject];
    }
    else if([controller isKindOfClass:UITabBarController.class]) {
        UITabBarController *tbvc = (UITabBarController *)controller;
        return [self cc_current_from:tbvc.selectedViewController];
    }
    else if(controller.presentedViewController != nil) {
        return [self cc_current_from:controller.presentedViewController];
    }
    else return controller;
}
+ (UIViewController *)cc_windowed_current {
    id vc = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *arrayWindows = [[UIApplication sharedApplication] windows];
        for (UIWindow *tempWindow in arrayWindows) {
            if (tempWindow.windowLevel == UIWindowLevelNormal) {
                window = tempWindow;
                break;
            }
        }
    }
    UIView *viewFront = [[window subviews] firstObject];
    vc = [viewFront nextResponder];
    if ([vc isKindOfClass:[UIViewController class]])
        return [UIViewController cc_current_from:vc];
    else return window.rootViewController;
}

- (instancetype) cc_enable_pushing_poping_style_when_present_or_dismiss {
    self.transitioningDelegate = self;
    return self;
}

// - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    CCAnimatedTransitionPresent *animate = CCAnimatedTransitionPresent.alloc.init;
    animate.intervalDuration = .2f;
    return animate;
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    CCAnimatedTransitionDismiss *animate = CCAnimatedTransitionDismiss.alloc.init;
    animate.intervalDuration = .2f;
    return animate;
}

@end

#pragma mark - -----

@interface CCAnimatedTransitionPresent () < CAAnimationDelegate >

@property (nonatomic , assign) id < UIViewControllerContextTransitioning > transition;

@end

@implementation CCAnimatedTransitionPresent

- (instancetype)init {
    if ((self = [super init])) {
        self.intervalDuration = _CC_DEFAULT_ANIMATION_COMMON_DURATION_;
        self.s_animation_type = kCATransitionFromRight;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.intervalDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    self.transition = transitionContext;
    UIViewController * vcFrom = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController * vcTo = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView * viewContainer = [transitionContext containerView];
    
    [viewContainer insertSubview:vcTo.view
                    aboveSubview:vcFrom.view];
    
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionPush;
    transition.subtype = self.s_animation_type.length > 0 ? self.s_animation_type : kCATransitionFromRight;
    transition.duration = [self transitionDuration:transitionContext];
    transition.delegate = self;
    [vcTo.view.layer addAnimation:transition forKey:@"pushAnimation"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self.transition completeTransition:flag];
}

@end

#pragma mark - -----

@interface CCAnimatedTransitionDismiss () < CAAnimationDelegate >

@property (nonatomic , assign) id < UIViewControllerContextTransitioning > transition;

@end

@implementation CCAnimatedTransitionDismiss

- (instancetype)init {
    if ((self = [super init])) {
        self.intervalDuration = _CC_DEFAULT_ANIMATION_COMMON_DURATION_;
        self.directionRight = YES;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.intervalDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    self.transition = transitionContext;
    UIViewController * vcFrom = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController * vcTo = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView * viewContainer = [transitionContext containerView];
    
    [viewContainer insertSubview:vcTo.view
                    belowSubview:vcFrom.view];
    
    __weak typeof(self) pSelf = self;
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        CGRect r = vcFrom.view.frame;
        if (pSelf.isDirectionRight) r.origin.x += r.size.width;
        else r.origin.x -= r.size.width;
        vcFrom.view.frame = r;
    } completion:^(BOOL finished) {
        [pSelf.transition completeTransition:finished];
    }];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self.transition completeTransition:flag];
}

@end
