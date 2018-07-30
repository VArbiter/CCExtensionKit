//
//  UIView+MQExtension.m
//  MQExtensionKit
//
//  Created by 冯明庆 on 2017/3/28.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UIView+MQExtension.h"
#import "UIGestureRecognizer+MQExtension.h"

static CGFloat _MQ_DEFAULT_SCALE_WIDTH_ = 750.f;
static CGFloat _MQ_DEFAULT_SCALE_HEIGHT_ = 1334.f;
CGFloat const _MQ_DEFAULT_ANIMATION_COMMON_DURATION_ = .3f;

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
+ (void) mq_set_scale : (CGFloat) fWidth
             height : (CGFloat) fHeight {
    _MQ_DEFAULT_SCALE_WIDTH_ = fWidth;
    _MQ_DEFAULT_SCALE_HEIGHT_ = fHeight;
}

+ (void) mq_disable_animation : (void (^)(void)) action {
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

- (instancetype) mq_frame : (CGRect) frame {
    self.frame = frame;
    return self;
}
- (instancetype) mq_size : (CGSize) size {
    self.size = size;
    return self;
}
- (instancetype) mq_origin : (CGPoint) point {
    self.origin = point;
    return self;
}

- (instancetype) mq_width : (CGFloat) fWidth {
    self.width = fWidth;
    return self;
}
- (instancetype) mq_height : (CGFloat) fHeight {
    self.height = fHeight;
    return self;
}

- (instancetype) mq_x : (CGFloat) fX {
    self.x = fX;
    return self;
}
- (instancetype) mq_y : (CGFloat) fY {
    self.y = fY;
    return self;
}

- (instancetype) mq_center_x : (CGFloat) fCenterX {
    self.center_x = fCenterX;
    return self;
}
- (instancetype) mq_center_y : (CGFloat) fCenterY {
    self.center_y = fCenterY;
    return self;
}
- (instancetype) mq_center : (CGPoint) pCenter {
    self.center = pCenter;
    return self;
}

- (instancetype) mq_top : (CGFloat) fTop {
    self.top = fTop;
    return self;
}
- (instancetype) mq_left : (CGFloat) fLeft {
    self.left = fLeft;
    return self;
}
- (instancetype) mq_bottom : (CGFloat) fBottom {
    self.bottom = fBottom;
    return self;
}
- (instancetype) mq_right : (CGFloat) fRight {
    self.right = fRight;
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

@implementation UIView (MQExtension_FitHeight)

CGFloat MQ_TEXT_HEIGHT_S(CGFloat fWidth , CGFloat fEstimateHeight , NSString *string) {
    return MQ_TEXT_HEIGHT_C(fWidth,
                            fEstimateHeight ,
                            string,
                            [UIFont systemFontOfSize:UIFont.systemFontSize],
                            NSLineBreakByWordWrapping);
}
CGFloat MQ_TEXT_HEIGHT_C(CGFloat fWidth ,
                         CGFloat fEstimateHeight ,
                         NSString *string ,
                         UIFont *font ,
                         NSLineBreakMode mode) {
    return MQ_TEXT_HEIGHT_AS(fWidth,
                             fEstimateHeight,
                             string,
                             font,
                             mode,
                             -1,
                             -1);
}

CGFloat MQ_TEXT_HEIGHT_A(CGFloat fWidth , CGFloat fEstimateHeight , NSAttributedString *aString) {
    CGRect rect = [aString boundingRectWithSize:(CGSize){fWidth , CGFLOAT_MAX}
                                        options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                        context:nil];
    return rect.size.height >= fEstimateHeight ? rect.size.height : fEstimateHeight;
}
CGFloat MQ_TEXT_HEIGHT_AS(CGFloat fWidth ,
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
