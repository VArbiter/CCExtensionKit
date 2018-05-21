//
//  UIView+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/3/28.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT CGFloat const _CC_DEFAULT_ANIMATION_COMMON_DURATION_;

typedef CGPoint CCPoint;
CCPoint CCPointMake(CGFloat x , CGFloat y);
CCPoint CCMakePointFrom(CGPoint point);
CGPoint CGMakePointFrom(CCPoint point);

typedef CGSize CCSize;
CCSize CCSizeMake(CGFloat width , CGFloat height);
CCSize CCMakeSizeFrom(CGSize size);
CGSize CGMakeSizeFrom(CCSize size);

typedef CGRect CCRect;
CCRect CCRectMake(CGFloat x , CGFloat y , CGFloat width , CGFloat height);
CCRect CCMakeRectFrom(CGRect rect);
CGRect CGMakeRectFrom(CCRect rect);

CGRect CGRectFull(void); // main screen bounds . // 等于屏幕的边界

typedef UIEdgeInsets CCEdgeInsets;
CCEdgeInsets CCEdgeInsetsMake(CGFloat top , CGFloat left , CGFloat bottom , CGFloat right);
CCEdgeInsets CCMakeEdgeInsetsFrom(UIEdgeInsets insets);
UIEdgeInsets UIMakeEdgeInsetsFrom(CCEdgeInsets insets);

/// scaled width && height // 按比例缩放后的 宽/高
CGFloat CCScaleW(CGFloat w);
CGFloat CCScaleH(CGFloat h);

/// length scale // 计算 宽/高 所占屏幕比例
CGFloat CCWScale(CGFloat w);
CGFloat CCHScale(CGFloat h);
CGPoint CCScaleOrigin(CGPoint origin);
CGSize CCScaleSize(CGSize size);

@interface UIView (CCExtension)

+ (instancetype) cc_common : (CGRect) frame ;

/// for some designer use basic UI that is not for iPhone 6/6s/7/8 // 针对于一些设计人员基于 iPhone 6/6s/7/8 所设计的尺寸
/// set H && W only once in somewhere for "+ (void) load" // 设置基准 宽 && 高 , 在 "+ (void) load "设置里调用一次即可
+ (void) cc_set_scale : (CGFloat) fWidth
               height : (CGFloat) fHeight ;

+ (void) cc_disable_animation : (void (^)(void)) action ;

@property (nonatomic , class , assign , readonly) CGFloat sWidth;
@property (nonatomic , class , assign , readonly) CGFloat sHeight;

@property (nonatomic , assign) CGSize size;
@property (nonatomic , assign) CGPoint origin;

@property (nonatomic , assign) CGFloat width;
@property (nonatomic , assign) CGFloat height;

@property (nonatomic , assign) CGFloat x;
@property (nonatomic , assign) CGFloat y;

@property (nonatomic , assign) CGFloat centerX;
@property (nonatomic , assign) CGFloat centerY;

@property (nonatomic , assign , readonly) CGFloat inCenterX ;
@property (nonatomic , assign , readonly) CGFloat inCenterY ;
@property (nonatomic , assign , readonly) CGPoint inCenter ;

@property (nonatomic , assign) CGFloat top;
@property (nonatomic , assign) CGFloat left;
@property (nonatomic , assign) CGFloat bottom;
@property (nonatomic , assign) CGFloat right;

@property (nonatomic , assign , readonly) CGFloat inTop;
@property (nonatomic , assign , readonly) CGFloat inLeft;
@property (nonatomic , assign , readonly) CGFloat inBottom;
@property (nonatomic , assign , readonly) CGFloat inRight;

/// an easy way to margin // 一个方便的方式进行校准
- (instancetype) cc_frame : (CGRect) frame ;
- (instancetype) cc_size : (CGSize) size ;
- (instancetype) cc_origin : (CGPoint) point ;

- (instancetype) cc_width : (CGFloat) fWidth ;
- (instancetype) cc_height : (CGFloat) fHeight ;

- (instancetype) cc_x : (CGFloat) fX ;
- (instancetype) cc_y : (CGFloat) fY ;

- (instancetype) cc_center_x : (CGFloat) fCenterX ;
- (instancetype) cc_center_y : (CGFloat) fCenterY ;
- (instancetype) cc_center : (CGPoint) pCenter ;

- (instancetype) cc_top : (CGFloat) fTop ;
- (instancetype) cc_left : (CGFloat) fLeft ;
- (instancetype) cc_bottom : (CGFloat) fBottom ;
- (instancetype) cc_right : (CGFloat) fRight ;

/// for xibs // 针对 xib 的
+ (instancetype) cc_from_xib ;
+ (instancetype) cc_from_xib : (Class) cls ;
+ (instancetype) cc_from_xib_b : (NSBundle *) bundle;

/// add && remove (return itself) // 添加和移除 , 返回他本省
- (instancetype) cc_add : (__kindof UIView *) view ;
- (void) cc_remove_from : (void (^)(__kindof UIView *viewSuper)) action ;
- (instancetype) cc_bring_to_front : (__kindof UIView *) view ;
- (instancetype) cc_send_to_back : (__kindof UIView *) view ;
- (instancetype) cc_make_to_front ;
- (instancetype) cc_make_to_back ;

/// enable / disable userinteraction // 启用 / 禁用用户交互
- (instancetype) cc_enable ;
- (instancetype) cc_disable ;

/// color && cornerRadius && contentMode // 颜色 / 圆角 / 包裹模式
- (instancetype) cc_color : (UIColor *) color ;
- (instancetype) cc_radius : (CGFloat) fRadius
                     masks : (BOOL) isMask ;
- (instancetype) cc_round_corner : (UIRectCorner) corner
                          radius : (CGFloat) fRadius ;
- (instancetype) cc_content_mode : (UIViewContentMode) mode ;

/// copy it self . // 复制自身
- (instancetype) cc_duplicate ;

/// find its absolute location in screen . // 找到 view 在屏幕中的绝对位置 
- (CGRect) cc_location_in_window ;

- (UIImage *) cc_capture_image_after_screen_updates : (BOOL) is_after_updates ;

@end

#pragma mark - -----

@interface UIView (CCExtension_FitHeight)

/// note: all the fit recalls ignores the text-indent . // 所有适应无视缩进

/// system font size , default line break mode , system font size // 默认 系统字体 , line break mode
CGFloat CC_TEXT_HEIGHT_S(CGFloat fWidth ,
                         CGFloat fEstimateHeight , // height that defualt to , if less than , return's it. (same below) // 默认高度 , 小于则返回它 (下同)
                         NSString *string);
CGFloat CC_TEXT_HEIGHT_C(CGFloat fWidth ,
                         CGFloat fEstimateHeight ,
                         NSString *string ,
                         UIFont *font ,
                         NSLineBreakMode mode);

/// for attributed string , Using system attributed auto fit // 针对富文本 , 使用系统进行自适应
CGFloat CC_TEXT_HEIGHT_A(CGFloat fWidth ,
                         CGFloat fEstimateHeight ,
                         NSAttributedString *aString);

/// using default for NSString // 使用 NSString 的默认设置
CGFloat CC_TEXT_HEIGHT_AS(CGFloat fWidth ,
                          CGFloat fEstimateHeight ,
                          NSString *aString ,
                          UIFont *font ,
                          NSLineBreakMode mode ,
                          CGFloat fLineSpacing ,
                          CGFloat fCharacterSpacing);

@end

@interface UIView (CCExtension_Delay_Operate)

/// make user interaction disable for a certain time . // 使得用户交互在特定的时间内禁止
// using dispatch_after . // 使用 dispatch_after
- (instancetype) cc_cold : (NSTimeInterval) interval ;

/// make user interaction enable for a certain time . // 使得用户交互在特定的时间内允许
// using dispatch_after . // 使用 dispatch_after
- (instancetype) cc_hot : (NSTimeInterval) interval ;

- (instancetype) cc_cold : (BOOL) is_cold
                    time : (NSTimeInterval) interval
                complete : (void(^)(__kindof UIView *v_t , BOOL is_enable)) cc_complete_block ;


@end
