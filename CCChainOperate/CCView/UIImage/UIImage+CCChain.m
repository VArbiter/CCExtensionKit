//
//  UIImage+CCChain.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 09/08/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "UIImage+CCChain.h"

@implementation UIImage (CCChain)

- (CGFloat)width {
    return self.size.width;
}
- (CGFloat)height {
    return self.size.height;
}

- (CGSize (^)(CGFloat))zoom {
    __weak typeof(self) pSelf = self;
    return ^CGSize (CGFloat f) {
        if (f > .0f) {
            CGFloat ratio = pSelf.height / pSelf.width;
            CGFloat ratioWidth = pSelf.width * f;
            CGFloat ratioHeight = ratioWidth * ratio;
            return CGSizeMake(ratioWidth, ratioHeight);
        }
        return pSelf.size;
    };
}

- (UIImage *(^)(UIEdgeInsets))resizable {
    __weak typeof(self) pSelf = self;
    return ^UIImage *(UIEdgeInsets s) {
        return [pSelf resizableImageWithCapInsets:s];
    };
}

- (UIImage *(^)(UIImageRenderingMode))rendering {
    __weak typeof(self) pSelf = self;
    return ^UIImage *(UIImageRenderingMode m) {
        return [pSelf imageWithRenderingMode:m];
    };
}

+ (UIImage *(^)(UIColor *))colorS {
    return ^UIImage *(UIColor *c) {
        return self.colorC(c, CGSizeZero);
    };
}

+ (UIImage *(^)(UIColor *, CGSize))colorC {
    return ^UIImage *(UIColor *c , CGSize s) {
        if (s.width <= .0f) s.width = 1.f;
        if (s.height <= .0f) s.height = 1.f;
        
        CGRect rect = (CGRect){CGPointZero, s};
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, c.CGColor);
        CGContextFillRect(context, rect);
        UIImage *imageGenerate = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return imageGenerate;
    };
}

+ (UIImage *(^)(__unsafe_unretained Class, NSString *))bundle {
    return ^UIImage *(Class c , NSString *s) {
        NSBundle *b = [NSBundle bundleForClass:c];
        NSString *bName = b.infoDictionary[@"CFBundleName"];
        NSString *sc = [NSString stringWithFormat:@"%ld",(NSInteger)UIScreen.mainScreen.scale];
        NSString *temp = [[[s stringByAppendingString:@"@"] stringByAppendingString:sc] stringByAppendingString:@"x"];
        NSString *p = [b pathForResource:temp
                                  ofType:@"png"
                             inDirectory:[bName stringByAppendingString:@".bundle"]];
        return [UIImage imageWithContentsOfFile:p];
    };
}

+ (UIImage *(^)(NSString *))named {
    return ^UIImage *(NSString *s) {
        return [self imageNamed:s];
    };
}

+ (UIImage *(^)(NSString *, NSBundle *))namedB {
    return ^UIImage *(NSString *s , NSBundle *b) {
        return [self imageNamed:s
                       inBundle:b
  compatibleWithTraitCollection:nil];
    };
}

+ (UIImage *(^)(NSString *))file {
    return ^UIImage *(NSString * sP) {
        return [UIImage imageWithContentsOfFile:sP];
    };
}

@end
