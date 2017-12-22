//
//  CCDropAlertView.h
//  CCQueueDropAlertController_Example
//
//  Created by 冯明庆 on 04/12/2017.
//  Copyright © 2017 elwin_frederick. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT CGFloat CC_DROP_ANIMATION_DURATION ;
FOUNDATION_EXPORT CGFloat CC_SNAP_DAMPING_DURATION ;

typedef NS_ENUM(NSInteger , CCDropAnimate) {
    CCDropAnimate_None = 0 , // no animate , just show . // 无动画 , 只是显示和消失
    CCDropAnimate_Smooth , // easy in , easy out .  // 顺滑进入 , 顺滑出
    CCDropAnimate_Snap // curve / snap in , curve / snap out . // 附着中心点的方式进入 , 附着中心点的方式出
};

NS_ASSUME_NONNULL_BEGIN

/// this class makes the custom view drop in , drop out .

@interface CCDropAlertView : UIView

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (instancetype) initWithView : (__kindof UIView *) view ;
- (instancetype) initWithView : (__kindof UIView *) view
                       showOn : (__kindof UIView *) viewOn ;

@property (nonatomic , strong , readonly) UIDynamicAnimator *animator ;
@property (nonatomic , strong , readonly) UIView *viewCustom ;
@property (nonatomic , assign , readonly) UIView *viewOn ;

/// enable or not offEdgePop , default is false // 是否启用超界消失 , 默认是 false
@property (nonatomic , assign , getter=isEnableOffEdgePop) BOOL enableOffEdgePop ;
/// animation will be started // 动画将要开始
@property (nonatomic , copy) void (^bActionStart)(CCDropAlertView *sender) ;
/// start animation will be ended // 开始动画已经结束 (视图已经完整出现在屏幕中央 , 动画器完成出现动画时调用)
@property (nonatomic , copy) void (^bActionStartDidEnd)(CCDropAlertView *sender) ;
/// animation already ended // 动画已经结束
@property (nonatomic , copy) void (^bActionDidEnd)(CCDropAlertView *sender) ;
/// animation was paused // 动画已经暂停
@property (nonatomic , copy) void (^bActionPaused)(CCDropAlertView *sender) ;
/// animation will be resumed // 动画将要恢复执行
@property (nonatomic , copy) void (^bActionResume)(CCDropAlertView *sender) ;

- (void) ccShow ; // default CCDropAnimate_Smooth
- (void) ccShow : (CCDropAnimate) animate ;
- (void) ccDismiss ; // default CCDropAnimate_Snap
- (void) ccDismiss : (CCDropAnimate) animate ;

/// set the background color for alert content view // 设置包裹视图的背景色
// note : falpha was the component for color , not for view . // falpha 是 color 的通道 , 不是 View 的通道
// note : thus , it has no effect for its subviews . // 所以 , 它不会影响到它的子试图
- (void) ccSetShadow : (UIColor *) color
               alpha : (CGFloat) fAlpha ;

@end

NS_ASSUME_NONNULL_END
