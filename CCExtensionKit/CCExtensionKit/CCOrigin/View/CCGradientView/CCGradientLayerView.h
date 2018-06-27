//
//  CCGradientLayerView.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 18/11/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCGradientLayerView : UIView

- (void) cc_begin_with : (CGPoint) pBegin // the point that gradient begins . (CGPoint){[0,1],[0,1]} // 渐变从哪开始
                   end : (CGPoint) pEnd // the point that gradient ends . (CGPoint){[0,1],[0,1]} // 渐变在哪结束
                colors : (NSArray <UIColor *> *(^)(void)) colors // colors that uses for gradient . // 颜色数组
         each_percents : (NSArray <NSNumber *> *(^)(void)) percents ;// each color holds the percent of the gradient area . [0..1] // 比例数组

// note : the count of 'colors' and 'percents' must compare to each others .
// colors 数组和 percents 数组个数必须相同 .

@end
