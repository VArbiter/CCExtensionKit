//
//  CCGradientLayerView.m
//  CCExtensionKit
//
//  Created by 冯明庆 on 18/11/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "CCGradientLayerView.h"

@interface CCGradientLayerView ()

@property (nonatomic , strong) CAGradientLayer *layerGradient ;

@end

@implementation CCGradientLayerView

- (void) cc_begin_with : (CGPoint) pBegin
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
