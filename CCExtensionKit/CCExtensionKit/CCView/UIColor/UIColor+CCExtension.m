//
//  UIColor+CCExtension.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/17.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UIColor+CCExtension.h"

@implementation UIColor (CCExtension)

+ (instancetype) ccHex : (int) value {
    return [self ccHex:value alpha:1.f];
}

+ (instancetype) ccHex : (int) value
                 alpha : (double) alpha {
    return [UIColor colorWithRed:( (double) ( (value & 0xFF0000) >> 16) ) / 255.f
                           green:( (double) ( (value & 0xFF00) >> 8) ) / 255.f
                            blue:( (double) (value & 0xFF) ) / 255.f
                           alpha:alpha];
}
+ (instancetype) ccHexS : (NSString *) sHex {
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
    
    return [self ccR:r G:g B:b];
}
+ (instancetype) ccR : (double) r
                   G : (double) g
                   B : (double) b {
    return [self ccR:r G:g B:b A:1.f];
}
+ (instancetype) ccR : (double) r
                   G : (double) g
                   B : (double) b
                   A : (double) a {
    return [UIColor colorWithRed:r / 255.f
                           green:g / 255.f
                            blue:b / 255.f
                           alpha:a];
}

- (instancetype) ccAlpha : (double) alpha {
    return [self colorWithAlphaComponent:alpha];
}

+ (instancetype) random {
    CGFloat (^t)(void) = ^CGFloat {
        return arc4random_uniform(256) / 255.0f;
    };
    
    UIColor *c = [UIColor colorWithRed:t()
                                 green:t()
                                  blue:t()
                                 alpha:1.f];
    return c;
}

- (UIImage *)imageT {
    return [UIImage ccColor:self];
}

@end

@implementation UIImage (CCExtension_Color)

+ (instancetype) ccColor : (UIColor *) color {
    return [self ccColor:color size:CGSizeZero];
}
+ (instancetype) ccColor : (UIColor *) color
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
