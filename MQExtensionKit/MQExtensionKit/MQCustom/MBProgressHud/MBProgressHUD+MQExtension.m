//
//  MBProgressHUD+MQExtension.m
//  MQExtensionKit
//
//  Created by 冯明庆 on 2017/3/28.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "MBProgressHUD+MQExtension.h"

#if __has_include(<MBProgressHUD/MBProgressHUD.h>)

@implementation MBProgressHUD (MQExtension)
    
static NSTimeInterval __mq_mb_progress_hud_auto_hide_time_interval = 2.f;
+ (void) mq_set_default_hide_time : (NSTimeInterval) interval {
    if (interval < 0) __mq_mb_progress_hud_auto_hide_time_interval = 2.f;
    else __mq_mb_progress_hud_auto_hide_time_interval = interval;
}

- (instancetype) mq_responsd_user_interact {
    self.userInteractionEnabled = false;
    return self;
}
- (instancetype) mq_block_user_interact {
    self.userInteractionEnabled = YES;
    return self;
}

+ (BOOL) mq_has_hud {
    return [self mq_has_hud:nil];
}
+ (BOOL) mq_has_hud : (UIView *) view {
    if (!view) view = UIApplication.sharedApplication.keyWindow;
    return !![MBProgressHUD HUDForView:view];
}
    
#pragma mark - -----
+ (instancetype) mq_simple_title : (NSString *) s_title {
    return [self mq_simple:MQHudExtensionType_Light
                  for_view:nil
                with_title:s_title
                   message:nil];
}
+ (instancetype) mq_simple_message : (NSString *) s_message {
    return [self mq_simple:MQHudExtensionType_Light
                  for_view:nil
                with_title:nil
                   message:s_message];
}
+ (instancetype) mq_simple : (MQHudExtensionType) type
                with_title : (NSString *) s_title
                   message : (NSString *) s_message {
    return [self mq_simple:type
                  for_view:nil
                with_title:s_title
                   message:s_message];
}
+ (instancetype) mq_simple : (MQHudExtensionType) type
                  for_view : (__kindof UIView *) view
                with_title : (NSString *) s_title {
    return [self mq_simple:type
                  for_view:view
                with_title:s_title
                   message:nil];
}
+ (instancetype) mq_indicator : (MQHudExtensionType) type
                     for_view : (__kindof UIView *) view
                 with_message : (NSString *) s_message {
    return [self mq_simple:type
                  for_view:view
                with_title:nil
                   message:s_message];
}
+ (instancetype) mq_simple : (MQHudExtensionType) type
                  for_view : (__kindof UIView *) view
                with_title : (NSString *) s_title
                   message : (NSString *) s_message {
    if (!view) view = UIApplication.sharedApplication.delegate.window;
    if (!view) view = UIApplication.sharedApplication.keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view
                                              animated:YES];
    hud.mode = MBProgressHUDModeText;
    [self mq_configure_type:hud type:type];
    [hud mq_responsd_user_interact];
    if (s_title) hud.label.text = s_title;
    if (s_message) hud.detailsLabel.text = s_message;
    return hud;
}
    
/// generate an indicator . //  创建指示器
+ (instancetype) mq_indicator {
    return [self mq_indicator:MQHudExtensionType_Light];
}
+ (instancetype) mq_indicator : (MQHudExtensionType) type {
    return [self mq_indicator:type for_view:nil];
}
+ (instancetype) mq_indicator : (MQHudExtensionType) type
                     for_view : (__kindof UIView *) view {
    return [self mq_indicator:type for_view:view with_title:nil];
}
+ (instancetype) mq_indicator : (MQHudExtensionType) type
                     for_view : (__kindof UIView *) view
                   with_title : (NSString *) s_title {
    return [self mq_indicator:type for_view:view with_title:s_title message:nil];
}
+ (instancetype) mq_indicator : (MQHudExtensionType) type
                     for_view : (__kindof UIView *) view
                   with_title : (NSString *) s_title
                      message : (NSString *) s_message {
    if (!view) view = UIApplication.sharedApplication.delegate.window;
    if (!view) view = UIApplication.sharedApplication.keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view
                                              animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    [self mq_configure_type:hud type:type];
    [hud mq_responsd_user_interact];
    if (s_title) hud.label.text = s_title;
    if (s_message) hud.detailsLabel.text = s_message;
    return hud;
}
    
- (instancetype) mq_set_title : (NSString *) s_title {
    self.label.text = s_title;
    return self;
}
- (instancetype) mq_set_message : (NSString *) s_message {
    self.detailsLabel.text = s_message;
    return self;
}
    
- (instancetype) mq_show : (BOOL) is_animated {
    if (NSThread.isMainThread) [self showAnimated:is_animated];
    else dispatch_sync(dispatch_get_main_queue(), ^{
        [self showAnimated:is_animated];
    });
    return self;
}
- (void) mq_hide : (BOOL) is_animated {
    [self mq_hide:is_animated
            after:__mq_mb_progress_hud_auto_hide_time_interval];
}
- (void) mq_hide : (BOOL) is_animated
           after : (NSTimeInterval) interval {
    
    __weak typeof(self) weak_self = self;
    void (^cc_main_thread_block)(void) = ^{
        __strong typeof(weak_self) strong_self = weak_self;
        strong_self.removeFromSuperViewOnHide = YES;
        if (interval > .0f) {
            [strong_self hideAnimated:is_animated
                           afterDelay:interval];
        }
        else [strong_self hideAnimated:is_animated];
    };
    
    if (NSThread.isMainThread) {
        if (cc_main_thread_block) cc_main_thread_block();
    }
    else dispatch_async(dispatch_get_main_queue(), ^{
        if (cc_main_thread_block) cc_main_thread_block();
    });
}
    
- (instancetype) mq_delay : (CGFloat) f_delay {
    dispatch_time_t t = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(f_delay * NSEC_PER_SEC));
    __weak typeof(self) weak_self = self;
    dispatch_after(t, dispatch_get_main_queue(), ^{
        __strong typeof(weak_self) strong_self = weak_self;
        [strong_self mq_show:YES];
    });
    return self;
}
    
+ (void) mq_configure_type : (MBProgressHUD *) hud
                      type : (MQHudExtensionType) type {
    switch (type) {
        case MQHudExtensionType_None:{
            hud.contentColor = UIColor.blackColor;
        }break;
        case MQHudExtensionType_Light:{
            hud.contentColor = UIColor.blackColor;
        }break;
        case MQHudExtensionType_DarkDeep:{
            hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
            hud.contentColor = UIColor.whiteColor;
            hud.bezelView.backgroundColor = UIColor.blackColor;
        }break;
        case MQHudExtensionType_Dark:{
            hud.contentColor = UIColor.whiteColor;
            hud.bezelView.backgroundColor = UIColor.blackColor;
        }break;
        
        default:{
            hud.contentColor = UIColor.blackColor;
        }break;
    }
}

@end

#pragma mark - -----

@implementation UIView (MQExtension_Hud)

- (__kindof MBProgressHUD *) mq_hud {
    return [UIView mq_hud:self];
}
+ (__kindof MBProgressHUD *) mq_hud : (UIView *) view {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    [hud mq_responsd_user_interact];
    return hud;
}
    
- (BOOL) mq_is_has_mb_progress_hud {
    return [MBProgressHUD mq_has_hud:self];
}

@end

#endif
