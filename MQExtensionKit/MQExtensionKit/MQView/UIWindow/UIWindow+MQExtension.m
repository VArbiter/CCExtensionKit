//
//  UIWindow+MQExtension.m
//  MQExtension_Example
//
//  Created by ElwinFrederick on 2018/11/27.
//  Copyright © 2018 ElwinFrederick. All rights reserved.
//

#import "UIWindow+MQExtension.h"

@implementation UIWindow (MQExtension)

+ (instancetype) mq_current_window {
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *array_windows = [UIWindow mq_all_windows];
        for (UIWindow *t_window in array_windows) {
            if (t_window.windowLevel == UIWindowLevelNormal) {
                window = t_window;
                break;
            }
        }
    }
    return window;
}

+ (NSArray <__kindof UIWindow *> *) mq_all_windows {
    return [[UIApplication sharedApplication] windows];
}

@end

@implementation UIViewController (MQExtension_Window)

+ (instancetype) mq_windowed_current : (__kindof UIWindow *) window {
    id t = nil;
    UIView * view_front = [[window subviews] firstObject];
    t = [view_front nextResponder];
    if ([t isKindOfClass:[UIViewController class]])
        return [UIViewController mq_current_from:t];
    else return window.rootViewController;
}
+ (instancetype) mq_current {
    return [self mq_windowed_current:[UIWindow mq_current_window]];
}
+ (__kindof UIViewController *) mq_current_root {
    return UIApplication.sharedApplication.delegate.window.rootViewController;
}
+ (instancetype) mq_current_navigation {
    return [UIViewController mq_current].navigationController;
}
+ (instancetype) mq_current_from : (__kindof UIViewController *) controller {
    if ([controller isKindOfClass:UINavigationController.class]) {
        UINavigationController *t_nvc = (UINavigationController *)controller;
        return [self mq_current_from:t_nvc.viewControllers.lastObject];
    }
    else if([controller isKindOfClass:UITabBarController.class]) {
        UITabBarController *t_bvc = (UITabBarController *)controller;
        return [self mq_current_from:t_bvc.selectedViewController];
    }
    else if(controller.presentedViewController != nil) {
        return [self mq_current_from:controller.presentedViewController];
    }
    else return controller;
}

@end
