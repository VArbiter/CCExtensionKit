//
//  CALayer+MQExtension.m
//  MQExtensionKit
//
//  Created by 冯明庆 on 2018/5/20.
//  Copyright © 2018 冯明庆. All rights reserved.
//

#import "CALayer+MQExtension.h"

@implementation CALayer (CCExtension)

@end

#pragma mark - -----

@implementation UIView (CCExtension_Layer)

- (void) mq_make_dash : (NSArray <NSNumber *> *) t_dash_pattern
               radius : (CGFloat) f_corner_radius
           line_color : (UIColor *) color_line
           line_width : (CGFloat) f_linw_width {
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.bounds = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    layer.position = (CGPoint){CGRectGetMidX(self.bounds) , CGRectGetMidY(self.bounds)};
    layer.path = [UIBezierPath bezierPathWithRoundedRect:layer.bounds
                                            cornerRadius:f_corner_radius].CGPath;
    layer.lineWidth = f_linw_width;
    layer.lineDashPattern = t_dash_pattern;
    layer.fillColor = UIColor.clearColor.CGColor;
    layer.strokeColor = color_line ? color_line.CGColor : UIColor.clearColor.CGColor;
    [self.layer addSublayer:layer];
}

@end
