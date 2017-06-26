//
//  MBProgressHUD+CCExtension.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/3/28.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "MBProgressHUD+CCExtension.h"

#import "CCCommonTools.h"
#import "CCCommonDefine.h"

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@implementation MBProgressHUD (CCExtension)

- (void)enable {
    self.userInteractionEnabled = YES;
}
- (void)disable {
    self.userInteractionEnabled = false;
}
- (BOOL)isCurrentHasHud {
    return [MBProgressHUD ccIsCurrentHasHud:nil] > 0;
}

- (void) ccEnabled {
    self.userInteractionEnabled = YES;
}
- (void)ccDisable {
    self.userInteractionEnabled = false;
}

+ (NSInteger) ccIsCurrentHasHud : (UIView *) view {
    if (!view) view = UIApplication.sharedApplication.delegate.window;
    NSInteger iCount = 0;
    for (id viewT in view.subviews) {
        if ([viewT isKindOfClass:MBProgressHUD.class]) ++ iCount ;
    }
    return iCount;
}

+ (void) ccHideAll {
    [self ccHideAllFor:nil];
}
+ (void) ccHideAllFor : (UIView *) view {
    [self ccHideAllFor:view
              complete:nil];
}
+ (void) ccHideAllFor : (UIView *) view
             complete : (dispatch_block_t) blockComplete {
    if (!view) view = UIApplication.sharedApplication.delegate.window;
    if (view) {
        for (id viewT in view.subviews) {
            if ([viewT isKindOfClass:MBProgressHUD.class]) {
                
            }
        }
        CC_Safe_Operation(blockComplete, ^{
            blockComplete();
        });
    }
}

+ (void) ccHideSingle {
    [self ccHideAllFor:nil];
}
+ (void) ccHideSingleFor : (UIView *) view {
    if (!view) view = UIApplication.sharedApplication.delegate.window;
    CC_Main_Queue_Operation(^{
        [MBProgressHUD hideHUDForView:view
                             animated:YES];
    });
}

+ (instancetype) ccShowMessage : (NSString *) stringMessage {
    return [self ccShowMessage:stringMessage
                          with:nil];
}
+ (instancetype) ccShowMessage : (NSString *) stringMessage
                          with : (UIView *) view {
    return [self ccShowMessage:stringMessage
                          type:CCHudTypeNone
                          with:view];
}
+ (instancetype) ccShowMessage : (NSString *) stringMessage
                          type : (CCHudType) type
                          with : (UIView *) view {
    return [self ccShowTitle:nil
                     message:stringMessage
                        type:type
                        with:view];
}
+ (instancetype) ccShowTitle : (NSString *) stringTitle
                     message : (NSString *) stringMessage
                        type : (CCHudType) type
                        with : (UIView *) view {
    return [self ccShowTitle:stringTitle
                     message:stringMessage
                        type:type
                        with:view
                       delay:_CC_ALERT_DISSMISS_COMMON_DURATION_];
}
+ (instancetype) ccShowTitle : (NSString *) stringTitle
                     message : (NSString *) stringMessage
                        type : (CCHudType) type
                        with : (UIView *) view
                       delay : (CGFloat) floatDelay {
    return [self ccShowTitle:stringTitle
                     message:stringMessage
                        type:type
                        with:view
                       delay:floatDelay
                    complete:nil];
}
+ (instancetype) ccShowTitle : (NSString *) stringTitle
                     message : (NSString *) stringMessage
                        type : (CCHudType) type
                        with : (UIView *) view
                       delay : (CGFloat) floatDelay
                    complete : (dispatch_block_t) blockComplete {
    MBProgressHUD *hud = [self ccDefaultSetting:type with:view];
    hud.label.text = stringTitle;
    hud.detailsLabel.text = stringMessage;
    if (floatDelay > 0) {
        [hud hideAnimated:YES
               afterDelay:floatDelay];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                     (int64_t)((floatDelay + 0.1) * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
            CC_Safe_Operation(blockComplete, ^{
                blockComplete();
            });
        });
    } else {
        CC_Safe_Operation(blockComplete, ^{
            blockComplete();
        });
    }
    return hud;
}
// Indicator
+ (instancetype) ccShowIndicator : (CGFloat) floatDelay {
    return [self ccShowIndicator:floatDelay
                         message:nil];
}
+ (instancetype) ccShowIndicator : (CGFloat) floatDelay
                         message : (NSString *) stringMessage {
    return [self ccShowIndicator:floatDelay
                            with:nil
                         message:stringMessage];
}
+ (instancetype) ccShowIndicator : (CGFloat) floatDelay
                            with : (UIView *) view
                         message : (NSString *) stringMessage {
    return [self ccShowIndicator:floatDelay
                            with:view
                         message:stringMessage
                            type:CCHudTypeNone];
}
+ (instancetype) ccShowIndicator : (CGFloat) floatDelay
                            with : (UIView *) view
                         message : (NSString *) stringMessage
                            type : (CCHudType) type {
    return [self ccShowIndicator:floatDelay
                            with:view
                           title:nil
                         message:stringMessage
                            type:type];
}
+ (instancetype) ccShowIndicator : (CGFloat) floatDelay
                            with : (UIView *) view
                           title : (NSString *) stringTitle
                         message : (NSString *) stringMessage
                            type : (CCHudType) type {
    MBProgressHUD *hud = [MBProgressHUD ccDefaultSetting:type
                                                    with:view
                                       isIndicatorEnable:YES];
    hud.label.text = stringTitle;
    hud.detailsLabel.text = stringMessage;
    if (floatDelay > 0) {
        [hud hideAnimated:YES
               afterDelay:floatDelay];
    }
    return hud;
}

#pragma mark - Default Settings
+ (instancetype) ccDefaultSetting : (CCHudType) type {
    return [self ccDefaultSetting:CCHudTypeNone
                             with:nil];
}
+ (instancetype) ccDefaultSetting : (CCHudType) type
                             with : (UIView *) view {
    return [self ccDefaultSetting:type
                             with:view
                isIndicatorEnable:false];
}

+ (instancetype) ccDefaultSetting : (CCHudType) type
                             with : (UIView *) view
                isIndicatorEnable : (BOOL) isIndicatorEnable ; {
    if (!view) view = UIApplication.sharedApplication.delegate.window ;
    if (!view) view = UIApplication.sharedApplication.keyWindow ;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view
                                              animated:YES];
    if (!isIndicatorEnable) hud.mode = MBProgressHUDModeText;
    [hud disable];
    switch (type) {
        case CCHudTypeLight:{
            hud.contentColor = UIColor.blackColor;
        }break;
        case CCHudTypeDarkDeep:{
            hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        }
        case CCHudTypeDark:{
            hud.contentColor = UIColor.whiteColor;
            hud.bezelView.backgroundColor = UIColor.blackColor;
        }break;
            
        default:{
            hud.contentColor = UIColor.blackColor;
        }break;
    }
    return hud;
}

@end
