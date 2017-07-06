//
//  UIView+CCExtension.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/3/28.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UIView+CCExtension.h"
#import "UITapGestureRecognizer+CCExtension.h"

@implementation UIView (CCExtension)

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

#pragma mark - Method (s)
+ (instancetype) ccViewFromXib {
    return [self ccViewFromXib:nil];
}
+ (instancetype) ccViewFromXib : (NSBundle *) bundle {
    if (!bundle) bundle = NSBundle.mainBundle;
    return [[bundle loadNibNamed:NSStringFromClass(self)
                           owner:nil
                         options:nil] firstObject];
}

- (void) ccAddTap : (dispatch_block_t) block {
    return [self ccAddTap:1
                   action:block];
}
- (void) ccAddTap : (NSInteger) iTaps
           action : (dispatch_block_t) block {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initByTaps:iTaps action:^{
        if (block) {
            if ([NSThread isMainThread]) {
                block();
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block();
                });
            }
        }
    }];
    [self addGestureRecognizer:tapGR];
}

@end

#pragma mark - CCHudAlert ------------------------------------------------------

@implementation UIView (CCHudAlert)

- (BOOL)isHasHud {
    return [MBProgressHUD ccIsCurrentHasHud:self];
}

- (MBProgressHUD *) ccShowIndicator {
    return [self ccShowIndicator:CCHudTypeNone];
}
- (MBProgressHUD *) ccShowIndicator : (CCHudType) type {
    return [self ccShowIndicator:type message:nil];
}
- (MBProgressHUD *) ccShowIndicator : (CCHudType) type
                            message : (NSString *) stringMessage {
    return [MBProgressHUD ccShowIndicator:-1
                                     with:self
                                    title:nil
                                  message:stringMessage
                                     type:type];
}

- (MBProgressHUD *) ccShow : (NSString *) stringMessage {
    return [self ccShow:stringMessage
                   type:CCHudTypeNone];
}
- (MBProgressHUD *) ccShow : (NSString *) stringMessage
                      type : (CCHudType) type {
    return [MBProgressHUD ccShowMessage:stringMessage
                                   type:type
                                   with:self];
}

- (void) ccHide {
    [MBProgressHUD ccHideAllFor:self];
}

@end
