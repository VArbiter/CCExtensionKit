//
//  UIColor+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/17.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef CC_COLOR_HEX
    #define CC_COLOR_HEX(_hex_,_alpha_) [UIColor ccHex:(_hex_) alpha:(_alpha_)]
#endif

#ifndef CC_COLOR_HEX_S
    #define CC_COLOR_HEX_S(_hex_,_alpha_) [[UIColor ccHexS:(_hex_)] ccAlpha:(_alpha_)]
#endif

@interface UIColor (CCExtension)

/// eg: 0xFFFFFF , 0x000000
+ (instancetype) ccHex : (int) value ;
+ (instancetype) ccHex : (int) value
                 alpha : (double) alpha ;
/// eg: @"0xFFFFFF" , @"##FFFFFF" , @"#FFFFFF" , @"0XFFFFFF"
/// otherwise , returns clear color . // 否则 , 返回透明色
+ (instancetype) ccHexS : (NSString *) sHex;
+ (instancetype) ccR : (double) r
                   G : (double) g
                   B : (double) b ;
+ (instancetype) ccR : (double) r
                   G : (double) g
                   B : (double) b
                   A : (double) a ;

- (instancetype) ccAlpha : (double) alpha ;

+ (instancetype) random;

/// generate a image that size equals (CGSize){1.f , 1.f} // 生成一张大小是一像素的图片
@property (nonatomic , readonly) UIImage *imageT;

/// returns the original R , G , B , A for colors // 返回这个图片的原始 R,G,B,A
/// note : if use it to generate a new color , has to make sure that each one must muti by "255.f" // 如果使用它去生成新的颜色 , 保证每个都乘上 "255.f"
/// return 0 if sth goes wrong // 如果出现错误 , 返回 0 
@property (nonatomic , assign , readonly) CGFloat redT ;
@property (nonatomic , assign , readonly) CGFloat greenT ;
@property (nonatomic , assign , readonly) CGFloat blueT ;
@property (nonatomic , assign , readonly) CGFloat alphaT ;

@end

#pragma mark - -----

@interface UIImage (CCExtension_Color)

/// generate a image with colors.
+ (instancetype) ccColor : (UIColor *) color;
+ (instancetype) ccColor : (UIColor *) color
                    size : (CGSize) size ;

@end
