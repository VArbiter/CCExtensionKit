//
//  MQGradientLayerView.m
//  MQExtensionKit
//
//  Created by 冯明庆 on 18/11/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "MQGradientLayerView.h"

@interface MQGradientLayerView ()

@property (nonatomic , strong) CAGradientLayer *layerGradient ;

@end

@implementation MQGradientLayerView

- (void) mq_begin_with : (CGPoint) pBegin
                   end : (CGPoint) pEnd
                colors : (NSArray <UIColor *> *(^)(void)) colors
         each_percents : (NSArray <NSNumber *> *(^)(void)) percents {
    if (!colors || !percents) return ;
    NSArray <UIColor *> *aC = colors();
    NSArray <NSNumber *> *aN = percents();
    if (aC.count != aN.count) return;
    if (self.layerGradient) {
        [self.layerGradient removeFromSuperlayer];
        self.layerGradient = nil;
    }
    NSMutableArray *a = [NSMutableArray array];
    [aC enumerateObjectsUsingBlock:^(UIColor * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [a addObject:(__bridge id)obj.CGColor];
    }];
    
    CAGradientLayer *l = [CAGradientLayer layer];
    l.frame = self.bounds;
    l.colors = a;
    l.startPoint = pBegin;
    l.endPoint = pEnd;
    l.locations = aN;
//    l.type = kCAGradientLayerAxial; // only axial , and it's the default value // 目前只有 axial , 而且它还是默认值 
    self.layerGradient = l;
    [self.layer addSublayer:self.layerGradient];
}

@end

#pragma mark - -----

@interface MQGradientLinearLayer ()

@end

@implementation MQGradientLinearLayer

- (void)drawInContext:(CGContextRef)ctx {
    size_t locations_count = 2;
    CGFloat locations[2] = {0.0f, 1.0f};
    
    CGFloat r_begin = .0f,
    g_begin = .0f,
    b_begin = .0f,
    a_begin = .0f;
    
    CGFloat r_end = .0f,
    g_end = .0f,
    b_end = .0f,
    a_end = .0f;
    
    [self.color_begin getRed:&r_begin green:&g_begin blue:&b_begin alpha:&a_begin];
    [self.color_end getRed:&r_end green:&g_end blue:&b_end alpha:&a_end];
    
    CGFloat colors[8] = {r_begin, g_begin, b_begin, a_begin,
        r_end, g_end, b_end, a_end};
    CGColorSpaceRef color_space = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(color_space, colors, locations, locations_count);
    CGContextDrawLinearGradient(ctx, gradient, self.point_start, self.point_end, 0);
    CGGradientRelease(gradient);
}

@end

#pragma mark - -----

@interface MQGradientRadialLayer ()

@end

@implementation MQGradientRadialLayer

- (void)drawInContext:(CGContextRef)ctx {
    size_t locations_count = 2;
    CGFloat locations[2] = {0.0f, 1.0f};
    
    CGFloat r_begin = .0f,
    g_begin = .0f,
    b_begin = .0f,
    a_begin = .0f;
    
    CGFloat r_end = .0f,
    g_end = .0f,
    b_end = .0f,
    a_end = .0f;
    
    [self.color_begin getRed:&r_begin green:&g_begin blue:&b_begin alpha:&a_begin];
    [self.color_end getRed:&r_end green:&g_end blue:&b_end alpha:&a_end];
    
    CGFloat colors[8] = {r_begin, g_begin, b_begin, a_begin,
        r_end, g_end, b_end, a_end};
    CGColorSpaceRef color_space = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(color_space, colors, locations, locations_count);
    CGColorSpaceRelease(color_space);
    
    float radius = MIN(self.bounds.size.width , self.bounds.size.height);
    CGContextDrawRadialGradient (ctx, gradient, self.point_gradient_center, 0, self.point_gradient_center, radius, kCGGradientDrawsAfterEndLocation);
    CGGradientRelease(gradient);
}

@end
