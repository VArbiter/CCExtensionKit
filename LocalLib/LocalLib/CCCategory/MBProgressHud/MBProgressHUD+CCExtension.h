//
//  MBProgressHUD+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/3/28.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

typedef NS_ENUM(NSInteger , CCWeakAlertType) {
    CCWeakAlertTypeLight = 0 ,
    CCWeakAlertTypeDark
};

@interface MBProgressHUD (CCExtension)

+ (void) ccHideAllHud ;
+ (void) ccHideAllHud : (dispatch_block_t) blockComplete;
+ (void) ccHideAllHud : (UIView *) view
         withComplete : (dispatch_block_t) blockComplete;

+ (void) ccHideSingleHud ;
+ (void) ccHideSingleHud : (UIView *) view ;
+ (BOOL) ccIsCurrentHasHud ;
+ (BOOL) ccIsCurrentHasHud : (UIView *) view ;

+ (MBProgressHUD *) ccShowMessage : (NSString *) stringMessage ;
+ (MBProgressHUD *) ccShowMessage : (NSString *) stringMessage
                    withAlertType : (CCWeakAlertType) type;
+ (MBProgressHUD *) ccShowMessage : (NSString *) stringMessage
                         withView : (UIView *) view ;

+ (MBProgressHUD *) ccShowTitle : (NSString *) stringTitle
                    withMessage : (NSString *) stringMessage
             withHideAfterDelay : (CGFloat) floatDelay ;
+ (MBProgressHUD *) ccShowTitle : (NSString *) stringTitle
                    withMessage : (NSString *) stringMessage
             withHideAfterDelay : (CGFloat) floatDelay
                  withAlertType : (CCWeakAlertType) type;

+ (MBProgressHUD *) ccShowTitle : (NSString *) stringTitle
                    withMessage : (NSString *) stringMessage
              withCompleteBlock : (dispatch_block_t) block ;
+ (MBProgressHUD *) ccShowTitle : (NSString *) stringTitle
                    withMessage : (NSString *) stringMessage
              withCompleteBlock : (dispatch_block_t) block
                  withAlertType : (CCWeakAlertType) type;


+ (MBProgressHUD *) ccShowTitle : (NSString *) stringTitle
                    withMessage : (NSString *) stringMessage
             withHideAfterDelay : (CGFloat) floatDelay
              withCompleteBlock : (dispatch_block_t) block ;
+ (MBProgressHUD *) ccShowTitle : (NSString *) stringTitle
                    withMessage : (NSString *) stringMessage
             withHideAfterDelay : (CGFloat) floatDelay
              withCompleteBlock : (dispatch_block_t) block
                  withAlertType : (CCWeakAlertType) type;
+ (MBProgressHUD *) ccShowTitle : (NSString *) stringTitle
                    withMessage : (NSString *) stringMessage
             withHideAfterDelay : (CGFloat) floatDelay
              withCompleteBlock : (dispatch_block_t) block
                  withAlertType : (CCWeakAlertType) type
                       withView : (UIView *) view ;

+ (MBProgressHUD *) ccDefaultSettingsWithAlertType : (CCWeakAlertType) type ;
+ (MBProgressHUD *) ccDefaultSettingsWithAlertType : (CCWeakAlertType) type
                                          withView : (UIView *) view ;

+ (MBProgressHUD *) ccShowIndicatorAfterDelay : (CGFloat) floatDelay ;
+ (MBProgressHUD *) ccShowIndicatorAfterDelay : (CGFloat) floatDelay
                                     withView : (UIView *) view ;
+ (MBProgressHUD *) ccShowIndicatorAfterDelay : (CGFloat) floatDelay
                                  withMessage : (NSString *) stringMessage ;
+ (MBProgressHUD *) ccShowIndicatorAfterDelay : (CGFloat) floatDelay
                                     withView : (UIView *) view
                                  withMessage : (NSString *) stringMessage ;


@end
