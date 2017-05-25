//
//  MBProgressHUD+CCExtension.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/3/28.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "MBProgressHUD+CCExtension.h"
#import "CCCommonDefine.h"

@implementation MBProgressHUD (CCExtension)

+ (void) ccHideAllHud {
    [self ccHideAllHud:nil];
}
+ (void) ccHideAllHud : (dispatch_block_t) blockComplete{
    [self ccHideAllHud:[UIApplication sharedApplication].delegate.window
          withComplete:blockComplete];
}

+ (void) ccHideAllHud : (UIView *) view
         withComplete : (dispatch_block_t) blockComplete {
    for (id object in view.subviews) {
        if ([object isKindOfClass:[MBProgressHUD class]]) {
            [self ccHideSingleHud];
        }
    }
    if (blockComplete) {
        blockComplete();
    }
}

+ (void) ccHideSingleHud {
    [self ccHideSingleHud:[UIApplication sharedApplication].delegate.window];
}

+ (void) ccHideSingleHud : (UIView *) view {
    if ([NSThread isMainThread])
        [MBProgressHUD hideHUDForView:view
                             animated:YES];
    else
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:view
                                 animated:YES];
        });
}

+ (BOOL) ccIsCurrentHasHud {
    return [self ccIsCurrentHasHud:[UIApplication sharedApplication].delegate.window];
}

+ (BOOL) ccIsCurrentHasHud : (UIView *) view {
    for (id obj in view.subviews) {
        if ([obj isKindOfClass:[self class]]) {
            return YES;
        }
    }
    return false;
}

+ (MBProgressHUD *) ccShowMessage : (NSString *) stringMessage {
    return [self ccShowTitle:nil
                 withMessage:stringMessage
          withHideAfterDelay:_CC_ALERT_DISMISS_INTERVAL_];
}
+ (MBProgressHUD *) ccShowMessage : (NSString *) stringMessage
                         withView : (UIView *) view {
    return [self ccShowTitle:nil
                 withMessage:stringMessage
          withHideAfterDelay:_CC_ALERT_DISMISS_INTERVAL_
           withCompleteBlock:nil
               withAlertType:CCWeakAlertTypeDark
                    withView:view];
}

+ (MBProgressHUD *) ccShowTitle : (NSString *) stringTitle
                    withMessage : (NSString *) stringMessage
             withHideAfterDelay : (CGFloat) floatDelay {
    return [self ccShowTitle:stringTitle
                 withMessage:stringMessage
          withHideAfterDelay:floatDelay
           withCompleteBlock:nil
               withAlertType:CCWeakAlertTypeDark];
}

+ (MBProgressHUD *) ccShowTitle : (NSString *) stringTitle
                    withMessage : (NSString *) stringMessage
              withCompleteBlock : (dispatch_block_t) block {
    return [self ccShowTitle:stringTitle
                 withMessage:stringMessage
          withHideAfterDelay:_CC_ALERT_DISMISS_INTERVAL_
           withCompleteBlock:block
               withAlertType:CCWeakAlertTypeDark];
}

+ (MBProgressHUD *) ccShowTitle : (NSString *) stringTitle
                    withMessage : (NSString *) stringMessage
             withHideAfterDelay : (CGFloat) floatDelay
              withCompleteBlock : (dispatch_block_t) block {
    return [self ccShowTitle : stringTitle
                 withMessage : stringMessage
          withHideAfterDelay : floatDelay
           withCompleteBlock : block
               withAlertType : CCWeakAlertTypeDark];
}

#pragma mark - With Type
+ (MBProgressHUD *) ccShowMessage : (NSString *) stringMessage
                    withAlertType : (CCWeakAlertType) type {
    return [self ccShowTitle:nil
                 withMessage:stringMessage
          withHideAfterDelay:_CC_ALERT_DISMISS_INTERVAL_
               withAlertType:type];
}
+ (MBProgressHUD *) ccShowTitle : (NSString *) stringTitle
                    withMessage : (NSString *) stringMessage
             withHideAfterDelay : (CGFloat) floatDelay
                  withAlertType : (CCWeakAlertType) type {
    return [self ccShowTitle:stringTitle
                 withMessage:stringMessage
          withHideAfterDelay:floatDelay
           withCompleteBlock:nil
               withAlertType:type];
}
+ (MBProgressHUD *) ccShowTitle : (NSString *) stringTitle
                    withMessage : (NSString *) stringMessage
              withCompleteBlock : (dispatch_block_t) block
                  withAlertType : (CCWeakAlertType) type{
    return [self ccShowTitle:stringTitle
                 withMessage:stringMessage
          withHideAfterDelay:_CC_ALERT_DISMISS_INTERVAL_
           withCompleteBlock:block
               withAlertType:type];
}
+ (MBProgressHUD *) ccShowTitle : (NSString *) stringTitle
                    withMessage : (NSString *) stringMessage
             withHideAfterDelay : (CGFloat) floatDelay
              withCompleteBlock : (dispatch_block_t) block
                  withAlertType : (CCWeakAlertType) type {
    MBProgressHUD *progressHud = [self ccDefaultSettingsWithAlertType:type];
    progressHud.label.text = stringTitle;
    progressHud.detailsLabel.text = stringMessage;
    
    if (floatDelay > 0) {
        [progressHud hideAnimated:YES
                       afterDelay:floatDelay];
    }
    if (block) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((floatDelay + .1f) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self ccHideAllHud];
        });
    }
    return progressHud;
}
+ (MBProgressHUD *) ccShowTitle : (NSString *) stringTitle
                    withMessage : (NSString *) stringMessage
             withHideAfterDelay : (CGFloat) floatDelay
              withCompleteBlock : (dispatch_block_t) block
                  withAlertType : (CCWeakAlertType) type
                       withView : (UIView *) view {
    MBProgressHUD *progressHud = [self ccDefaultSettingsWithAlertType:type
                                                             withView:view];
    progressHud.label.text = stringTitle;
    progressHud.detailsLabel.text = stringMessage;
    
    if (floatDelay > 0) {
        [progressHud hideAnimated:YES
                       afterDelay:floatDelay];
    }
    if (block) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((floatDelay + .1f) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self ccHideAllHud];
        });
        block();
    }
    
    return progressHud;
}

+ (MBProgressHUD *) ccDefaultSettingsWithAlertType : (CCWeakAlertType) type {
    return [self ccDefaultSettingsWithAlertType:type
                                       withView:[UIApplication sharedApplication].delegate.window];
}

+ (MBProgressHUD *) ccDefaultSettingsWithAlertType : (CCWeakAlertType) type
                                          withView : (UIView *) view{
    MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo:view
                                                      animated:YES];
    if (type == CCWeakAlertTypeLight) {
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

+ (MBProgressHUD *) ccShowIndicatorAfterDelay : (CGFloat) floatDelay {
    return [self ccShowIndicatorAfterDelay:floatDelay
                               withMessage:nil];
}

+ (MBProgressHUD *) ccShowIndicatorAfterDelay : (CGFloat) floatDelay
                                     withView : (UIView *) view {
    return [self ccShowIndicatorAfterDelay:floatDelay
                                  withView:view
                               withMessage:nil];
}

+ (MBProgressHUD *) ccShowIndicatorAfterDelay : (CGFloat) floatDelay
                                  withMessage : (NSString *) stringMessage {
    return [self ccShowIndicatorAfterDelay:floatDelay
                                  withView:[UIApplication sharedApplication].delegate.window
                               withMessage:stringMessage];
}

+ (MBProgressHUD *) ccShowIndicatorAfterDelay : (CGFloat) floatDelay
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
