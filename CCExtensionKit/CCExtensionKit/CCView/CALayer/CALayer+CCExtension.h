//
//  CALayer+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2018/5/20.
//  Copyright © 2018 冯明庆. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface CALayer (CCExtension)

@end

#pragma mark - -----

@interface UIView (CCExtension_Layer)

/// make view has a dash border , give nil to params for line // 使得 view 拥有一个 虚线边框 , 参数为 nil , 是实线边框 .
/// use this method after your custom for layer is finished . // 在自定义 layer 结束后 , 方可使用.
/// give the exact same radius you gave for your view . // 给和你自己的 view 相同的圆角
- (void) cc_make_dash : (NSArray <NSNumber *> *) t_dash_pattern
               radius : (CGFloat) f_corner_radius
           line_color : (UIColor *) color_line
           line_width : (CGFloat) f_linw_width ;
@end
