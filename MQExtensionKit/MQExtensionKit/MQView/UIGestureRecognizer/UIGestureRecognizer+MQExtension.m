//
//  UIGestureRecognizer+MQExtension.m
//  MQExtensionKit
//
//  Created by Elwinfrederick on 06/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "UIGestureRecognizer+MQExtension.h"

#import <objc/runtime.h>

static const char * _CC_UIGESTURERECOGNIZER_ASSOCIATE_KEY_ = "CC_UIGESTURERECOGNIZER_ASSOCIATE_KEY";

@interface UIGestureRecognizer (MQExtension_Assit)

- (void) ccGestureExtensionAction : ( __kindof UIGestureRecognizer *) sender ;

@end

@implementation UIGestureRecognizer (MQExtension_Assit)

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

@implementation UIGestureRecognizer (MQExtension)

+ (instancetype) mq_common {
    return [[self alloc] init];
}

- (instancetype) mq_action : (void(^)( __kindof UIGestureRecognizer *gr)) action {
    if (action) objc_setAssociatedObject(self, _CC_UIGESTURERECOGNIZER_ASSOCIATE_KEY_, action, OBJC_ASSOCIATION_COPY_NONATOMIC);
    return self;
}
- (instancetype) mq_target : (id) target
                   action : (void(^)( __kindof UIGestureRecognizer *gr)) action {
    [self mq_action:action];
    [self addTarget:target
             action:@selector(ccGestureExtensionAction:)];
    return self;
}

@end

#pragma mark - -----

@implementation UITapGestureRecognizer (MQExtension)

- (instancetype) mq_tap : (void(^)(UITapGestureRecognizer *tapGR)) action {
    return [self mq_tap:1 action:action];
}
- (instancetype) mq_tap : (NSInteger) iCount
                 action : (void(^)(UITapGestureRecognizer *tapGR)) action {
    self.numberOfTapsRequired = iCount;
    [self mq_target:self action:action];
    return self;
}

@end

#pragma mark - -----

@implementation UILongPressGestureRecognizer (MQExtension)

- (instancetype) mq_press : (void(^)(UILongPressGestureRecognizer *pressGR)) action {
    return [self mq_press:.5f action:action];
}
- (instancetype) mq_press : (CGFloat) fSeconds
                   action : (void(^)(UILongPressGestureRecognizer *pressGR)) action {
    self.numberOfTapsRequired = 1;
    self.minimumPressDuration = fSeconds;
    [self mq_target:self action:action];
    return self;
}

@end

#pragma mark - -----

@implementation UIView (MQExtension_Gesture_Actions)

/// for gesture actions
- (instancetype) mq_gesture : (__kindof UIGestureRecognizer *) gesture {
    self.userInteractionEnabled = YES;
    if (gesture) [self addGestureRecognizer:gesture];
    return self;
}
- (instancetype) mq_tap : (void(^)( __kindof UIView *v , __kindof UITapGestureRecognizer *gr)) action {
    return [self mq_tap:1 action:action];
}
- (instancetype) mq_tap : (NSInteger) iCount
                 action : (void(^)( __kindof UIView *v , __kindof UITapGestureRecognizer *gr)) action {
    __weak typeof(self) pSelf = self;
    self.userInteractionEnabled = YES;
    return [self mq_gesture:[UITapGestureRecognizer.mq_common mq_tap:1 action:^(UITapGestureRecognizer *tapGR) {
        if (action) action(pSelf , tapGR);
    }]];
}
- (instancetype) mq_press : (void(^)(__kindof UIView *v , __kindof UILongPressGestureRecognizer *gr)) action {
    return [self mq_press:.5f action:action];
}
- (instancetype) mq_press : (CGFloat) fSeconds
                   action : (void(^)(__kindof UIView *v , __kindof UILongPressGestureRecognizer *gr)) action {
    __weak typeof(self) pSelf = self;
    self.userInteractionEnabled = YES;
    return [self mq_gesture:[UILongPressGestureRecognizer.mq_common mq_press:fSeconds action:^(UILongPressGestureRecognizer *pressGR) {
        if (action) action(pSelf , pressGR);
    }]];
}

@end

#pragma mark - -----

static const char * _CC_UI_SCREEN_EDGE_PAN_GESTURE_RECOGNIZER_UICONTROLLER_BLOCK_ASSOCIATE_KEY_ = "CC_UI_SCREEN_EDGE_PAN_GESTURE_RECOGNIZER_UICONTROLLER_BLOCK_ASSOCIATE_KEY";

@interface UIViewController (MQExtension_Gesture_Actions_Assit)

@property (nonatomic , strong) UIScreenEdgePanGestureRecognizer *screenEdgePanGR ;
- (void) ccScreenEdgePanGestureAction : (UIScreenEdgePanGestureRecognizer *) sender ;

@end

@implementation UIViewController (MQExtension_Gesture_Actions_Assit)

- (void)setScreenEdgePanGR:(UIScreenEdgePanGestureRecognizer *)screenEdgePanGR {
    objc_setAssociatedObject(self,
                             "CC_UI_SCREEN_EDGE_PAN_GESTURE_RECOGNIZER_UICONTROLLER_ASSOCIATE_KEY",
                             screenEdgePanGR,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIScreenEdgePanGestureRecognizer *)screenEdgePanGR {
    return objc_getAssociatedObject(self, "CC_UI_SCREEN_EDGE_PAN_GESTURE_RECOGNIZER_UICONTROLLER_ASSOCIATE_KEY");
}

- (void) ccScreenEdgePanGestureAction : (UIScreenEdgePanGestureRecognizer *) sender {
    void(^t)(__kindof UIViewController *sender , __kindof UIScreenEdgePanGestureRecognizer *edgePanGR) = objc_getAssociatedObject(self, _CC_UI_SCREEN_EDGE_PAN_GESTURE_RECOGNIZER_UICONTROLLER_BLOCK_ASSOCIATE_KEY_);
    if (t) {
        if (NSThread.isMainThread) t(self,sender);
        else {
            __weak typeof(self) pSelf = self;
            dispatch_sync(dispatch_get_main_queue(), ^{
                t(pSelf,sender);
            });
        }
    }
}

@end

@implementation UIViewController (MQExtension_Gesture_Actions)

- (instancetype) mq_modal_pop_gesture : (void(^)(__kindof UIViewController *sender ,
                                              __kindof UIScreenEdgePanGestureRecognizer *edgePanGR)) bEdgePanGR {
    objc_setAssociatedObject(self,
                             _CC_UI_SCREEN_EDGE_PAN_GESTURE_RECOGNIZER_UICONTROLLER_BLOCK_ASSOCIATE_KEY_,
                             bEdgePanGR,
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
    if (self.screenEdgePanGR) {
        [self.screenEdgePanGR removeTarget:self action:@selector(ccScreenEdgePanGestureAction:)];
        [self.view removeGestureRecognizer:self.screenEdgePanGR];
        self.screenEdgePanGR = nil;
    }
    else {
        UIScreenEdgePanGestureRecognizer *gr = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(ccScreenEdgePanGestureAction:)];
        gr.edges = UIRectEdgeLeft;
        self.screenEdgePanGR = gr;
    }
    [self.view addGestureRecognizer:self.screenEdgePanGR];
    return self;
}

@end
