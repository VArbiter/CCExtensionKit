//
//  UIColor+MQExtension.m
//  MQExtensionKit
//
//  Created by 冯明庆 on 2017/4/17.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UIColor+MQExtension.h"

#import <objc/runtime.h>

@implementation UIColor (MQExtension)

+ (instancetype) mq_hex : (int) value {
    return [self mq_hex:value alpha:1.f];
}

+ (instancetype) mq_hex : (int) value
                  alpha : (double) alpha {
    return [UIColor colorWithRed:( (double) ( (value & 0xFF0000) >> 16) ) / 255.f
                           green:( (double) ( (value & 0xFF00) >> 8) ) / 255.f
                            blue:( (double) (value & 0xFF) ) / 255.f
                           alpha:alpha];
}
+ (instancetype) mq_hex_s : (NSString *) sHex {
    if (!sHex || ![sHex isKindOfClass:NSString.class] || sHex.length < 6) {
        return self.clearColor;
    }
    if ([sHex hasPrefix:@"##"] || [sHex hasPrefix:@"0x"] || [sHex hasPrefix:@"0X"]) {
        sHex = [sHex substringFromIndex:2];
    }
    else if ([sHex hasPrefix:@"#"]) sHex = [sHex substringFromIndex:1];
    
    if (sHex.length < 6) return self.clearColor;
    sHex = sHex.uppercaseString;
    
    unsigned int r , g , b ;
    
    NSRange range = NSMakeRange(0, 2);
    [[NSScanner scannerWithString:[sHex substringWithRange:range]] scanHexInt:&r];
    range.location = 2 ;
    [[NSScanner scannerWithString:[sHex substringWithRange:range]] scanHexInt:&g];
    range.location = 4 ;
    [[NSScanner scannerWithString:[sHex substringWithRange:range]] scanHexInt:&b];
    
    return [self mq_R:r G:g B:b];
}
+ (instancetype) mq_R : (double) r
                    G : (double) g
                    B : (double) b {
    return [self mq_R:r G:g B:b A:1.f];
}
+ (instancetype) mq_R : (double) r
                    G : (double) g
                    B : (double) b
                    A : (double) a {
    return [UIColor colorWithRed:r / 255.f
                           green:g / 255.f
                            blue:b / 255.f
                           alpha:a];
}

- (instancetype) mq_alpha : (double) alpha {
    return [self colorWithAlphaComponent:alpha];
}

+ (instancetype) mq_random {
    CGFloat (^t)(void) = ^CGFloat {
        return arc4random_uniform(256) / 255.0f;
    };
    
    UIColor *c = [UIColor colorWithRed:t()
                                 green:t()
                                  blue:t()
                                 alpha:1.f];
    return c;
}

- (UIImage *)image_t {
    return [UIImage mq_color:self];
}

- (CGFloat)red_t {
    return self.RGBA.firstObject.floatValue;
}
- (CGFloat)green_t {
    return self.RGBA[1].floatValue;
}
- (CGFloat)blue_t {
    return self.RGBA[2].floatValue;
}
- (CGFloat)alpha_t {
    return self.RGBA.lastObject.floatValue;
}

- (NSArray<NSNumber *> *)RGBA {
    NSArray *t = objc_getAssociatedObject(self, "MQ_UICOLOR_GET_RGBA_ASSOCIATE_KEY");
    if (t) return t;
    CGFloat r = .0f,
    g = .0f,
    b = .0f,
    a = .0f;
    
    if ([self getRed:&r green:&g blue:&b alpha:&a]) {
        NSMutableArray *t = [NSMutableArray arrayWithObjects:@(r),@(g),@(b),@(a), nil];
        objc_setAssociatedObject(self, "MQ_UICOLOR_GET_RGBA_ASSOCIATE_KEY", t, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return t;
    }
    return nil;
}

@end

@implementation UIImage (MQExtension_Color)

+ (instancetype) mq_color : (UIColor *) color {
    return [self mq_color:color size:CGSizeZero];
}
+ (instancetype) mq_color : (UIColor *) color
                     size : (CGSize) size {
    if (size.width <= .0f) size.width = 1.f;
    if (size.height <= .0f) size.height = 1.f;
    
    CGRect rect = (CGRect){CGPointZero, size};
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *imageGenerate = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageGenerate;
}

@end
