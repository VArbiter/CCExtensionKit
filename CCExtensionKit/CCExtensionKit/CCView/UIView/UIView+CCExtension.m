//
//  UIView+CCExtension.m
//  CCExtensionKit
//
//  Created by 冯明庆 on 2017/3/28.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UIView+CCExtension.h"
#import "UIGestureRecognizer+CCExtension.h"

static CGFloat _CC_DEFAULT_SCALE_WIDTH_ = 750.f;
static CGFloat _CC_DEFAULT_SCALE_HEIGHT_ = 1334.f;
CGFloat const _CC_DEFAULT_ANIMATION_COMMON_DURATION_ = .3f;

#pragma mark - Struct
CCPoint CCPointMake(CGFloat x , CGFloat y) {
    CCPoint o;
    o.x = x / _CC_DEFAULT_SCALE_WIDTH_ * UIScreen.mainScreen.bounds.size.width;
    o.y = y / _CC_DEFAULT_SCALE_HEIGHT_ * UIScreen.mainScreen.bounds.size.height;
    return o;
}
CCPoint CCMakePointFrom(CGPoint point) {
    return CCPointMake(point.x, point.y);
}
CGPoint CGMakePointFrom(CCPoint point) {
    return CGPointMake(point.x, point.y);
}

CCSize CCSizeMake(CGFloat width , CGFloat height) {
    CCSize s;
    s.width = width / _CC_DEFAULT_SCALE_WIDTH_ * UIScreen.mainScreen.bounds.size.width;
    s.height = height / _CC_DEFAULT_SCALE_HEIGHT_ * UIScreen.mainScreen.bounds.size.height;
    return s;
}
CCSize CCMakeSizeFrom(CGSize size) {
    return CCSizeMake(size.width, size.height);
}
CGSize CGMakeSizeFrom(CCSize size) {
    return CGSizeMake(size.width, size.height);
}

CCRect CCRectMake(CGFloat x , CGFloat y , CGFloat width , CGFloat height) {
    CCRect r;
    r.origin = CCPointMake(x, y);
    r.size = CCSizeMake(width, height);
    return r;
}
CCRect CCMakeRectFrom(CGRect rect) {
    return CCRectMake(rect.origin.x,
                      rect.origin.y,
                      rect.size.width,
                      rect.size.height);
}
CGRect CGMakeRectFrom(CCRect rect) {
    return CGRectMake(rect.origin.x,
                      rect.origin.y,
                      rect.size.width,
                      rect.size.height);
}

CGRect CGRectFull(void){
    return UIScreen.mainScreen.bounds;
}

CCEdgeInsets CCEdgeInsetsMake(CGFloat top , CGFloat left , CGFloat bottom , CGFloat right) {
    CCEdgeInsets i;
    i.top = top / _CC_DEFAULT_SCALE_HEIGHT_ * UIScreen.mainScreen.bounds.size.height;
    i.left = left / _CC_DEFAULT_SCALE_WIDTH_ * UIScreen.mainScreen.bounds.size.width;
    i.bottom = bottom / _CC_DEFAULT_SCALE_HEIGHT_ * UIScreen.mainScreen.bounds.size.height;
    i.right = right / _CC_DEFAULT_SCALE_WIDTH_ * UIScreen.mainScreen.bounds.size.width;
    return i;
}
CCEdgeInsets CCMakeEdgeInsetsFrom(UIEdgeInsets insets) {
    return CCEdgeInsetsMake(insets.top,
                            insets.left,
                            insets.bottom,
                            insets.right);
}
UIEdgeInsets UIMakeEdgeInsetsFrom(CCEdgeInsets insets) {
    return UIEdgeInsetsMake(insets.top,
                            insets.left,
                            insets.bottom,
                            insets.right);
}

#pragma mark - Scale
CGFloat CCScaleW(CGFloat w) {
    return w / _CC_DEFAULT_SCALE_WIDTH_ * UIScreen.mainScreen.bounds.size.width;
}
CGFloat CCScaleH(CGFloat h) {
    return h / _CC_DEFAULT_SCALE_HEIGHT_ * UIScreen.mainScreen.bounds.size.height;
}

CGFloat CCAspectRatio(void) {
    return UIScreen.mainScreen.bounds.size.width * UIScreen.mainScreen.scale / _CC_DEFAULT_SCALE_WIDTH_ ;
}
CGFloat CCAspectW(CGFloat w) {
    return w * CCAspectRatio();
}
CGFloat CCAspectH(CGFloat h) {
    return h * CCAspectRatio();
}

CGPoint CCScaleOrigin(CGPoint origin) {
    return CGPointMake(CCScaleW(origin.x), CCScaleH(origin.y));
}
CGSize CCScaleSize(CGSize size) {
    return CGSizeMake(CCScaleW(size.width), CCScaleH(size.height));
}

CGFloat CCWScale(CGFloat w) {
    return w / _CC_DEFAULT_SCALE_WIDTH_;
}
CGFloat CCHScale(CGFloat h) {
    return h / _CC_DEFAULT_SCALE_HEIGHT_;
}

@implementation UIView (CCExtension)

+ (instancetype) cc_common : (CGRect) frame {
    CGRect g = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
    return [[self alloc] initWithFrame:g];
}
+ (void) cc_set_scale : (CGFloat) fWidth
             height : (CGFloat) fHeight {
    _CC_DEFAULT_SCALE_WIDTH_ = fWidth;
    _CC_DEFAULT_SCALE_HEIGHT_ = fHeight;
}

+ (void) cc_disable_animation : (void (^)(void)) action {
    if (action) {
        [UIView setAnimationsEnabled:false];
        action();
        [UIView setAnimationsEnabled:YES];
    }
}

#pragma mark - Setter && Getter
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

-(void)setWidth:(CGFloat)width{
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

- (void)setCenter_x:(CGFloat)center_x {
    self.center = CGPointMake(center_x, self.center.y);
}
- (CGFloat)center_x {
    return self.center.x;
}

- (void)setCenter_y:(CGFloat)center_y {
    self.center = CGPointMake(self.center.x, center_y);
}
- (CGFloat)center_y {
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

- (CGFloat)in_top {
    return .0f;
}
- (CGFloat)in_left {
    return .0f;
}
- (CGFloat)in_bottom {
    return self.frame.size.height;
}
- (CGFloat)in_right {
    return self.frame.size.width;
}

#pragma mark - -----
+ (CGFloat)f_width {
    return UIScreen.mainScreen.bounds.size.width;
}
+ (CGFloat)f_height {
    return UIScreen.mainScreen.bounds.size.height;
}

-(CGFloat)in_center_x{
    return self.frame.size.width*0.5;
}
-(CGFloat)in_center_y{
    return self.frame.size.height*0.5;
}
-(CGPoint)in_center{
    return CGPointMake(self.in_center_x, self.in_center_y);
}

- (instancetype) cc_frame : (CGRect) frame {
    self.frame = frame;
    return self;
}
- (instancetype) cc_size : (CGSize) size {
    self.size = size;
    return self;
}
- (instancetype) cc_origin : (CGPoint) point {
    self.origin = point;
    return self;
}

- (instancetype) cc_width : (CGFloat) fWidth {
    self.width = fWidth;
    return self;
}
- (instancetype) cc_height : (CGFloat) fHeight {
    self.height = fHeight;
    return self;
}

- (instancetype) cc_x : (CGFloat) fX {
    self.x = fX;
    return self;
}
- (instancetype) cc_y : (CGFloat) fY {
    self.y = fY;
    return self;
}

- (instancetype) cc_center_x : (CGFloat) fCenterX {
    self.center_x = fCenterX;
    return self;
}
- (instancetype) cc_center_y : (CGFloat) fCenterY {
    self.center_y = fCenterY;
    return self;
}
- (instancetype) cc_center : (CGPoint) pCenter {
    self.center = pCenter;
    return self;
}

- (instancetype) cc_top : (CGFloat) fTop {
    self.top = fTop;
    return self;
}
- (instancetype) cc_left : (CGFloat) fLeft {
    self.left = fLeft;
    return self;
}
- (instancetype) cc_bottom : (CGFloat) fBottom {
    self.bottom = fBottom;
    return self;
}
- (instancetype) cc_right : (CGFloat) fRight {
    self.right = fRight;
    return self;
}

/// for xibs
+ (instancetype) cc_from_xib {
    return [self cc_from_xib_b:nil];
}
+ (instancetype) cc_from_xib : (Class) cls {
    
    return [self cc_from_xib_b:[NSBundle bundleForClass:cls]];
}
+ (instancetype) cc_from_xib_b : (NSBundle *) bundle {
    if (!bundle) bundle = NSBundle.mainBundle;
    return [[bundle loadNibNamed:NSStringFromClass(self)
                           owner:nil
                         options:nil] firstObject];
}

/// add && remove (return itself)
- (instancetype) cc_add : (__kindof UIView *) view {
    if (view) [self addSubview:view];
    return self;
}
- (void)cc_remove_from : (void (^)(__kindof UIView *)) action {
    if (action) action(self.superview);
    if (self.superview) [self removeFromSuperview];
}
- (instancetype) cc_bring_to_front : (__kindof UIView *) view {
    if (view && [self.subviews containsObject:view]) [self bringSubviewToFront:view];
    return self;
}
- (instancetype) cc_send_to_back : (__kindof UIView *) view {
    if (view && [self.subviews containsObject:view]) [self sendSubviewToBack:view];
    return self;
}
- (instancetype) cc_make_to_front {
    if (self.superview) [self.superview bringSubviewToFront:self];
    return self;
}
- (instancetype) cc_make_to_back {
    if (self.superview) [self.superview sendSubviewToBack:self];
    return self;
}

/// enable / disable userinteraction
- (instancetype) cc_enable {
    self.userInteractionEnabled = YES;
    return self;
}
- (instancetype) cc_disable {
    self.userInteractionEnabled = false;
    return self;
}

/// color && cornerRadius && contentMode
- (instancetype) cc_color : (UIColor *) color {
    self.layer.backgroundColor = color ? color.CGColor : UIColor.clearColor.CGColor;
    return self;
}
- (instancetype) cc_radius : (CGFloat) fRadius
                     masks : (BOOL) isMask {
    self.layer.cornerRadius = fRadius;
    self.layer.masksToBounds = isMask;
    return self;
}
- (instancetype) cc_round_corner : (UIRectCorner) corner
                          radius : (CGFloat) fRadius {
    UIBezierPath *p = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                            byRoundingCorners:corner
                                                  cornerRadii:CGSizeMake(CCScaleW(fRadius), CCScaleH(fRadius))];
    CAShapeLayer *l = [[CAShapeLayer alloc] init];
    l.frame = self.bounds;
    l.path = p.CGPath;
    self.layer.mask = l;
    return self;
}
- (instancetype) cc_content_mode : (UIViewContentMode) mode {
    self.contentMode = mode;
    return self;
}

- (instancetype) cc_duplicate {
    NSData * dt = [NSKeyedArchiver archivedDataWithRootObject:self];
    return [NSKeyedUnarchiver unarchiveObjectWithData:dt];
}

- (CGRect) cc_location_in_window {
    UIWindow * window = UIApplication.sharedApplication.delegate.window;
    CGRect rect = [self convertRect:self.bounds
                             toView:window];
    return rect;
}

- (UIImage *) cc_capture_image_after_screen_updates : (BOOL) is_after_updates {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:is_after_updates];
    UIImage *t = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return t;
}

@end

#pragma mark - -----

@implementation UIView (CCExtension_FitHeight)

CGFloat CC_TEXT_HEIGHT_S(CGFloat fWidth , CGFloat fEstimateHeight , NSString *string) {
    return CC_TEXT_HEIGHT_C(fWidth,
                            fEstimateHeight ,
                            string,
                            [UIFont systemFontOfSize:UIFont.systemFontSize],
                            NSLineBreakByWordWrapping);
}
CGFloat CC_TEXT_HEIGHT_C(CGFloat fWidth ,
                         CGFloat fEstimateHeight ,
                         NSString *string ,
                         UIFont *font ,
                         NSLineBreakMode mode) {
    return CC_TEXT_HEIGHT_AS(fWidth,
                             fEstimateHeight,
                             string,
                             font,
                             mode,
                             -1,
                             -1);
}

CGFloat CC_TEXT_HEIGHT_A(CGFloat fWidth , CGFloat fEstimateHeight , NSAttributedString *aString) {
    CGRect rect = [aString boundingRectWithSize:(CGSize){fWidth , CGFLOAT_MAX}
                                        options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                        context:nil];
    return rect.size.height >= fEstimateHeight ? rect.size.height : fEstimateHeight;
}
CGFloat CC_TEXT_HEIGHT_AS(CGFloat fWidth ,
                          CGFloat fEstimateHeight ,
                          NSString *aString ,
                          UIFont *font ,
                          NSLineBreakMode mode ,
                          CGFloat fLineSpacing ,
                          CGFloat fCharacterSpacing) {
    CGRect rect = CGRectZero;
    NSMutableParagraphStyle *style = NSMutableParagraphStyle.alloc.init;
    style.lineBreakMode = mode;
    if (fLineSpacing >= 0) style.lineSpacing = fLineSpacing;
    
    // kinda awkward . it turns out the differences between the NSMutableDictionary && NSDictionary && NSPlaceHolderDictioanry .
    // 有点尴尬 , 是 可变字典 , 不可变字典 , 字面量字典 之间的区别 .
    if (font && (fCharacterSpacing >= 0)) {
        rect = [aString boundingRectWithSize:(CGSize){fWidth , CGFLOAT_MAX}
                                     options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSParagraphStyleAttributeName : style,
                                               NSFontAttributeName : font ,
                                               NSKernAttributeName : @(fCharacterSpacing)}
                                     context:nil];
    } else if (font) {
        rect = [aString boundingRectWithSize:(CGSize){fWidth , CGFLOAT_MAX}
                                     options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSParagraphStyleAttributeName : style,
                                               NSFontAttributeName : font}
                                     context:nil];
    } else if (fCharacterSpacing >= 0) {
        rect = [aString boundingRectWithSize:(CGSize){fWidth , CGFLOAT_MAX}
                                     options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSParagraphStyleAttributeName : style,
                                               NSKernAttributeName : @(fCharacterSpacing)}
                                     context:nil];
    } else {
        rect = [aString boundingRectWithSize:(CGSize){fWidth , CGFLOAT_MAX}
                                     options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSParagraphStyleAttributeName : style}
                                     context:nil];
    }

    return rect.size.height >= fEstimateHeight ? rect.size.height : fEstimateHeight;
}

@end

@implementation UIView (CCExtension_Delay_Operate)

- (instancetype) cc_cold : (NSTimeInterval) interval {
    return [self cc_cold:YES time:interval complete:nil];
}

- (instancetype) cc_hot : (NSTimeInterval) interval {
    return [self cc_cold:false time:interval complete:nil];
}

- (instancetype) cc_cold : (BOOL) is_cold
                    time : (NSTimeInterval) interval
                complete : (void(^)(__kindof UIView *v_t , BOOL is_enable)) cc_complete_block {
    
    self.userInteractionEnabled = !is_cold ;
    __weak typeof(self) weak_self = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong typeof(weak_self) strong_self = weak_self;
        strong_self.userInteractionEnabled = is_cold;
        if (cc_complete_block) cc_complete_block(strong_self , strong_self.userInteractionEnabled);
    });
    
    return self;
}

@end
