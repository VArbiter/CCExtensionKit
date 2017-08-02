//
//  UIView+CCChain.m
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 02/08/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "UIView+CCChain.h"
#import "UIGestureRecognizer+CCChain.h"

@implementation UIView (CCChain)

#pragma mark - Setter
- (void) setSize : (CGSize) size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

-(void)setWidth:(CGFloat)width{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
- (void) setHeight : (CGFloat) height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
- (void) setX : (CGFloat) x{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void) setY : (CGFloat) y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}
- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}
- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}
- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

#pragma mark - Getter
+ (CGFloat)sWidth {
    return UIScreen.mainScreen.bounds.size.width;
}
+ (CGFloat)sHeight {
    return UIScreen.mainScreen.bounds.size.height;
}

- (CGSize) size {
    return self.frame.size;
}
- (CGPoint)origin {
    return self.frame.origin;
}

- (CGFloat) height {
    return self.frame.size.height;
}
- (CGFloat) width {
    return self.frame.size.width;
}

- (CGFloat) x {
    return self.frame.origin.x;
}

- (CGFloat) y {
    return self.frame.origin.y;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (CGFloat)centerY {
    return self.center.y;
}

-(CGFloat)inCenterX{
    return self.frame.size.width*0.5;
}
-(CGFloat)inCenterY{
    return self.frame.size.height*0.5;
}
-(CGPoint)inCenter{
    return CGPointMake(self.inCenterX, self.inCenterY);
}

- (CGFloat)top {
    return self.frame.origin.y;
}
- (CGFloat)left {
    return self.frame.origin.x;
}
- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}
- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

#pragma mark - Margin
- (UIView *(^)(CGSize))sizeS {
    __weak typeof(self) pSelf = self;
    return ^UIView *(CGSize s) {
        pSelf.size = s;
        return pSelf;
    };
}
- (UIView *(^)(CGPoint))originS {
    __weak typeof(self) pSelf = self;
    return ^UIView *(CGPoint p) {
        pSelf.origin = p;
        return pSelf;
    };
}

- (UIView *(^)(CGFloat))widthS {
    __weak typeof(self) pSelf = self;
    return ^UIView *(CGFloat w) {
        pSelf.width = w;
        return pSelf;
    };
}
- (UIView *(^)(CGFloat))heightS {
    __weak typeof(self) pSelf = self;
    return ^UIView *(CGFloat h) {
        pSelf.height = h;
        return pSelf;
    };
}

- (UIView *(^)(CGFloat))yS {
    __weak typeof(self) pSelf = self;
    return ^UIView *(CGFloat y) {
        pSelf.y = y;
        return pSelf;
    };
}
- (UIView *(^)(CGFloat))xS {
    __weak typeof(self) pSelf = self;
    return ^UIView *(CGFloat x) {
        pSelf.x = x;
        return pSelf;
    };
}

- (UIView *(^)(CGFloat))centerXs {
    __weak typeof(self) pSelf = self;
    return ^UIView *(CGFloat centerX) {
        pSelf.centerX = centerX;
        return pSelf;
    };
}
- (UIView *(^)(CGFloat))centerYs {
    __weak typeof(self) pSelf = self;
    return ^UIView *(CGFloat centerY) {
        pSelf.centerY = centerY;
        return pSelf;
    };
}

- (UIView *(^)(CGFloat))topS {
    __weak typeof(self) pSelf = self;
    return ^UIView *(CGFloat top) {
        pSelf.top = top;
        return pSelf;
    };
}
- (UIView *(^)(CGFloat))leftS {
    __weak typeof(self) pSelf = self;
    return ^UIView *(CGFloat left) {
        pSelf.left = left;
        return pSelf;
    };
}
- (UIView *(^)(CGFloat))bottomS {
    __weak typeof(self) pSelf = self;
    return ^UIView *(CGFloat bottom) {
        pSelf.bottom = bottom;
        return pSelf;
    };
}
- (UIView *(^)(CGFloat))rightS {
    __weak typeof(self) pSelf = self;
    return ^UIView *(CGFloat right) {
        pSelf.right = right;
        return pSelf;
    };
}

#pragma mark - Method (s)

+ (UIView *(^)())fromXib {
    return ^UIView * {
        return UIView.fromXibB(nil);
    };
}

+ (UIView *(^)(__unsafe_unretained Class))fromXibC {
    return ^UIView * (Class c){
        NSBundle *b = [NSBundle bundleForClass:c];
        return UIView.fromXibB(b);
    };
}

+ (UIView *(^)(NSBundle *))fromXibB {
    return ^UIView *(NSBundle *b) {
        if (!b) b = NSBundle.mainBundle;
        return [[b loadNibNamed:NSStringFromClass(self)
                          owner:nil
                        options:nil] firstObject];
    };
}

- (UIView *(^)(void (^)(UIView *, UITapGestureRecognizer *)))tap {
    __weak typeof(self) pSelf = self;
    return ^UIView *(void (^t)(UIView *, UITapGestureRecognizer *)) {
        return pSelf.tapC(1, t);
    };
}

- (UIView *(^)(NSInteger, void (^)(UIView *, UITapGestureRecognizer *)))tapC {
    __weak typeof(self) pSelf = self;
    return ^UIView *(NSInteger i, void(^t)(UIView * , UITapGestureRecognizer *)) {
        [pSelf addGestureRecognizer:UITapGestureRecognizer.common().tapC(i, ^(UIGestureRecognizer *tapGR) {
            if (t) t(pSelf , (UITapGestureRecognizer *)tapGR);
        })];
        return pSelf;
    };
}

- (UIView *(^)(void (^)(UIView *, UILongPressGestureRecognizer *)))press {
    __weak typeof(self) pSelf = self;
    return ^UIView *(void (^t)(UIView *, UILongPressGestureRecognizer *)) {
        return pSelf.pressC(.5f, t);
    };
}

- (UIView *(^)(CGFloat, void (^)(UIView *, UILongPressGestureRecognizer *)))pressC {
    __weak typeof(self) pSelf = self;
    return ^UIView *(CGFloat f, void (^t)(UIView *, UILongPressGestureRecognizer *)) {
        [pSelf addGestureRecognizer:UILongPressGestureRecognizer.common().pressC(f, ^(UIGestureRecognizer *pressGR) {
            if (t) t(pSelf , (UILongPressGestureRecognizer *) pressGR);
        })];
        return pSelf;
    };
}

@end
