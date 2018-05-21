//
//  UIFont+CCExtension.h
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 08/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef CC_FONT_ASPECT_SYS
    #define CC_FONT_ASPECT_SYS(_value_) [UIFont cc_system:CCScaleH(_value_)]
#endif

#ifndef CC_FONT_ASPECT_BOLD
    #define CC_FONT_ASPECT_BOLD(_value_) [UIFont cc_bold:CCScaleH(_value_)]
#endif

typedef NSString * CCFontFamilyName;

FOUNDATION_EXPORT CCFontFamilyName CCFontFamily_PingFangSC_Regular ;
FOUNDATION_EXPORT CCFontFamilyName CCFontFamily_PingFangSC_Medium ;
FOUNDATION_EXPORT CCFontFamilyName CCFontFamily_PingFangSC_Bold ;

@interface UIFont (CCExtension)

/// when you determin to make a font that auto adjust it self for different screens // 当你决定让字体也跟着屏幕做自适应的时候
/// note: fill in with CCScaleH(_value_) , and if you're not sure it is . // 使用 CScaleH(_value_) 进行操作 , 如果你不确定的话
/// use label's (also available on others) height and decrease 2 (for pixels) . // 使用 label(其它也适用)的高度 , 减去 2 像素

- (instancetype) cc_size : (CGFloat) fSize ;
+ (instancetype) cc_system : (CGFloat) fSize ;
+ (instancetype) cc_bold : (CGFloat) fSize ;
+ (instancetype) cc_family : (NSString *) sFontName
                      size : (CGFloat) fSize ;

/// make chinese characters can use italic font . // 使得汉字可以使用意大利斜体 .
+ (instancetype) cc_italic : (UIFont *) font
                      size : (CGFloat) fSize ;
+ (instancetype) cc_italic : (UIFont *) font
                      size : (CGFloat) fSize
             angle_percent : (CGFloat) percent ;

@end
