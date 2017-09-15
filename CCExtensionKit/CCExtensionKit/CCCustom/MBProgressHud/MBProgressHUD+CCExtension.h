//
//  MBProgressHUD+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/3/28.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#if __has_include(<MBProgressHUD/MBProgressHUD.h>)

@import MBProgressHUD;

typedef NS_ENUM(NSInteger , CCHudExtensionType) {
    CCHudExtensionTypeNone = 0 ,
    CCHudExtensionTypeLight ,
    CCHudExtensionTypeDark ,
    CCHudExtensionTypeDarkDeep
};

@interface MBProgressHUD (CCExtension)

/// init ,  default showing after actions complete , no need to deploy showing action "ccShow".
+ (instancetype) init ;
+ (instancetype) init : (UIView *) view ;

/// generate a hud with its bounds . default with application window .
/// also , you have to add it after generate compete , and deploy showing action "ccShow" .
+ (instancetype) ccGenerate ;
+ (instancetype) ccGenerate : (UIView *) view ;

/// for block interact for user operate action .
- (instancetype) ccEnable ;
- (instancetype) ccDisable ;

+ (BOOL) ccHasHud ;
+ (BOOL) ccHasHud : (UIView *) view ;

/// for showing action
- (instancetype) ccShow ; // if needed , default showing after chain complete
- (void) ccHide ; // default 2 seconds . and hide will trigger dealloc . last step .
- (void) ccHide : (NSTimeInterval) interval ;

/// messages && indicator
- (instancetype) ccIndicator ;
- (instancetype) ccSimple ; // default
- (instancetype) ccTitle : (NSString *) sTitle ;
- (instancetype) ccMessage : (NSString *) sMessage ;
- (instancetype) ccType : (CCHudExtensionType) type ;

/// if deploy , make sure you DO NOT delpoied "show()";
- (instancetype) ccDelay : (CGFloat) fDelay ;
- (instancetype) ccGrace : (NSTimeInterval) interval ; // same as MBProgressHud
- (instancetype) ccMin : (NSTimeInterval) interval ; // same as MBProgressHud
- (instancetype) ccComplete : (void (^)()) complete ;

@end

#pragma mark - -----

@interface UIView (CCExtension_Hud)

- (__kindof MBProgressHUD *) ccHud ;
+ (__kindof MBProgressHUD *) ccHud : (UIView *) view ;

@end

#endif
