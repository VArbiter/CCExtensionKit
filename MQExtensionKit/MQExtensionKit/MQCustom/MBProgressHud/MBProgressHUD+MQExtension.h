//
//  MBProgressHUD+MQExtension.h
//  MQExtensionKit
//
//  Created by 冯明庆 on 2017/3/28.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#if __has_include(<MBProgressHUD/MBProgressHUD.h>)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"
    @import MBProgressHUD;
#pragma clang diagnostic pop

typedef NS_ENUM(NSInteger , MQHudExtensionType) {
    MQHudExtensionType_None = 0 ,
    MQHudExtensionType_Light ,
    MQHudExtensionType_Dark ,
    MQHudExtensionType_DarkDeep
};

@interface MBProgressHUD (MQExtension)
  
 /// set how long hud will hide after showing . // 设置 hud 在展示多久后消失
+ (void) mq_set_default_hide_time : (NSTimeInterval) interval ;

/// for block interact for user operate action . // 是否阻挡用户点击
- (instancetype) mq_responsd_user_interact ;
- (instancetype) mq_block_user_interact ;

+ (BOOL) mq_has_hud ;
+ (BOOL) mq_has_hud : (UIView *) view ;
    
/// generate an text Toast . // 创建普通文本提示框
+ (instancetype) mq_simple_title : (NSString *) s_title ;
+ (instancetype) mq_simple_message : (NSString *) s_message ;
+ (instancetype) mq_simple : (MQHudExtensionType) type
                with_title : (NSString *) s_title
                   message : (NSString *) s_message ;
+ (instancetype) mq_simple : (MQHudExtensionType) type
                  for_view : (__kindof UIView *) view
                with_title : (NSString *) s_title ;
+ (instancetype) mq_simple : (MQHudExtensionType) type
                  for_view : (__kindof UIView *) view
                with_title : (NSString *) s_title
                   message : (NSString *) s_message ;
    
/// generate an indicator . //  创建指示器
+ (instancetype) mq_indicator ;
+ (instancetype) mq_indicator : (MQHudExtensionType) type ;
+ (instancetype) mq_indicator : (MQHudExtensionType) type
                     for_view : (__kindof UIView *) view ;
+ (instancetype) mq_indicator : (MQHudExtensionType) type
                     for_view : (__kindof UIView *) view
                   with_title : (NSString *) s_title ;
+ (instancetype) mq_indicator : (MQHudExtensionType) type
                     for_view : (__kindof UIView *) view
                 with_message : (NSString *) s_message ;
+ (instancetype) mq_indicator : (MQHudExtensionType) type
                     for_view : (__kindof UIView *) view
                   with_title : (NSString *) s_title
                      message : (NSString *) s_message ;
    
/// messages && indicator // 文本和指示器
- (instancetype) mq_set_title : (NSString *) s_title ;
- (instancetype) mq_set_message : (NSString *) s_message ;
    
/// for showing action // 展示类操作
- (instancetype) mq_show : (BOOL) is_animated ; // if needed , default showing after complete // 如果需要 , 默认完成后展示
- (void) mq_hide : (BOOL) is_animated ; // default 2 seconds . and hide will trigger dealloc . // 默认两秒钟 . hide 会触发 dealloc .
- (void) mq_hide : (BOOL) is_animated
           after : (NSTimeInterval) interval ;
    
/// if invoked , make sure you DO NOT delpoied "cc_show"; // 如果实现下方这些 , 不能调用 "mq_show:"
- (instancetype) mq_delay : (CGFloat) f_delay ;
    
+ (void) mq_configure_type : (MBProgressHUD *) hud
                      type : (MQHudExtensionType) type ;
    
@end

#pragma mark - -----

@interface UIView (MQExtension_Hud)

- (__kindof MBProgressHUD *) mq_hud ;
+ (__kindof MBProgressHUD *) mq_hud : (UIView *) view ;

- (BOOL) mq_is_has_mb_progress_hud ;

@end

#endif
