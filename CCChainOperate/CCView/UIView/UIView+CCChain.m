//
//  UIView+CCChain.m
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 02/08/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "UIView+CCChain.h"
#import "UIGestureRecognizer+CCChain.h"

static CGFloat _CC_DEFAULT_SCALE_WIDTH_ = 750.f;
static CGFloat _CC_DEFAULT_SCALE_HEIGHT_ = 1334.f;

#pragma mark - Struct
CCPoint CCPointMake(CGFloat x , CGFloat y) {
    CCPoint o;
    o.x = x / _CC_DEFAULT_SCALE_WIDTH_ * UIScreen.mainScreen.bounds.size.width;
    o.y = y / _CC_DEFAULT_SCALE_HEIGHT_ * UIScreen.mainScreen.bounds.size.height;
    return o;
}

CCSize CCSizeMake(CGFloat width , CGFloat height) {
    CCSize s;
    s.width = width / _CC_DEFAULT_SCALE_WIDTH_ * UIScreen.mainScreen.bounds.size.width;
    s.height = height / _CC_DEFAULT_SCALE_HEIGHT_ * UIScreen.mainScreen.bounds.size.height;
    return s;
}

CCRect CCRectMake(CGFloat x , CGFloat y , CGFloat width , CGFloat height) {
    CCRect r;
    r.origin = CCPointMake(x, y);
    r.size = CCSizeMake(width, height);
    return r;
}

#pragma mark - Scale
CGFloat CCScaleW(CGFloat w) {
    return w / _CC_DEFAULT_SCALE_WIDTH_ * UIScreen.mainScreen.bounds.size.width;
}
CGFloat CCScaleH(CGFloat h) {
    return h / _CC_DEFAULT_SCALE_HEIGHT_ * UIScreen.mainScreen.bounds.size.height;
}

CGFloat CCWScale(CGFloat w) {
    return w / _CC_DEFAULT_SCALE_WIDTH_;
}
CGFloat CCHScale(CGFloat h) {
    return h / _CC_DEFAULT_SCALE_HEIGHT_;
}

@implementation UIView (CCChain)

+ (void (^)(CGFloat, CGFloat))scaleSet {
    return ^(CGFloat w , CGFloat h) {
        _CC_DEFAULT_SCALE_WIDTH_ = w;
        _CC_DEFAULT_SCALE_HEIGHT_ = h;
    };
}

+ (UIView *(^)(CCRect))common {
    return ^UIView *(CCRect r) {
        CGRect g = CGRectMake(r.origin.x, r.origin.y, r.size.width, r.size.height);
        return [[UIView alloc] initWithFrame:g];
    };
}

#pragma mark - Setter
- (void) setSize : (CGSize) size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
- (CGSize) size {
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}
- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setSizeC:(CCSize)sizeC {
    CGRect frame = self.frame;
    frame.size = CGSizeMake(sizeC.width, sizeC.height);
    self.frame = frame;
}
- (CCSize)sizeC {
    return (CCSize){self.frame.size.width , self.frame.size.height};
}

- (void)setOriginC:(CCPoint)originC{
    CGRect frame = self.frame;
    frame.origin = CGPointMake(originC.x, originC.y);
    self.frame = frame;
}
- (CCPoint)originC {
    return (CCPoint){self.frame.origin.x , self.frame.origin.y};
}

- (void)setWidth:(CGFloat)width{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
- (CGFloat) width {
    return self.frame.size.width;
}

- (void) setHeight : (CGFloat) height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
- (CGFloat) height {
    return self.frame.size.height;
}

- (void) setX : (CGFloat) x{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}
- (CGFloat) x {
    return self.frame.origin.x;
}

- (void) setY : (CGFloat) y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
- (CGFloat) y {
    return self.frame.origin.y;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}
- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}
- (CGFloat)centerY {
    return self.center.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}
- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}
- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}
- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

+ (CGFloat)sWidth {
    return UIScreen.mainScreen.bounds.size.width;
}
+ (CGFloat)sHeight {
    return UIScreen.mainScreen.bounds.size.height;
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

- (UIView *(^)(UIView *))addSub {
    __weak typeof(self) pSelf = self;
    return ^UIView *(UIView *v) {
        [pSelf addSubview:v];
        return pSelf;
    };
}

- (void (^)(void (^)(UIView *)))removeFrom {
    __weak typeof(self) pSelf = self;
    return ^(void (^t)(UIView *)) {
        if (t) t(pSelf.superview);
        [pSelf removeFromSuperview];
    };
}

- (UIView *(^)(UIView *))bringToFront {
    __weak typeof(self) pSelf = self;
    return ^UIView *(UIView *v) {
        [pSelf bringSubviewToFront:v];
        return pSelf;
    };
}

- (UIView *(^)(UIView *))sendToBack {
    __weak typeof(self) pSelf = self;
    return ^UIView *(UIView *v) {
        [pSelf sendSubviewToBack:v];
        return pSelf;
    };
}

- (UIView *(^)(UIGestureRecognizer *))gesture {
    __weak typeof(self) pSelf = self;
    return ^UIView *(UIGestureRecognizer *gr) {
        if (gr) {
            pSelf.userInteractionEnabled = YES;
            [pSelf addGestureRecognizer:gr];
        }
        return pSelf;
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
        return pSelf.gesture(UITapGestureRecognizer.common().tapC(i, ^(UIGestureRecognizer *tapGR) {
            if (t) t(pSelf , (UITapGestureRecognizer *)tapGR);
        }));
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
        return pSelf.gesture(UILongPressGestureRecognizer.common().pressC(f, ^(UIGestureRecognizer *pressGR) {
            if (t) t(pSelf , (UILongPressGestureRecognizer *) pressGR);
        }));
    };
}

@end
