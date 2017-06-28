//
//  MBProgressHUD+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/3/28.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

typedef NS_ENUM(NSInteger , CCHudType) {
    CCHudTypeNone = 0 ,
    CCHudTypeLight ,
    CCHudTypeDark ,
    CCHudTypeDarkDeep
};

@interface MBProgressHUD (CCExtension)

@property (nonatomic , readonly) void enable ; // 阻挡用户操作
@property (nonatomic , readonly) void disable ;

@property (nonatomic , readonly) BOOL isCurrentHasHud ; // default keyWindow

- (void) ccEnabled ;
- (void) ccDisable ;

+ (NSInteger) ccIsCurrentHasHud : (UIView *) view ;

+ (void) ccHideAll ;
+ (void) ccHideAllFor : (UIView *) view ;
+ (void) ccHideAllFor : (UIView *) view
             complete : (dispatch_block_t) blockComplete ;

+ (void) ccHideSingle ;
+ (void) ccHideSingleFor : (UIView *) view ;

+ (instancetype) ccShowMessage : (NSString *) stringMessage;
+ (instancetype) ccShowMessage : (NSString *) stringMessage
                          with : (UIView *) view;
+ (instancetype) ccShowMessage : (NSString *) stringMessage
                          type : (CCHudType) type
                          with : (UIView *) view;
+ (instancetype) ccShowTitle : (NSString *) stringTitle
                     message : (NSString *) stringMessage
                        type : (CCHudType) type
                        with : (UIView *) view;
+ (instancetype) ccShowTitle : (NSString *) stringTitle
                     message : (NSString *) stringMessage
                        type : (CCHudType) type
                        with : (UIView *) view
                       delay : (CGFloat) floatDelay ;
+ (instancetype) ccShowTitle : (NSString *) stringTitle
                     message : (NSString *) stringMessage
                        type : (CCHudType) type
                        with : (UIView *) view
                       delay : (CGFloat) floatDelay
                    complete : (dispatch_block_t) blockComplete ;

// Indicator
+ (instancetype) ccShowIndicator : (CGFloat) floatDelay;
+ (instancetype) ccShowIndicator : (CGFloat) floatDelay
                         message : (NSString *) stringMessage;
+ (instancetype) ccShowIndicator : (CGFloat) floatDelay
                            with : (UIView *) view
                         message : (NSString *) stringMessage;
+ (instancetype) ccShowIndicator : (CGFloat) floatDelay
                            with : (UIView *) view
                         message : (NSString *) stringMessage
                            type : (CCHudType) type ;
+ (instancetype) ccShowIndicator : (CGFloat) floatDelay
                            with : (UIView *) view
                           title : (NSString *) stringTitle
                         message : (NSString *) stringMessage
                            type : (CCHudType) type ;

#pragma mark - NOT FOR PRIMARY

+ (instancetype) ccDefaultSetting : (CCHudType) type ;
+ (instancetype) ccDefaultSetting : (CCHudType) type
                             with : (UIView *) view ;
+ (instancetype) ccDefaultSetting : (CCHudType) type
                             with : (UIView *) view
                isIndicatorEnable : (BOOL) isIndicatorEnable ;
@end
