//
//  MQGradientLayerView.h
//  MQExtensionKit
//
//  Created by 冯明庆 on 18/11/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MQGradientLayerView : UIView
/*

 @param point_begin // the point that gradient begins . (CGPoint){[0,1],[0,1]} // 渐变从哪开始
 @param point_end // the point that gradient ends . (CGPoint){[0,1],[0,1]} // 渐变在哪结束
 @param colors // colors that uses for gradient . // 颜色数组
 @param percents // each color holds the percent of the gradient area . [0..1] // 比例数组
 
 */
- (void) mq_begin_with : (CGPoint) point_begin
                   end : (CGPoint) point_end
                colors : (NSArray <UIColor *> *(^)(void)) colors
         each_percents : (NSArray <NSNumber *> *(^)(void)) percents ;

// note : the count of 'colors' and 'percents' must compare to each others .
// colors 数组和 percents 数组个数必须相同 .

@end

@interface MQGradientLinearLayer : CALayer

@property (nonatomic , strong) UIColor *color_begin ;
@property (nonatomic , strong) UIColor *color_end ;
@property (nonatomic , assign) CGPoint point_start;
@property (nonatomic , assign) CGPoint point_end;

@end

@interface MQGradientRadialLayer : CALayer

@property (nonatomic , strong) UIColor *color_begin ;
@property (nonatomic , strong) UIColor *color_end ;
@property (nonatomic , assign) CGPoint point_gradient_center;

@end
