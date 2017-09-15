//
//  UIGestureRecognizer+CCExtension.m
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 06/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "UIGestureRecognizer+CCExtension.h"

#import <objc/runtime.h>

static const char * _CC_UIGESTURERECOGNIZER_ASSOCIATE_KEY_ = "CC_UIGESTURERECOGNIZER_ASSOCIATE_KEY";

@interface UIGestureRecognizer (CCExtension_Assit)

- (void) ccGestureExtensionAction : ( __kindof UIGestureRecognizer *) sender ;

@end

@implementation UIGestureRecognizer (CCExtension_Assit)

- (void)ccGestureExtensionAction:( __kindof UIGestureRecognizer *)sender {
    UIGestureRecognizer *(^t)( __kindof UIGestureRecognizer *) = objc_getAssociatedObject(self, _CC_UIGESTURERECOGNIZER_ASSOCIATE_KEY_);
    if (t) {
        if (NSThread.isMainThread) t(self);
        else {
            __weak typeof(self) pSelf = self;
            dispatch_sync(dispatch_get_main_queue(), ^{
                t(pSelf);
            });
        }
    }
}

@end

#pragma mark - -----

@implementation UIGestureRecognizer (CCExtension)

+ (instancetype) common {
    return [[self alloc] init];
}

- (instancetype) ccAction : (void(^)( __kindof UIGestureRecognizer *gr)) action {
    if (action) objc_setAssociatedObject(self, _CC_UIGESTURERECOGNIZER_ASSOCIATE_KEY_, action, OBJC_ASSOCIATION_COPY_NONATOMIC);
    return self;
}
- (instancetype) ccTarget : (id) target
                   action : (void(^)( __kindof UIGestureRecognizer *gr)) action {
    [self ccAction:action];
    [self addTarget:target
             action:@selector(ccGestureExtensionAction:)];
    return self;
}

@end

#pragma mark - -----

@implementation UITapGestureRecognizer (CCExtension)

- (instancetype) ccTap : (void(^)(UITapGestureRecognizer *tapGR)) action {
    return [self ccTap:1 action:action];
}
- (instancetype) ccTap : (NSInteger) iCount
                action : (void(^)(UITapGestureRecognizer *tapGR)) action {
    self.numberOfTapsRequired = iCount;
    [self ccTarget:self action:action];
    return self;
}

@end

#pragma mark - -----

@implementation UILongPressGestureRecognizer (CCExtension)

- (instancetype) ccPress : (void(^)(UILongPressGestureRecognizer *pressGR)) action {
    return [self ccPress:.5f action:action];
}
- (instancetype) ccPress : (CGFloat) fSeconds
                  action : (void(^)(UILongPressGestureRecognizer *pressGR)) action {
    self.numberOfTapsRequired = 1;
    self.minimumPressDuration = fSeconds;
    [self ccTarget:self action:action];
    return self;
}

@end

#pragma mark - -----

@implementation UIView (CCExtension_Gesture_Actions)

/// for gesture actions
- (instancetype) ccGesture : (__kindof UIGestureRecognizer *) gesture {
    self.userInteractionEnabled = YES;
    if (gesture) [self addGestureRecognizer:gesture];
    return self;
}
- (instancetype) ccTap : (void(^)( __kindof UIView *v , __kindof UITapGestureRecognizer *gr)) action {
    return [self ccTap:1 action:action];
}
- (instancetype) ccTap : (NSInteger) iCount
                action : (void(^)( __kindof UIView *v , __kindof UITapGestureRecognizer *gr)) action {
    __weak typeof(self) pSelf = self;
    self.userInteractionEnabled = YES;
    return [self ccGesture:[UITapGestureRecognizer.common ccTap:1 action:^(UITapGestureRecognizer *tapGR) {
        if (action) action(pSelf , tapGR);
    }]];
}
- (instancetype) ccPress : (void(^)(__kindof UIView *v , __kindof UILongPressGestureRecognizer *gr)) action {
    return [self ccPress:.5f action:action];
}
- (instancetype) ccPress : (CGFloat) fSeconds
                  action : (void(^)(__kindof UIView *v , __kindof UILongPressGestureRecognizer *gr)) action {
    __weak typeof(self) pSelf = self;
    self.userInteractionEnabled = YES;
    return [self ccGesture:[UILongPressGestureRecognizer.common ccPress:fSeconds action:^(UILongPressGestureRecognizer *pressGR) {
        if (action) action(pSelf , pressGR);
    }]];
}

@end
