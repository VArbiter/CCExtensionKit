//
//  UIColor+MQExtension.h
//  MQExtensionKit
//
//  Created by 冯明庆 on 2017/4/17.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef MQ_COLOR_HEX
    #define MQ_COLOR_HEX(_hex_,_alpha_) [UIColor mq_hex:(_hex_) alpha:(_alpha_)]
#endif

#ifndef MQ_COLOR_HEX_S
    #define MQ_COLOR_HEX_S(_hex_,_alpha_) [[UIColor mq_hex_s:(_hex_)] mq_alpha:(_alpha_)]
#endif

@interface UIColor (MQExtension)

/// eg: 0xFFFFFF , 0x000000
+ (instancetype) mq_hex : (int) value ;
+ (instancetype) mq_hex : (int) value
                  alpha : (double) alpha ;
/// eg: @"0xFFFFFF" , @"##FFFFFF" , @"#FFFFFF" , @"0XFFFFFF"
/// otherwise , returns clear color . // 否则 , 返回透明色
+ (instancetype) mq_hex_s : (NSString *) s_hex;
+ (instancetype) mq_R : (double) r
                    G : (double) g
                    B : (double) b ;
+ (instancetype) mq_R : (double) r
                    G : (double) g
                    B : (double) b
                    A : (double) a ;

- (instancetype) mq_alpha : (double) alpha ;

+ (instancetype) mq_random;

/// generate a image that size equals (CGSize){1.f , 1.f} // 生成一张大小是一像素的图片
@property (nonatomic , readonly) UIImage *mq_image;

/// returns the original R , G , B , A for colors // 返回这个图片的原始 R,G,B,A
/// note : if use it to generate a new color , has to make sure that each one must muti by "255.f" // 如果使用它去生成新的颜色 , 保证每个都乘上 "255.f"
/// return 0 if sth goes wrong // 如果出现错误 , 返回 0 
@property (nonatomic , assign , readonly) CGFloat mq_red ;
@property (nonatomic , assign , readonly) CGFloat mq_green ;
@property (nonatomic , assign , readonly) CGFloat mq_blue ;
@property (nonatomic , assign , readonly) CGFloat mq_alpha ;

/// returns the same order as RGBA // 按照 RGBA 的顺序 .
@property (nonatomic , readonly) NSArray <NSNumber *> *mq_RGBA;

@end

#pragma mark - -----

@interface UIImage (MQExtension_Color)

/// generate a image with colors.
+ (instancetype) mq_color : (UIColor *) color;
+ (instancetype) mq_color : (UIColor *) color
                     size : (CGSize) size ;

@end
