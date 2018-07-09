//
//  MBProgressHUD+CCExtension.m
//  CCExtensionKit
//
//  Created by 冯明庆 on 2017/3/28.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "MBProgressHUD+CCExtension.h"

#if __has_include(<MBProgressHUD/MBProgressHUD.h>)

@implementation MBProgressHUD (CCExtension)

+ (instancetype) init {
    return [self init:nil];
}
+ (instancetype) init : (UIView *) view {
    if (!view) view = UIApplication.sharedApplication.delegate.window;
    if (!view) view = UIApplication.sharedApplication.keyWindow;
    return [MBProgressHUD showHUDAddedTo:view
                                animated:YES].cc_simple.cc_enable;
}

+ (instancetype) cc_generate {
    return [self cc_generate:nil];
}
+ (instancetype) cc_generate : (UIView *) view {
    if (!view) view = UIApplication.sharedApplication.delegate.window;
    if (!view) view = UIApplication.sharedApplication.keyWindow;
    return [MBProgressHUD init:view];
}

- (instancetype) cc_enable {
    self.userInteractionEnabled = false;
    return self;
}
- (instancetype) cc_disable {
    self.userInteractionEnabled = YES;
    return self;
}

+ (BOOL) cc_has_hud {
    return [self cc_has_hud:nil];
}
+ (BOOL) cc_has_hud : (UIView *) view {
    if (!view) view = UIApplication.sharedApplication.keyWindow;
    return !![MBProgressHUD HUDForView:view];
}

- (instancetype) cc_show {
    if (NSThread.isMainThread) [self showAnimated:YES];
    else dispatch_sync(dispatch_get_main_queue(), ^{
        [self showAnimated:YES];
    });
    return self;
}
- (void) cc_hide {
    [self cc_hide:2.f];
}
- (void) cc_hide : (NSTimeInterval) interval {
    self.removeFromSuperViewOnHide = YES;
    if (interval > .0f) {
        [self hideAnimated:YES
                afterDelay:interval];
    }
    else [self hideAnimated:YES];
}

- (instancetype) cc_indicator {
    self.mode = MBProgressHUDModeIndeterminate;
    return self;
}
- (instancetype) cc_simple {
    self.mode = MBProgressHUDModeText;
    return self;
}
- (instancetype) cc_title : (NSString *) sTitle {
    self.label.text = sTitle;
    return self;
}
- (instancetype) cc_message : (NSString *) sMessage {
    self.detailsLabel.text = sMessage;
    return self;
}
- (instancetype) cc_type : (CCHudExtensionType) type {
    __weak typeof(self) pSelf = self;
    NSDictionary *d = @{@(CCHudExtensionTypeLight).stringValue : ^{
                            pSelf.contentColor = UIColor.blackColor;
                        },
                        @(CCHudExtensionTypeDarkDeep).stringValue : ^{
                            pSelf.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
                            pSelf.contentColor = UIColor.whiteColor;
                            pSelf.bezelView.backgroundColor = UIColor.blackColor;
                        },
                        @(CCHudExtensionTypeDark).stringValue : ^{
                            pSelf.contentColor = UIColor.whiteColor;
                            pSelf.bezelView.backgroundColor = UIColor.blackColor;
                        },
                        @(CCHudExtensionTypeNone).stringValue : ^{
                            pSelf.contentColor = UIColor.blackColor;
                        }};
    if (!d[@(type).stringValue]) return self;
    void (^b)(void) = d[@(type).stringValue];
    if (b) b();
    return self;
}

- (instancetype) cc_delay : (CGFloat) fDelay {
    dispatch_time_t t = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(fDelay * NSEC_PER_SEC));
    __weak typeof(self) pSelf = self;
    dispatch_after(t, dispatch_get_main_queue(), ^{
        [pSelf cc_show];
    });
    return self;
}
- (instancetype) cc_grace : (NSTimeInterval) interval {
    self.graceTime = interval;
    return self;
}
- (instancetype) cc_min : (NSTimeInterval) interval {
    self.minShowTime = interval;
    return self;
}
- (instancetype) cc_complete : (void (^)(void)) complete {
    self.completionBlock = complete;
    return self;
}

@end

#pragma mark - -----

@implementation UIView (CCExtension_Hud)

- (__kindof MBProgressHUD *) cc_hud {
    return [UIView cc_hud:self];
}
+ (__kindof MBProgressHUD *) cc_hud : (UIView *) view {
    return [MBProgressHUD init:view];
}

@end

#endif
