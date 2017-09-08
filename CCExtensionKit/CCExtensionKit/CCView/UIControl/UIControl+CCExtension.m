//
//  UIControl+CCExtension.m
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 08/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "UIControl+CCExtension.h"

#import <objc/runtime.h>

static const char * _CC_UICONTROL_CHAIN_CLICK_ASSOCIATE_KEY_ = "CC_UICONTROL_CHAIN_CLICK_ASSOCIATE_KEY";

@interface UIButton (CCExtension_Assit)

- (void) ccControlChainAction : ( __kindof UIControl *) sender ;

@end

@implementation UIButton (CCExtension_Assit)

- (void) ccControlChainAction : ( __kindof UIControl *) sender {
    void (^t)( __kindof UIControl *) = objc_getAssociatedObject(self, _CC_UICONTROL_CHAIN_CLICK_ASSOCIATE_KEY_);
    if (t) {
        if (NSThread.isMainThread) t(sender);
        else dispatch_sync(dispatch_get_main_queue(), ^{
            t(sender);
        });
    }
}

@end

#pragma mark - -----
static const char * _CC_UIVIEW_ASSOCIATE_HITTEST_TOP_KEY_ = "CC_UIVIEW_ASSOCIATE_HITTEST_TOP_KEY";
static const char * _CC_UIVIEW_ASSOCIATE_HITTEST_LEFT_KEY_ = "CC_UIVIEW_ASSOCIATE_HITTEST_LEFT_KEY";
static const char * _CC_UIVIEW_ASSOCIATE_HITTEST_BOTTOM_KEY_ = "CC_UIVIEW_ASSOCIATE_HITTEST_BOTTOM_KEY";
static const char * _CC_UIVIEW_ASSOCIATE_HITTEST_RIGHT_KEY_ = "CC_UIVIEW_ASSOCIATE_HITTEST_RIGHT_KEY";

@implementation UIControl (CCExtension)

+ (instancetype) common : (CGRect) frame {
    UIControl *c = [[self alloc] initWithFrame:frame];
    c.userInteractionEnabled = YES;
    return c;
}
/// actions , default is touchUpInside
- (instancetype) ccActions : (void (^)( __kindof UIControl *sender)) action {
    return [self ccTarget:self actions:action];
}
- (instancetype) ccTarget : (id) target
                  actions : (void (^)( __kindof UIControl *sender)) action {
    objc_setAssociatedObject(self, _CC_UICONTROL_CHAIN_CLICK_ASSOCIATE_KEY_, action, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:target
              action:@selector(ccControlChainAction:)
    forControlEvents:UIControlEventTouchUpInside];
    return self;
}
/// custom actions .
- (instancetype) ccTarget : (id) target
                 selector : (SEL) sel
                   events : (UIControlEvents) events {
    [self addTarget:(target ? target : self)
              action:sel
    forControlEvents:events];
    return self;
}
/// increase trigger rect .
- (instancetype) ccIncrease : (UIEdgeInsets) insets {
    objc_setAssociatedObject(self, _CC_UIVIEW_ASSOCIATE_HITTEST_TOP_KEY_,
                             @(insets.top), OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, _CC_UIVIEW_ASSOCIATE_HITTEST_LEFT_KEY_,
                             @(insets.left), OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, _CC_UIVIEW_ASSOCIATE_HITTEST_BOTTOM_KEY_,
                             @(insets.bottom), OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, _CC_UIVIEW_ASSOCIATE_HITTEST_RIGHT_KEY_,
                             @(insets.right), OBJC_ASSOCIATION_COPY_NONATOMIC);
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    __weak typeof(self) pSelf = self;
    CGRect (^t)() = ^CGRect {
        NSNumber * top = objc_getAssociatedObject(pSelf, _CC_UIVIEW_ASSOCIATE_HITTEST_TOP_KEY_);
        NSNumber * left = objc_getAssociatedObject(pSelf, _CC_UIVIEW_ASSOCIATE_HITTEST_LEFT_KEY_);
        NSNumber * bottom = objc_getAssociatedObject(pSelf, _CC_UIVIEW_ASSOCIATE_HITTEST_BOTTOM_KEY_);
        NSNumber * right = objc_getAssociatedObject(pSelf, _CC_UIVIEW_ASSOCIATE_HITTEST_RIGHT_KEY_);
        if (top && left && bottom && right) {
            return CGRectMake(pSelf.bounds.origin.x - left.floatValue,
                              pSelf.bounds.origin.y - top.floatValue,
                              pSelf.bounds.size.width + left.floatValue + right.floatValue,
                              pSelf.bounds.size.height + top.floatValue + bottom.floatValue);
        }
        else return pSelf.bounds;
    };
    
    CGRect rect = t();
    if (CGRectEqualToRect(rect, self.bounds)) return [super hitTest:point withEvent:event];
    return CGRectContainsPoint(rect, point) ? self : nil;
}

@end
