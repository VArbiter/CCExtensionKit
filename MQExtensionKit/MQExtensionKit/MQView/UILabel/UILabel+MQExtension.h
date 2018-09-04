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

/// using sizeThatFits:(CGSize) to calculate the height . // 使用 sizeThatFits:(CGSize) 去计算高度
- (CGSize) mq_attributed_text_height : (CGFloat) f_estimate
                               style : ( NSParagraphStyle * _Nonnull ) style
                                font : ( UIFont * _Nonnull ) font
                                text : ( NSString * _Nonnull ) s_text ;

@end
