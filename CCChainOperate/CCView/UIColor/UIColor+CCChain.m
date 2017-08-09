//
//  UIColor+CCChain.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 09/08/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "UIColor+CCChain.h"
#import "UIImage+CCChain.h"

@implementation UIColor (CCChain)

+ (UIColor *(^)(int))hex {
    return ^UIColor * (int i) {
        return self.hexA(i, 1.f);
    };
}

+ (UIColor *(^)(int, double))hexA {
    return ^UIColor *(int i , double a) {
        return [UIColor colorWithRed:( (double) ( (i & 0xFF0000) >> 16) ) / 255.f
                               green:( (double) ( (i & 0xFF00) >> 8) ) / 255.f
                                blue:( (double) (i & 0xFF) ) / 255.f
                               alpha:a];
    };
}

+ (UIColor *(^)(double, double, double))RGB {
    return ^UIColor *(double R, double G, double B) {
        return self.RGBA(R, G, B, 1.f);
    };
}

+ (UIColor *(^)(double, double, double, double))RGBA {
    return ^UIColor *(double R, double G, double B , double A) {
        return [UIColor colorWithRed:R / 255.0f
                               green:G / 255.0f
                                blue:B / 255.0f
                               alpha:A];
    };
}

- (UIColor *(^)(CGFloat))alphaS {
    __weak typeof(self) pSelf = self;
    return ^UIColor *(CGFloat a) {
        return [pSelf colorWithAlphaComponent:a];
    };
}

- (UIImage *(^)())image {
    __weak typeof(self) pSelf = self;
    return ^UIImage * {
        return UIImage.colorS(pSelf);
    };
}

@end
