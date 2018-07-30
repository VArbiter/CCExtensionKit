//
//  UIFont+MQExtension.h
//  MQExtensionKit
//
//  Created by Elwinfrederick on 08/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef MQ_FONT_ASPECT_SYS
    #define MQ_FONT_ASPECT_SYS(_value_) [UIFont mq_system:MQAspectW(_value_)]
#endif

#ifndef MQ_FONT_ASPECT_BOLD
    #define MQ_FONT_ASPECT_BOLD(_value_) [UIFont mq_bold:MQAspectW(_value_)]
#endif

typedef NSString * MQFontFamilyName;

FOUNDATION_EXPORT MQFontFamilyName MQFontFamily_PingFangSC_Regular ;
FOUNDATION_EXPORT MQFontFamilyName MQFontFamily_PingFangSC_Medium ;
FOUNDATION_EXPORT MQFontFamilyName MQFontFamily_PingFangSC_Bold ;

@interface UIFont (MQExtension)

/// when you determin to make a font that auto adjust it self for different screens // 当你决定让字体也跟着屏幕做自适应的时候
/// note: fill in with MQScaleH(_value_) , and if you're not sure it is . // 使用 CScaleH(_value_) 进行操作 , 如果你不确定的话
/// use label's (also available on others) height and decrease 2 (for pixels) . // 使用 label(其它也适用)的高度 , 减去 2 像素

- (instancetype) mq_size : (CGFloat) fSize ;
+ (instancetype) mq_system : (CGFloat) fSize ;
+ (instancetype) mq_bold : (CGFloat) fSize ;
+ (instancetype) mq_family : (NSString *) sFontName
                      size : (CGFloat) fSize ;

/// make chinese characters can use italic font . // 使得汉字可以使用意大利斜体 .
+ (instancetype) mq_italic : (UIFont *) font
                      size : (CGFloat) fSize ;
+ (instancetype) mq_italic : (UIFont *) font
                      size : (CGFloat) fSize
             angle_percent : (CGFloat) percent ;

@end
