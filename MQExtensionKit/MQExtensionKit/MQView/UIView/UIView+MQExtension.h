//
//  UIView+MQExtension.h
//  MQExtensionKit
//
//  Created by 冯明庆 on 2017/3/28.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT CGFloat const mq_default_animation_common_duration ;

/// orientation is enabled.  // 旋转方向 是启用的 .
/// all the function name ended with "_Precise" indicate that calculation will be precised . ( eg : it might be 0.33333333333333 ... ) // 所有以 "_Precise" 结尾的函数 , 计算是精确的 . (可能是 0.333333333 ... (0.3 3循环)) .
/// all the function name ended with "_o" indicate that calculation consider the orientation of device . // 所有以 "_o" 结尾的函数 , 都是考虑到了设备的旋转方向来计算的 .

/// for some designer use basic UI that is not for iPhone 6/6s/7/8 // 针对于一些设计人员设计的不是基于 iPhone 6/6s/7/8 所设计的尺寸
/// set H && W only once in somewhere for "+ (void) load" // 设置基准 宽 && 高 , 在 "+ (void) load "设置里调用一次即可

void mq_set_UI_designed_default_size(CGSize size) ;

typedef struct CG_BOXABLE CGPoint MQPoint;

MQPoint MQPointMake_Precise(CGFloat x , CGFloat y);
MQPoint MQPointMake(CGFloat x , CGFloat y);
MQPoint MQMakePointFrom(CGPoint point);

MQPoint MQPointMake_Precise_o(CGFloat x , CGFloat y);
MQPoint MQPointMake_o(CGFloat x , CGFloat y);
MQPoint MQMakePointFrom_o(CGPoint point);

CGPoint CGMakePointFrom(MQPoint point);

typedef struct CG_BOXABLE CGSize MQSize;

MQSize MQSizeMake_Precise(CGFloat width , CGFloat height);
MQSize MQSizeMake(CGFloat width , CGFloat height);
MQSize MQMakeSizeFrom(CGSize size);

MQSize MQSizeMake_Precise_o(CGFloat width , CGFloat height);
MQSize MQSizeMake_o(CGFloat width , CGFloat height);
MQSize MQMakeSizeFrom_o(CGSize size);

CGSize CGMakeSizeFrom(MQSize size);

typedef struct CG_BOXABLE CGRect MQRect;

MQRect MQRectMake_Precise(CGFloat x , CGFloat y , CGFloat width , CGFloat height);
MQRect MQRectMake(CGFloat x , CGFloat y , CGFloat width , CGFloat height);
MQRect MQMakeRectFrom(CGRect rect);

MQRect MQRectMake_Precise_o(CGFloat x , CGFloat y , CGFloat width , CGFloat height);
MQRect MQRectMake_o(CGFloat x , CGFloat y , CGFloat width , CGFloat height);
MQRect MQMakeRectFrom_o(CGRect rect);

CGRect CGMakeRectFrom(MQRect rect);

CGRect CGRectFull(void); // main screen bounds . // 等于屏幕的边界

typedef struct CG_BOXABLE UIEdgeInsets MQEdgeInsets;

MQEdgeInsets MQEdgeInsetsMake_Precise(CGFloat top , CGFloat left , CGFloat bottom , CGFloat right);
MQEdgeInsets MQEdgeInsetsMake(CGFloat top , CGFloat left , CGFloat bottom , CGFloat right);
MQEdgeInsets MQMakeEdgeInsetsFrom(UIEdgeInsets insets);

MQEdgeInsets MQEdgeInsetsMake_Precise_o(CGFloat top , CGFloat left , CGFloat bottom , CGFloat right);
MQEdgeInsets MQEdgeInsetsMake_o(CGFloat top , CGFloat left , CGFloat bottom , CGFloat right);
MQEdgeInsets MQMakeEdgeInsetsFrom_o(UIEdgeInsets insets);

UIEdgeInsets UIMakeEdgeInsetsFrom(MQEdgeInsets insets);

/// scaled width && height (based on main screen's width && height resolution) . // 按比例缩放后的 宽/高 (基于屏幕宽和高的分辨率)
CGFloat MQScaleW_Precise(CGFloat w);
CGFloat MQScaleW(CGFloat w);
CGFloat MQScaleH_Precise(CGFloat h);
CGFloat MQScaleH(CGFloat h);

CGFloat MQScaleW_Precise_o(CGFloat w);
CGFloat MQScaleW_o(CGFloat w);
CGFloat MQScaleH_Precise_o(CGFloat h);
CGFloat MQScaleH_o(CGFloat h);

/// aspect fit the width && height .(based on main screen's width resolution) // 按照特定比例缩放后的 宽 / 高 (基于屏幕宽的分辨率)
CGFloat MQAspectRatio(void);
CGFloat MQAspectW_Precise(CGFloat w);
CGFloat MQAspectW(CGFloat w);
CGFloat MQAspectH_Precise(CGFloat h);
CGFloat MQAspectH(CGFloat h);

CGFloat MQAspectRatio_o(void);
CGFloat MQAspectW_Precise_o(CGFloat w);
CGFloat MQAspectW_o(CGFloat w);
CGFloat MQAspectH_Precise_o(CGFloat h);
CGFloat MQAspectH_o(CGFloat h);

/// length scale . // 计算 宽/高 所占屏幕比例
CGFloat MQWScale(CGFloat w);
CGFloat MQHScale(CGFloat h);
CGPoint MQScaleOrigin(CGPoint origin);
CGSize MQScaleSize(CGSize size);

CGFloat MQWScale_o(CGFloat w);
CGFloat MQHScale_o(CGFloat h);
CGPoint MQScaleOrigin_o(CGPoint origin);
CGSize MQScaleSize_o(CGSize size);

/// get device orientation . if "UIDeviceOrientationFaceUp / UIDeviceOrientationFaceDown" have no relevance to your app , recommended to set YES with this param . if you set false / NO . you will get "UIDeviceOrientationUnknown" the first time you use . // 获得屏幕旋转方向 , 如果你的应用不在乎手机 是 "UIDeviceOrientationFaceUp / UIDeviceOrientationFaceDown" 的 , 推荐在参数设置为 YES . 如果设置 false / NO . 第一次获得屏幕旋转方向的时候 , 你会获得 "UIDeviceOrientationUnknown" .
UIDeviceOrientation mq_current_device_orientation(BOOL is_use_status_bar_orientation);

@interface UIView (MQExtension)

+ (instancetype) mq_common : (CGRect) frame ;

+ (void) mq_disable_animation : (void (^)(void)) action ;

@property (nonatomic , class , assign , readonly) CGFloat mq_width;
@property (nonatomic , class , assign , readonly) CGFloat mq_height;

@property (nonatomic , assign) CGSize mq_size;
@property (nonatomic , assign) CGPoint mq_origin;

@property (nonatomic , assign) CGFloat mq_width;
@property (nonatomic , assign) CGFloat mq_height;

@property (nonatomic , assign) CGFloat mq_x;
@property (nonatomic , assign) CGFloat mq_y;

@property (nonatomic , assign) CGFloat mq_center_x;
@property (nonatomic , assign) CGFloat mq_center_y;

@property (nonatomic , assign , readonly) CGFloat mq_in_center_x ;
@property (nonatomic , assign , readonly) CGFloat mq_in_center_y ;
@property (nonatomic , assign , readonly) CGPoint mq_in_center ;

@property (nonatomic , assign) CGFloat mq_top;
@property (nonatomic , assign) CGFloat mq_left;
@property (nonatomic , assign) CGFloat mq_bottom;
@property (nonatomic , assign) CGFloat mq_right;

@property (nonatomic , assign , readonly) CGFloat mq_in_top;
@property (nonatomic , assign , readonly) CGFloat mq_in_left;
@property (nonatomic , assign , readonly) CGFloat mq_in_bottom;
@property (nonatomic , assign , readonly) CGFloat mq_in_right;

/// an easy way to margin // 一个方便的方式进行校准
- (instancetype) mq_frame : (CGRect) frame ;
- (instancetype) mq_size : (CGSize) size ;
- (instancetype) mq_origin : (CGPoint) point ;

- (instancetype) mq_width : (CGFloat) f_width ;
- (instancetype) mq_height : (CGFloat) f_height ;

- (instancetype) mq_x : (CGFloat) f_x ;
- (instancetype) mq_y : (CGFloat) f_y ;

- (instancetype) mq_center_x : (CGFloat) f_center_x ;
- (instancetype) mq_center_y : (CGFloat) f_center_y ;
- (instancetype) mq_center : (CGPoint) p_center ;

- (instancetype) mq_top : (CGFloat) f_top ;
- (instancetype) mq_left : (CGFloat) f_left ;
- (instancetype) mq_bottom : (CGFloat) f_bottom ;
- (instancetype) mq_right : (CGFloat) f_right ;

/// for xibs // 针对 xib 的
+ (instancetype) mq_from_xib ;
+ (instancetype) mq_from_xib : (Class) cls ;
+ (instancetype) mq_from_xib_b : (NSBundle *) bundle;

/// add && remove (return itself) // 添加和移除 , 返回他本省
- (instancetype) mq_add : (__kindof UIView *) view ;
- (void) mq_remove_from : (void (^)(__kindof UIView *view_super)) action ;
- (instancetype) mq_bring_to_front : (__kindof UIView *) view ;
- (instancetype) mq_send_to_back : (__kindof UIView *) view ;
- (instancetype) mq_make_to_front ;
- (instancetype) mq_make_to_back ;

/// enable / disable userinteraction // 启用 / 禁用用户交互
- (instancetype) mq_enable ;
- (instancetype) mq_disable ;

/// color && cornerRadius && contentMode // 颜色 / 圆角 / 包裹模式
- (instancetype) mq_color : (UIColor *) color ;
- (instancetype) mq_radius : (CGFloat) f_radius
                     masks : (BOOL) is_mask ;
- (instancetype) mq_round_corner : (UIRectCorner) corners
                          radius : (CGFloat) f_radius ;
- (instancetype) mq_shadow_make : (UIColor *) color
                        opacity : (float) f_opacity
                         radius : (CGFloat) f_radius
                         offset : (CGSize) size_offset ;
- (instancetype) mq_content_mode : (UIViewContentMode) mode ;

/// copy it self , might be nil . // 复制自身 , 可能是空
- (instancetype) mq_duplicate ;

/// find its absolute location in screen . // 找到 view 在屏幕中的绝对位置 
- (CGRect) mq_location_in_window ;

/// generate a image for current window . // 为当前 window 生成一张图片 .
- (UIImage *) mq_capture_image_after_screen_updates : (BOOL) is_after_updates ;

/// forced window to a specific orientation . // 强制 window 旋转到指定方向 .
- (void) mq_force_window_to_orientation : (UIDeviceOrientation) orientation ;

@end

#pragma mark - -----

@interface UIView (MQExtension_Delay_Operate)

/// make user interaction disable for a certain time . // 使得用户交互在特定的时间内禁止
// using dispatch_after . // 使用 dispatch_after
- (instancetype) mq_cold : (NSTimeInterval) interval ;

/// make user interaction enable for a certain time . // 使得用户交互在特定的时间内允许
// using dispatch_after . // 使用 dispatch_after
- (instancetype) mq_hot : (NSTimeInterval) interval ;

- (instancetype) mq_cold : (BOOL) is_cold
                    time : (NSTimeInterval) interval
                complete : (void(^)(__kindof UIView *v_t , BOOL is_enable)) mq_complete_block ;

@end
