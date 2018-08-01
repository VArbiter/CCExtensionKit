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

+ (instancetype) init {
    return [self init:nil];
}
+ (instancetype) init : (UIView *) view {
    if (!view) view = UIApplication.sharedApplication.delegate.window;
    if (!view) view = UIApplication.sharedApplication.keyWindow;
    return [MBProgressHUD showHUDAddedTo:view
                                animated:YES].mq_simple.mq_responsd_user_interact;
}

+ (instancetype) mq_generate {
    return [self mq_generate:nil];
}
+ (instancetype) mq_generate : (UIView *) view {
    if (!view) view = UIApplication.sharedApplication.delegate.window;
    if (!view) view = UIApplication.sharedApplication.keyWindow;
    return [MBProgressHUD init:view];
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

- (instancetype) mq_show {
    if (NSThread.isMainThread) [self showAnimated:YES];
    else dispatch_sync(dispatch_get_main_queue(), ^{
        [self showAnimated:YES];
    });
    return self;
}
- (void) mq_hide {
    [self mq_hide:2.f];
}
- (void) mq_hide : (NSTimeInterval) interval {
    self.removeFromSuperViewOnHide = YES;
    if (interval > .0f) {
        [self hideAnimated:YES
                afterDelay:interval];
    }
    else [self hideAnimated:YES];
}

- (instancetype) mq_indicator {
    self.mode = MBProgressHUDModeIndeterminate;
    return self;
}
- (instancetype) mq_simple {
    self.mode = MBProgressHUDModeText;
    return self;
}
- (instancetype) mq_title : (NSString *) s_title {
    self.label.text = s_title;
    return self;
}
- (instancetype) mq_message : (NSString *) s_message {
    self.detailsLabel.text = s_message;
    return self;
}
- (instancetype) mq_type : (MQHudExtensionType) type {
    __weak typeof(self) pSelf = self;
    NSDictionary *d = @{@(MQHudExtensionTypeLight).stringValue : ^{
                            pSelf.contentColor = UIColor.blackColor;
                        },
                        @(MQHudExtensionTypeDarkDeep).stringValue : ^{
                            pSelf.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
                            pSelf.contentColor = UIColor.whiteColor;
                            pSelf.bezelView.backgroundColor = UIColor.blackColor;
                        },
                        @(MQHudExtensionTypeDark).stringValue : ^{
                            pSelf.contentColor = UIColor.whiteColor;
                            pSelf.bezelView.backgroundColor = UIColor.blackColor;
                        },
                        @(MQHudExtensionTypeNone).stringValue : ^{
                            pSelf.contentColor = UIColor.blackColor;
                        }};
    if (!d[@(type).stringValue]) return self;
    void (^b)(void) = d[@(type).stringValue];
    if (b) b();
    return self;
}

- (instancetype) mq_delay : (CGFloat) f_delay {
    dispatch_time_t t = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(f_delay * NSEC_PER_SEC));
    __weak typeof(self) weak_self = self;
    dispatch_after(t, dispatch_get_main_queue(), ^{
        __strong typeof(weak_self) strong_self = weak_self;
        [strong_self mq_show];
    });
    return self;
}
- (instancetype) mq_grace : (NSTimeInterval) interval {
    self.graceTime = interval;
    return self;
}
- (instancetype) mq_min : (NSTimeInterval) interval {
    self.minShowTime = interval;
    return self;
}
- (instancetype) mq_complete : (void (^)(void)) complete {
    self.completionBlock = complete;
    return self;
}

@end

#pragma mark - -----

@implementation UIView (MQExtension_Hud)

- (__kindof MBProgressHUD *) mq_hud {
    return [UIView mq_hud:self];
}
+ (__kindof MBProgressHUD *) mq_hud : (UIView *) view {
    return [MBProgressHUD init:view];
}

@end

#endif
