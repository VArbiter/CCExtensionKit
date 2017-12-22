//
//  UILabel+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/1.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (CCExtension)

+ (instancetype) common : (CGRect) frame;

/// auto fit with text || attributed Text , // 自适应 文本 , 富文本高度
/// params fEstimate that determins if the height after calculate ,  was lesser than original . // 参数 fEstimate 决定了计算高度后 , 是否比原来的高度小
/// note: ignores text-indent , attributed text's level will be higher than others // 无视缩进 , 富文本优先级高于其他 .
- (instancetype) ccAutoHeight : (CGFloat) fEstimate ;
- (instancetype) ccAttributedTextHeight : (CGFloat) fEstimate ;
- (instancetype) ccTextHeight : (CGFloat) fEstimate ;

@end
