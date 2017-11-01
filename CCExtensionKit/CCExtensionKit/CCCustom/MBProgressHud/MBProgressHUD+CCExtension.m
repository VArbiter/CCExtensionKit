//
//  MBProgressHUD+CCExtension.m
//  CCLocalLibrary
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
                                animated:YES].ccSimple.ccEnable;
}

+ (instancetype) ccGenerate {
    return [self ccGenerate:nil];
}
+ (instancetype) ccGenerate : (UIView *) view {
    if (!view) view = UIApplication.sharedApplication.delegate.window;
    if (!view) view = UIApplication.sharedApplication.keyWindow;
    return [MBProgressHUD init:view];
}

- (instancetype) ccEnable {
    self.userInteractionEnabled = false;
    return self;
}
- (instancetype) ccDisable {
    self.userInteractionEnabled = YES;
    return self;
}

+ (BOOL) ccHasHud {
    return [self ccHasHud:nil];
}
+ (BOOL) ccHasHud : (UIView *) view {
    if (!view) view = UIApplication.sharedApplication.keyWindow;
    return !![MBProgressHUD HUDForView:view];
}

- (instancetype) ccShow {
    if (NSThread.isMainThread) [self showAnimated:YES];
    else dispatch_sync(dispatch_get_main_queue(), ^{
        [self showAnimated:YES];
    });
    return self;
}
- (void) ccHide {
    [self ccHide:2.f];
}
- (void) ccHide : (NSTimeInterval) interval {
    self.removeFromSuperViewOnHide = YES;
    if (interval > .0f) {
        [self hideAnimated:YES
                afterDelay:interval];
    }
    else [self hideAnimated:YES];
}

- (instancetype) ccIndicator {
    self.mode = MBProgressHUDModeIndeterminate;
    return self;
}
- (instancetype) ccSimple {
    self.mode = MBProgressHUDModeText;
    return self;
}
- (instancetype) ccTitle : (NSString *) sTitle {
    self.label.text = sTitle;
    return self;
}
- (instancetype) ccMessage : (NSString *) sMessage {
    self.detailsLabel.text = sMessage;
    return self;
}
- (instancetype) ccType : (CCHudExtensionType) type {
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
    void (^b)() = d[@(type).stringValue];
    if (b) b();
    return self;
}

- (instancetype) ccDelay : (CGFloat) fDelay {
    dispatch_time_t t = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(fDelay * NSEC_PER_SEC));
    __weak typeof(self) pSelf = self;
    dispatch_after(t, dispatch_get_main_queue(), ^{
        [pSelf ccShow];
    });
    return self;
}
- (instancetype) ccGrace : (NSTimeInterval) interval {
    self.graceTime = interval;
    return self;
}
- (instancetype) ccMin : (NSTimeInterval) interval {
    self.minShowTime = interval;
    return self;
}
- (instancetype) ccComplete : (void (^)(void)) complete {
    self.completionBlock = complete;
    return self;
}

@end

#pragma mark - -----

@implementation UIView (CCExtension_Hud)

- (__kindof MBProgressHUD *) ccHud {
    return [UIView ccHud:self];
}
+ (__kindof MBProgressHUD *) ccHud : (UIView *) view {
    return [MBProgressHUD init:view];
}

@end

#endif
