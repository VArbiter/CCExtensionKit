//
//  UIView+MQExtension.m
//  MQExtensionKit
//
//  Created by 冯明庆 on 2017/3/28.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UIView+MQExtension.h"

static CGFloat _MQ_DEFAULT_SCALE_WIDTH_ = 750.f;
static CGFloat _MQ_DEFAULT_SCALE_HEIGHT_ = 1334.f;
CGFloat const mq_default_animation_common_duration = .3f;

#pragma mark - Struct
MQPoint MQPointMake(CGFloat x , CGFloat y) {
    MQPoint o;
    o.x = x / _MQ_DEFAULT_SCALE_WIDTH_ * UIScreen.mainScreen.bounds.size.width;
    o.y = y / _MQ_DEFAULT_SCALE_HEIGHT_ * UIScreen.mainScreen.bounds.size.height;
    return o;
}
MQPoint MQMakePointFrom(CGPoint point) {
    return MQPointMake(point.x, point.y);
}
CGPoint CGMakePointFrom(MQPoint point) {
    return CGPointMake(point.x, point.y);
}

MQSize MQSizeMake(CGFloat width , CGFloat height) {
    MQSize s;
    s.width = width / _MQ_DEFAULT_SCALE_WIDTH_ * UIScreen.mainScreen.bounds.size.width;
    s.height = height / _MQ_DEFAULT_SCALE_HEIGHT_ * UIScreen.mainScreen.bounds.size.height;
    return s;
}
MQSize MQMakeSizeFrom(CGSize size) {
    return MQSizeMake(size.width, size.height);
}
CGSize CGMakeSizeFrom(MQSize size) {
    return CGSizeMake(size.width, size.height);
}

MQRect MQRectMake(CGFloat x , CGFloat y , CGFloat width , CGFloat height) {
    MQRect r;
    r.origin = MQPointMake(x, y);
    r.size = MQSizeMake(width, height);
    return r;
}
MQRect MQMakeRectFrom(CGRect rect) {
    return MQRectMake(rect.origin.x,
                      rect.origin.y,
                      rect.size.width,
                      rect.size.height);
}
CGRect CGMakeRectFrom(MQRect rect) {
    return CGRectMake(rect.origin.x,
                      rect.origin.y,
                      rect.size.width,
                      rect.size.height);
}

CGRect CGRectFull(void){
    return UIScreen.mainScreen.bounds;
}

MQEdgeInsets MQEdgeInsetsMake(CGFloat top , CGFloat left , CGFloat bottom , CGFloat right) {
    MQEdgeInsets i;
    i.top = top / _MQ_DEFAULT_SCALE_HEIGHT_ * UIScreen.mainScreen.bounds.size.height;
    i.left = left / _MQ_DEFAULT_SCALE_WIDTH_ * UIScreen.mainScreen.bounds.size.width;
    i.bottom = bottom / _MQ_DEFAULT_SCALE_HEIGHT_ * UIScreen.mainScreen.bounds.size.height;
    i.right = right / _MQ_DEFAULT_SCALE_WIDTH_ * UIScreen.mainScreen.bounds.size.width;
    return i;
}
MQEdgeInsets MQMakeEdgeInsetsFrom(UIEdgeInsets insets) {
    return MQEdgeInsetsMake(insets.top,
                            insets.left,
                            insets.bottom,
                            insets.right);
}
UIEdgeInsets UIMakeEdgeInsetsFrom(MQEdgeInsets insets) {
    return UIEdgeInsetsMake(insets.top,
                            insets.left,
                            insets.bottom,
                            insets.right);
}

#pragma mark - Scale
CGFloat MQScaleW(CGFloat w) {
    return w / _MQ_DEFAULT_SCALE_WIDTH_ * UIScreen.mainScreen.bounds.size.width;
}
CGFloat MQScaleH(CGFloat h) {
    return h / _MQ_DEFAULT_SCALE_HEIGHT_ * UIScreen.mainScreen.bounds.size.height;
}

CGFloat MQAspectRatio(void) {
    return UIScreen.mainScreen.bounds.size.width * UIScreen.mainScreen.scale / _MQ_DEFAULT_SCALE_WIDTH_ ;
}
CGFloat MQAspectW(CGFloat w) {
    return w * MQAspectRatio();
}
CGFloat MQAspectH(CGFloat h) {
    return h * MQAspectRatio();
}

CGPoint MQScaleOrigin(CGPoint origin) {
    return CGPointMake(MQScaleW(origin.x), MQScaleH(origin.y));
}
CGSize MQScaleSize(CGSize size) {
    return CGSizeMake(MQScaleW(size.width), MQScaleH(size.height));
}

CGFloat MQWScale(CGFloat w) {
    return w / _MQ_DEFAULT_SCALE_WIDTH_;
}
CGFloat MQHScale(CGFloat h) {
    return h / _MQ_DEFAULT_SCALE_HEIGHT_;
}

@implementation UIView (MQExtension)

+ (instancetype) mq_common : (CGRect) frame {
    CGRect g = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
    return [[self alloc] initWithFrame:g];
}
+ (void) mq_set_scale : (CGFloat) f_width
             height : (CGFloat) f_height {
    _MQ_DEFAULT_SCALE_WIDTH_ = f_width;
    _MQ_DEFAULT_SCALE_HEIGHT_ = f_height;
}

+ (void) mq_disable_animation : (void (^)(void)) action {
    if (action) {
        [UIView setAnimationsEnabled:false];
        action();
        [UIView setAnimationsEnabled:YES];
    }
}

#pragma mark - Setter && Getter
- (void) setMq_size:(CGSize)mq_size {
    CGRect frame = self.frame;
    frame.size = mq_size;
    self.frame = frame;
}
- (CGSize) mq_size {
    return self.frame.size;
}

- (void)setMq_origin:(CGPoint)mq_origin {
    CGRect frame = self.frame;
    frame.origin = mq_origin;
    self.frame = frame;
}
- (CGPoint) mq_origin {
    return self.frame.origin;
}

-(void)setMq_width:(CGFloat)mq_width{
    CGRect frame = self.frame;
    frame.size.width = mq_width;
    self.frame = frame;
}
- (CGFloat) mq_width {
    return self.frame.size.width;
}

- (void) setMq_height:(CGFloat)mq_height {
    CGRect frame = self.frame;
    frame.size.height = mq_height;
    self.frame = frame;
}
- (CGFloat) mq_height {
    return self.frame.size.height;
}

- (void) setMq_x:(CGFloat)mq_x{
    CGRect frame = self.frame;
    frame.origin.x = mq_x;
    self.frame = frame;
}
- (CGFloat) mq_x {
    return self.frame.origin.x;
}

- (void) setMq_y:(CGFloat)mq_y {
    CGRect frame = self.frame;
    frame.origin.y = mq_y;
    self.frame = frame;
}
- (CGFloat) mq_y {
    return self.frame.origin.y;
}

- (void)setMq_center_x:(CGFloat)mq_center_x {
    self.center = CGPointMake(mq_center_x, self.center.y);
}
- (CGFloat) mq_center_x {
    return self.center.x;
}

- (void)setMq_center_y:(CGFloat)mq_center_y {
    self.center = CGPointMake(self.center.x, mq_center_y);
}
- (CGFloat)mq_center_y {
    return self.center.y;
}

- (void)setMq_top:(CGFloat)mq_top {
    CGRect frame = self.frame;
    frame.origin.y = mq_top;
    self.frame = frame;
}
- (CGFloat)mq_top {
    return self.frame.origin.y;
}

- (void)setMq_left:(CGFloat)mq_left {
    CGRect frame = self.frame;
    frame.origin.x = mq_left;
    self.frame = frame;
}
- (CGFloat) mq_left {
    return self.frame.origin.x;
}

- (void)setMq_bottom:(CGFloat)mq_bottom {
    CGRect frame = self.frame;
    frame.origin.y = mq_bottom - frame.size.height;
    self.frame = frame;
}
- (CGFloat) mq_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setMq_right:(CGFloat)mq_right {
    CGRect frame = self.frame;
    frame.origin.x = mq_right - frame.size.width;
    self.frame = frame;
}
- (CGFloat) mq_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat) mq_in_top {
    return .0f;
}
- (CGFloat) mq_in_left {
    return .0f;
}
- (CGFloat) mq_in_bottom {
    return self.frame.size.height;
}
- (CGFloat) mq_in_right {
    return self.frame.size.width;
}

#pragma mark - -----
+ (CGFloat) mq_width {
    return UIScreen.mainScreen.bounds.size.width;
}
+ (CGFloat) mq_height {
    return UIScreen.mainScreen.bounds.size.height;
}

- (CGFloat) mq_in_center_x {
    return self.frame.size.width * .5f;
}
- (CGFloat) mq_in_center_y {
    return self.frame.size.height * .5f;
}
- (CGPoint) mq_in_center{
    return CGPointMake(self.mq_in_center_x, self.mq_in_center_y);
}

- (instancetype) mq_frame : (CGRect) frame {
    self.frame = frame;
    return self;
}
- (instancetype) mq_size : (CGSize) size {
    self.mq_size = size;
    return self;
}
- (instancetype) mq_origin : (CGPoint) point {
    self.mq_origin = point;
    return self;
}

- (instancetype) mq_width : (CGFloat) f_width {
    self.mq_width = f_width;
    return self;
}
- (instancetype) mq_height : (CGFloat) f_height {
    self.mq_height = f_height;
    return self;
}

- (instancetype) mq_x : (CGFloat) f_x {
    self.mq_x = f_x;
    return self;
}
- (instancetype) mq_y : (CGFloat) f_y {
    self.mq_y = f_y;
    return self;
}

- (instancetype) mq_center_x : (CGFloat) f_center_x {
    self.mq_center_x = f_center_x;
    return self;
}
- (instancetype) mq_center_y : (CGFloat) f_center_y {
    self.mq_center_y = f_center_y;
    return self;
}
- (instancetype) mq_center : (CGPoint) p_center {
    self.center = p_center;
    return self;
}

- (instancetype) mq_top : (CGFloat) f_top {
    self.mq_top = f_top;
    return self;
}
- (instancetype) mq_left : (CGFloat) f_left {
    self.mq_left = f_left;
    return self;
}
- (instancetype) mq_bottom : (CGFloat) f_bottom {
    self.mq_bottom = f_bottom;
    return self;
}
- (instancetype) mq_right : (CGFloat) f_right {
    self.mq_right = f_right;
    return self;
}

/// for xibs
+ (instancetype) mq_from_xib {
    return [self mq_from_xib_b:nil];
}
+ (instancetype) mq_from_xib : (Class) cls {
    
    return [self mq_from_xib_b:[NSBundle bundleForClass:cls]];
}
+ (instancetype) mq_from_xib_b : (NSBundle *) bundle {
    if (!bundle) bundle = NSBundle.mainBundle;
    return [[bundle loadNibNamed:NSStringFromClass(self)
                           owner:nil
                         options:nil] firstObject];
}

/// add && remove (return itself)
- (instancetype) mq_add : (__kindof UIView *) view {
    if (view) [self addSubview:view];
    return self;
}
- (void)mq_remove_from : (void (^)(__kindof UIView *)) action {
    if (action) action(self.superview);
    if (self.superview) [self removeFromSuperview];
}
- (instancetype) mq_bring_to_front : (__kindof UIView *) view {
    if (view && [self.subviews containsObject:view]) [self bringSubviewToFront:view];
    return self;
}
- (instancetype) mq_send_to_back : (__kindof UIView *) view {
    if (view && [self.subviews containsObject:view]) [self sendSubviewToBack:view];
    return self;
}
- (instancetype) mq_make_to_front {
    if (self.superview) [self.superview bringSubviewToFront:self];
    return self;
}
- (instancetype) mq_make_to_back {
    if (self.superview) [self.superview sendSubviewToBack:self];
    return self;
}

/// enable / disable userinteraction
- (instancetype) mq_enable {
    self.userInteractionEnabled = YES;
    return self;
}
- (instancetype) mq_disable {
    self.userInteractionEnabled = false;
    return self;
}

/// color && cornerRadius && contentMode
- (instancetype) mq_color : (UIColor *) color {
    self.layer.backgroundColor = color ? color.CGColor : UIColor.clearColor.CGColor;
    return self;
}
- (instancetype) mq_radius : (CGFloat) fRadius
                     masks : (BOOL) isMask {
    self.layer.cornerRadius = fRadius;
    self.layer.masksToBounds = isMask;
    return self;
}
- (instancetype) mq_round_corner : (UIRectCorner) corner
                          radius : (CGFloat) fRadius {
    UIBezierPath *p = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                            byRoundingCorners:corner
                                                  cornerRadii:CGSizeMake(MQScaleW(fRadius), MQScaleH(fRadius))];
    CAShapeLayer *l = [[CAShapeLayer alloc] init];
    l.frame = self.bounds;
    l.path = p.CGPath;
    self.layer.mask = l;
    return self;
}
- (instancetype) mq_content_mode : (UIViewContentMode) mode {
    self.contentMode = mode;
    return self;
}

- (instancetype) mq_duplicate {
    NSData * dt = [NSKeyedArchiver archivedDataWithRootObject:self];
    return [NSKeyedUnarchiver unarchiveObjectWithData:dt];
}

- (CGRect) mq_location_in_window {
    UIWindow * window = UIApplication.sharedApplication.delegate.window;
    CGRect rect = [self convertRect:self.bounds
                             toView:window];
    return rect;
}

- (UIImage *) mq_capture_image_after_screen_updates : (BOOL) is_after_updates {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:is_after_updates];
    UIImage *t = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return t;
}

@end

#pragma mark - -----

@implementation UIView (MQExtension_Delay_Operate)

- (instancetype) mq_cold : (NSTimeInterval) interval {
    return [self mq_cold:YES time:interval complete:nil];
}

- (instancetype) mq_hot : (NSTimeInterval) interval {
    return [self mq_cold:false time:interval complete:nil];
}

- (instancetype) mq_cold : (BOOL) is_cold
                    time : (NSTimeInterval) interval
                complete : (void(^)(__kindof UIView *v_t , BOOL is_enable)) mq_complete_block {
    
    self.userInteractionEnabled = !is_cold ;
    __weak typeof(self) weak_self = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong typeof(weak_self) strong_self = weak_self;
        strong_self.userInteractionEnabled = is_cold;
        if (mq_complete_block) mq_complete_block(strong_self , strong_self.userInteractionEnabled);
    });
    
    return self;
}

@end
