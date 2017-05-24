//
//  MBProgressHUD+YMExtension.m
//  ym_sell_ios
//
//  Created by 冯明庆 on 2017/3/28.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "MBProgressHUD+YMExtension.h"
#import "YMCommonDefine.h"

@implementation MBProgressHUD (YMExtension)

+ (void) ymHideAllHud {
    [self ymHideAllHud:nil];
}
+ (void) ymHideAllHud : (dispatch_block_t) blockComplete{
    [self ymHideAllHud:[UIApplication sharedApplication].delegate.window
          withComplete:blockComplete];
}

+ (void) ymHideAllHud : (UIView *) view
         withComplete : (dispatch_block_t) blockComplete {
    for (id object in view.subviews) {
        if ([object isKindOfClass:[MBProgressHUD class]]) {
            [self ymHideSingleHud];
        }
    }
    if (blockComplete) {
        blockComplete();
    }
}

+ (void) ymHideSingleHud {
    [self ymHideSingleHud:[UIApplication sharedApplication].delegate.window];
}

+ (void) ymHideSingleHud : (UIView *) view {
    if ([NSThread isMainThread])
        [MBProgressHUD hideHUDForView:view
                             animated:YES];
    else
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:view
                                 animated:YES];
        });
}

+ (BOOL) ymIsCurrentHasHud {
    return [self ymIsCurrentHasHud:[UIApplication sharedApplication].delegate.window];
}

+ (BOOL) ymIsCurrentHasHud : (UIView *) view {
    for (id obj in view.subviews) {
        if ([obj isKindOfClass:[self class]]) {
            return YES;
        }
    }
    return false;
}

+ (MBProgressHUD *) ymShowMessage : (NSString *) stringMessage {
    return [self ymShowTitle:nil
                 withMessage:stringMessage
          withHideAfterDelay:_YM_ALERT_DISMISS_INTERVAL_];
}
+ (MBProgressHUD *) ymShowMessage : (NSString *) stringMessage
                         withView : (UIView *) view {
    return [self ymShowTitle:nil
                 withMessage:stringMessage
          withHideAfterDelay:_YM_ALERT_DISMISS_INTERVAL_
           withCompleteBlock:nil
               withAlertType:YMWeakAlertTypeDark
                    withView:view];
}

+ (MBProgressHUD *) ymShowTitle : (NSString *) stringTitle
                    withMessage : (NSString *) stringMessage
             withHideAfterDelay : (CGFloat) floatDelay {
    return [self ymShowTitle:stringTitle
                 withMessage:stringMessage
          withHideAfterDelay:floatDelay
           withCompleteBlock:nil
               withAlertType:YMWeakAlertTypeDark];
}

+ (MBProgressHUD *) ymShowTitle : (NSString *) stringTitle
                    withMessage : (NSString *) stringMessage
              withCompleteBlock : (dispatch_block_t) block {
    return [self ymShowTitle:stringTitle
                 withMessage:stringMessage
          withHideAfterDelay:_YM_ALERT_DISMISS_INTERVAL_
           withCompleteBlock:block
               withAlertType:YMWeakAlertTypeDark];
}

+ (MBProgressHUD *) ymShowTitle : (NSString *) stringTitle
                    withMessage : (NSString *) stringMessage
             withHideAfterDelay : (CGFloat) floatDelay
              withCompleteBlock : (dispatch_block_t) block {
    return [self ymShowTitle : stringTitle
                 withMessage : stringMessage
          withHideAfterDelay : floatDelay
           withCompleteBlock : block
               withAlertType : YMWeakAlertTypeDark];
}

#pragma mark - With Type
+ (MBProgressHUD *) ymShowMessage : (NSString *) stringMessage
                    withAlertType : (YMWeakAlertType) type {
    return [self ymShowTitle:nil
                 withMessage:stringMessage
          withHideAfterDelay:_YM_ALERT_DISMISS_INTERVAL_
               withAlertType:type];
}
+ (MBProgressHUD *) ymShowTitle : (NSString *) stringTitle
                    withMessage : (NSString *) stringMessage
             withHideAfterDelay : (CGFloat) floatDelay
                  withAlertType : (YMWeakAlertType) type {
    return [self ymShowTitle:stringTitle
                 withMessage:stringMessage
          withHideAfterDelay:floatDelay
           withCompleteBlock:nil
               withAlertType:type];
}
+ (MBProgressHUD *) ymShowTitle : (NSString *) stringTitle
                    withMessage : (NSString *) stringMessage
              withCompleteBlock : (dispatch_block_t) block
                  withAlertType : (YMWeakAlertType) type{
    return [self ymShowTitle:stringTitle
                 withMessage:stringMessage
          withHideAfterDelay:_YM_ALERT_DISMISS_INTERVAL_
           withCompleteBlock:block
               withAlertType:type];
}
+ (MBProgressHUD *) ymShowTitle : (NSString *) stringTitle
                    withMessage : (NSString *) stringMessage
             withHideAfterDelay : (CGFloat) floatDelay
              withCompleteBlock : (dispatch_block_t) block
                  withAlertType : (YMWeakAlertType) type {
    MBProgressHUD *progressHud = [self ymDefaultSettingsWithAlertType:type];
    progressHud.label.text = stringTitle;
    progressHud.detailsLabel.text = stringMessage;
    
    if (floatDelay > 0) {
        [progressHud hideAnimated:YES
                       afterDelay:floatDelay];
    }
    if (block) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((floatDelay + .1f) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self ymHideAllHud];
        });
    }
    return progressHud;
}
+ (MBProgressHUD *) ymShowTitle : (NSString *) stringTitle
                    withMessage : (NSString *) stringMessage
             withHideAfterDelay : (CGFloat) floatDelay
              withCompleteBlock : (dispatch_block_t) block
                  withAlertType : (YMWeakAlertType) type
                       withView : (UIView *) view {
    MBProgressHUD *progressHud = [self ymDefaultSettingsWithAlertType:type
                                                             withView:view];
    progressHud.label.text = stringTitle;
    progressHud.detailsLabel.text = stringMessage;
    
    if (floatDelay > 0) {
        [progressHud hideAnimated:YES
                       afterDelay:floatDelay];
    }
    if (block) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((floatDelay + .1f) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self ymHideAllHud];
        });
        block();
    }
    
    return progressHud;
}

+ (MBProgressHUD *) ymDefaultSettingsWithAlertType : (YMWeakAlertType) type {
    return [self ymDefaultSettingsWithAlertType:type
                                       withView:[UIApplication sharedApplication].delegate.window];
}

+ (MBProgressHUD *) ymDefaultSettingsWithAlertType : (YMWeakAlertType) type
                                          withView : (UIView *) view{
    MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo:view
                                                      animated:YES];
    if (type == YMWeakAlertTypeLight) {
        progressHud.contentColor = [UIColor blackColor];
    } else {
        progressHud.contentColor = [UIColor whiteColor];
        progressHud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor ;
        progressHud.bezelView.backgroundColor = [UIColor blackColor];
    }
    progressHud.mode = MBProgressHUDModeText;
    progressHud.userInteractionEnabled = false;
    
    return progressHud;
}

+ (MBProgressHUD *) ymShowIndicatorAfterDelay : (CGFloat) floatDelay {
    return [self ymShowIndicatorAfterDelay:floatDelay
                               withMessage:nil];
}

+ (MBProgressHUD *) ymShowIndicatorAfterDelay : (CGFloat) floatDelay
                                     withView : (UIView *) view {
    return [self ymShowIndicatorAfterDelay:floatDelay
                                  withView:view
                               withMessage:nil];
}

+ (MBProgressHUD *) ymShowIndicatorAfterDelay : (CGFloat) floatDelay
                                  withMessage : (NSString *) stringMessage {
    return [self ymShowIndicatorAfterDelay:floatDelay
                                  withView:[UIApplication sharedApplication].delegate.window
                               withMessage:stringMessage];
}

+ (MBProgressHUD *) ymShowIndicatorAfterDelay : (CGFloat) floatDelay
                                     withView : (UIView *) view
                                  withMessage : (NSString *) stringMessage {
    MBProgressHUD *progressHud= [MBProgressHUD showHUDAddedTo:view
                                                     animated:YES];
    progressHud.userInteractionEnabled = false;
    if (stringMessage) {
        progressHud.detailsLabel.text = stringMessage;
    }
    if (floatDelay > 0) {
        [progressHud hideAnimated:YES
                       afterDelay:floatDelay];
    }
    return progressHud;
}




@end
