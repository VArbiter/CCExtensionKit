//
//  UILabel+MQExtension.h
//  MQExtensionKit
//
//  Created by 冯明庆 on 2017/4/1.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (MQExtension)

+ (instancetype) mq_common : (CGRect) frame;

/// auto fit with text || attributed Text , // 自适应 文本 , 富文本高度
/// params fEstimate that determins if the height after calculate ,  was lesser than original . // 参数 fEstimate 决定了计算高度后 , 是否比原来的高度小
/// note: ignores text-indent , attributed text's level will be higher than others // 无视缩进 , 富文本优先级高于其他 .
- (instancetype) mq_auto_height : (CGFloat) f_estimate ;
- (instancetype) mq_attributed_text_height : (CGFloat) f_estimate ;
- (instancetype) mq_text_height : (CGFloat) f_estimate ;

/// using sizeThatFits:(CGSize) to calculate the height . // 使用 sizeThatFits:(CGSize) 去计算高度
- (CGSize) mq_attributed_text_height : (CGFloat) f_estimate
                               style : ( NSParagraphStyle * _Nonnull ) style
                                font : ( UIFont * _Nonnull ) font
                                text : ( NSString * _Nonnull ) s_text ;

@end
