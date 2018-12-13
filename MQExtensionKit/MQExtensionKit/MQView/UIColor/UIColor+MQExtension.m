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
+ (instancetype) mq_hex_s : (NSString *) s_hex {
    if (!s_hex || ![s_hex isKindOfClass:NSString.class] || s_hex.length < 6) {
        return self.clearColor;
    }
    if ([s_hex hasPrefix:@"##"] || [s_hex hasPrefix:@"0x"] || [s_hex hasPrefix:@"0X"]) {
        s_hex = [s_hex substringFromIndex:2];
    }
    else if ([s_hex hasPrefix:@"#"]) s_hex = [s_hex substringFromIndex:1];
    
    if (s_hex.length < 6) return self.clearColor;
    s_hex = s_hex.uppercaseString;
    
    unsigned int r , g , b ;
    
    NSRange range = NSMakeRange(0, 2);
    [[NSScanner scannerWithString:[s_hex substringWithRange:range]] scanHexInt:&r];
    range.location = 2 ;
    [[NSScanner scannerWithString:[s_hex substringWithRange:range]] scanHexInt:&g];
    range.location = 4 ;
    [[NSScanner scannerWithString:[s_hex substringWithRange:range]] scanHexInt:&b];
    
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

- (UIImage *)mq_image {
    return [UIImage mq_color:self];
}

- (CGFloat)mq_red {
    return self.mq_RGBA.firstObject.floatValue;
}
- (CGFloat)mq_green {
    return self.mq_RGBA[1].floatValue;
}
- (CGFloat)mq_blue {
    return self.mq_RGBA[2].floatValue;
}
- (CGFloat)mq_alpha {
    return self.mq_RGBA.lastObject.floatValue;
}

- (NSArray<NSNumber *> *)mq_RGBA {
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
    UIImage *image_generate = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image_generate;
}

@end
