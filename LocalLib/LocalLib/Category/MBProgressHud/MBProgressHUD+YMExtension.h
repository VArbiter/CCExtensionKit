//
//  MBProgressHUD+YMExtension.h
//  ym_sell_ios
//
//  Created by 冯明庆 on 2017/3/28.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

typedef NS_ENUM(NSInteger , YMWeakAlertType) {
    YMWeakAlertTypeLight = 0 ,
    YMWeakAlertTypeDark
};

@interface MBProgressHUD (YMExtension)

+ (void) ymHideAllHud ;
+ (void) ymHideAllHud : (dispatch_block_t) blockComplete;
+ (void) ymHideAllHud : (UIView *) view
         withComplete : (dispatch_block_t) blockComplete;

+ (void) ymHideSingleHud ;
+ (void) ymHideSingleHud : (UIView *) view ;
+ (BOOL) ymIsCurrentHasHud ;
+ (BOOL) ymIsCurrentHasHud : (UIView *) view ;

+ (MBProgressHUD *) ymShowMessage : (NSString *) stringMessage ;
+ (MBProgressHUD *) ymShowMessage : (NSString *) stringMessage
                    withAlertType : (YMWeakAlertType) type;
+ (MBProgressHUD *) ymShowMessage : (NSString *) stringMessage
                         withView : (UIView *) view ;

+ (MBProgressHUD *) ymShowTitle : (NSString *) stringTitle
                    withMessage : (NSString *) stringMessage
             withHideAfterDelay : (CGFloat) floatDelay ;
+ (MBProgressHUD *) ymShowTitle : (NSString *) stringTitle
                    withMessage : (NSString *) stringMessage
             withHideAfterDelay : (CGFloat) floatDelay
                  withAlertType : (YMWeakAlertType) type;

+ (MBProgressHUD *) ymShowTitle : (NSString *) stringTitle
                    withMessage : (NSString *) stringMessage
              withCompleteBlock : (dispatch_block_t) block ;
+ (MBProgressHUD *) ymShowTitle : (NSString *) stringTitle
                    withMessage : (NSString *) stringMessage
              withCompleteBlock : (dispatch_block_t) block
                  withAlertType : (YMWeakAlertType) type;


+ (MBProgressHUD *) ymShowTitle : (NSString *) stringTitle
                    withMessage : (NSString *) stringMessage
             withHideAfterDelay : (CGFloat) floatDelay
              withCompleteBlock : (dispatch_block_t) block ;
+ (MBProgressHUD *) ymShowTitle : (NSString *) stringTitle
                    withMessage : (NSString *) stringMessage
             withHideAfterDelay : (CGFloat) floatDelay
              withCompleteBlock : (dispatch_block_t) block
                  withAlertType : (YMWeakAlertType) type;
+ (MBProgressHUD *) ymShowTitle : (NSString *) stringTitle
                    withMessage : (NSString *) stringMessage
             withHideAfterDelay : (CGFloat) floatDelay
              withCompleteBlock : (dispatch_block_t) block
                  withAlertType : (YMWeakAlertType) type
                       withView : (UIView *) view ;

+ (MBProgressHUD *) ymDefaultSettingsWithAlertType : (YMWeakAlertType) type ;
+ (MBProgressHUD *) ymDefaultSettingsWithAlertType : (YMWeakAlertType) type
                                          withView : (UIView *) view ;

+ (MBProgressHUD *) ymShowIndicatorAfterDelay : (CGFloat) floatDelay ;
+ (MBProgressHUD *) ymShowIndicatorAfterDelay : (CGFloat) floatDelay
                                     withView : (UIView *) view ;
+ (MBProgressHUD *) ymShowIndicatorAfterDelay : (CGFloat) floatDelay
                                  withMessage : (NSString *) stringMessage ;
+ (MBProgressHUD *) ymShowIndicatorAfterDelay : (CGFloat) floatDelay
                                     withView : (UIView *) view
                                  withMessage : (NSString *) stringMessage ;


@end
