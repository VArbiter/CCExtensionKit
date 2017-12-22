//
//  MBProgressHUD+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/3/28.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#if __has_include(<MBProgressHUD/MBProgressHUD.h>)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"
    @import MBProgressHUD;
#pragma clang diagnostic pop

typedef NS_ENUM(NSInteger , CCHudExtensionType) {
    CCHudExtensionTypeNone = 0 ,
    CCHudExtensionTypeLight ,
    CCHudExtensionTypeDark ,
    CCHudExtensionTypeDarkDeep
};

@interface MBProgressHUD (CCExtension)

/// init , default showing after actions complete , no need to deploy showing action "ccShow".
/// 初始化 . 默认在 动作完成后展示 , 不用实现 "ccShow"
+ (instancetype) init ;
+ (instancetype) init : (UIView *) view ;

/// generate a hud with its bounds . default with application window . // 生成一个 hud , 默认是 应用主窗口
/// also , you have to add it after generate compete , and deploy showing action "ccShow" . // 需要在生成完毕后添加 , 然后调用 "ccShow"
+ (instancetype) ccGenerate ;
+ (instancetype) ccGenerate : (UIView *) view ;

/// for block interact for user operate action . // 是否阻挡用户点击
- (instancetype) ccEnable ;
- (instancetype) ccDisable ;

+ (BOOL) ccHasHud ;
+ (BOOL) ccHasHud : (UIView *) view ;

/// for showing action // 展示类操作
- (instancetype) ccShow ; // if needed , default showing after chain complete // 如果需要 , 默认展示在 链 完成后战术
- (void) ccHide ; // default 2 seconds . and hide will trigger dealloc . last step . // 默认两秒钟 . hide 会触发 dealloc , 最后一步
- (void) ccHide : (NSTimeInterval) interval ;

/// messages && indicator // 文本和指示器
- (instancetype) ccIndicator ;
- (instancetype) ccSimple ; // default // 默认
- (instancetype) ccTitle : (NSString *) sTitle ;
- (instancetype) ccMessage : (NSString *) sMessage ;
- (instancetype) ccType : (CCHudExtensionType) type ;

/// if deploy , make sure you DO NOT delpoied "ccShow"; // 如果实现下方这些 , 不能调用 "ccShow"
- (instancetype) ccDelay : (CGFloat) fDelay ;
- (instancetype) ccGrace : (NSTimeInterval) interval ; // same as MBProgressHud // 和 MBProgressHud 相同
- (instancetype) ccMin : (NSTimeInterval) interval ; // same as MBProgressHud // 和 MBProgressHud 相同
- (instancetype) ccComplete : (void (^)(void)) complete ;

@end

#pragma mark - -----

@interface UIView (CCExtension_Hud)

- (__kindof MBProgressHUD *) ccHud ;
+ (__kindof MBProgressHUD *) ccHud : (UIView *) view ;

@end

#endif
