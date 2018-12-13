//
//  UIGestureRecognizer+MQExtension.m
//  MQExtensionKit
//
//  Created by Elwinfrederick on 06/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "UIGestureRecognizer+MQExtension.h"

#import <objc/runtime.h>

static const char * MQ_UIGESTURERECOGNIZER_ASSOCIATE_KEY = "MQ_UIGESTURERECOGNIZER_ASSOCIATE_KEY";

@interface UIGestureRecognizer (MQExtension_Assit)

- (void) mq_gesture_extension_action : ( __kindof UIGestureRecognizer *) sender ;

@end

@implementation UIGestureRecognizer (MQExtension_Assit)

- (void)mq_gesture_extension_action:( __kindof UIGestureRecognizer *)sender {
    UIGestureRecognizer *(^t)( __kindof UIGestureRecognizer *) = objc_getAssociatedObject(self, MQ_UIGESTURERECOGNIZER_ASSOCIATE_KEY);
    if (t) {
        if (NSThread.isMainThread) t(self);
        else {
            __weak typeof(self) weak_self = self;
            dispatch_sync(dispatch_get_main_queue(), ^{
                t(weak_self);
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
    if (action) objc_setAssociatedObject(self, MQ_UIGESTURERECOGNIZER_ASSOCIATE_KEY, action, OBJC_ASSOCIATION_COPY_NONATOMIC);
    return self;
}
- (instancetype) mq_target : (id) target
                   action : (void(^)( __kindof UIGestureRecognizer *gr)) action {
    [self mq_action:action];
    [self addTarget:target
             action:@selector(mq_gesture_extension_action:)];
    return self;
}

@end

#pragma mark - -----

@implementation UITapGestureRecognizer (MQExtension)

- (instancetype) mq_tap : (void(^)(UITapGestureRecognizer *tap_gr)) action {
    return [self mq_tap:1 action:action];
}
- (instancetype) mq_tap : (NSInteger) i_count
                 action : (void(^)(UITapGestureRecognizer *tap_gr)) action {
    self.numberOfTapsRequired = i_count;
    [self mq_target:self action:action];
    return self;
}

@end

#pragma mark - -----

@implementation UILongPressGestureRecognizer (MQExtension)

- (instancetype) mq_press : (void(^)(UILongPressGestureRecognizer *press_gr)) action {
    return [self mq_press:.5f action:action];
}
- (instancetype) mq_press : (CGFloat) f_seconds
                   action : (void(^)(UILongPressGestureRecognizer *press_gr)) action {
    self.numberOfTapsRequired = 1;
    self.minimumPressDuration = f_seconds;
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
- (instancetype) mq_tap : (NSInteger) i_count
                 action : (void(^)( __kindof UIView *v , __kindof UITapGestureRecognizer *gr)) action {
    self.userInteractionEnabled = YES;
    __weak typeof(self) weak_self = self;
    return [self mq_gesture:[UITapGestureRecognizer.mq_common mq_tap:i_count action:^(UITapGestureRecognizer *tap_gr) {
        if (action) action(weak_self , tap_gr);
    }]];
}
- (instancetype) mq_press : (void(^)(__kindof UIView *v , __kindof UILongPressGestureRecognizer *gr)) action {
    return [self mq_press:.5f action:action];
}
- (instancetype) mq_press : (CGFloat) f_seconds
                   action : (void(^)(__kindof UIView *v , __kindof UILongPressGestureRecognizer *gr)) action {
    self.userInteractionEnabled = YES;
    __weak typeof(self) weak_self = self;
    return [self mq_gesture:[UILongPressGestureRecognizer.mq_common mq_press:f_seconds action:^(UILongPressGestureRecognizer *press_gr) {
        if (action) action(weak_self , press_gr);
    }]];
}

@end

#pragma mark - -----

static const char * MQ_UI_SCREEN_EDGE_PAN_GESTURE_RECOGNIZER_UICONTROLLER_BLOCK_ASSOCIATE_KEY = "MQ_UI_SCREEN_EDGE_PAN_GESTURE_RECOGNIZER_UICONTROLLER_BLOCK_ASSOCIATE_KEY";

@interface UIViewController (MQExtension_Gesture_Actions_Assit)

@property (nonatomic , strong) UIScreenEdgePanGestureRecognizer *screen_edge_pan_gr ;
- (void) mq_screen_edge_pan_gesture_action : (UIScreenEdgePanGestureRecognizer *) sender ;

@end

@implementation UIViewController (MQExtension_Gesture_Actions_Assit)

- (void)setScreen_edge_pan_gr:(UIScreenEdgePanGestureRecognizer *)screen_edge_pan_gr {
    objc_setAssociatedObject(self,
                             "MQ_UI_SCREEN_EDGE_PAN_GESTURE_RECOGNIZER_UICONTROLLER_ASSOCIATE_KEY",
                             screen_edge_pan_gr,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIScreenEdgePanGestureRecognizer *)screen_edge_pan_gr {
    return objc_getAssociatedObject(self, "MQ_UI_SCREEN_EDGE_PAN_GESTURE_RECOGNIZER_UICONTROLLER_ASSOCIATE_KEY");
}

- (void) mq_screen_edge_pan_gesture_action : (UIScreenEdgePanGestureRecognizer *) sender {
    void(^t)(__kindof UIViewController *sender , __kindof UIScreenEdgePanGestureRecognizer *edge_pan_gr) = objc_getAssociatedObject(self, MQ_UI_SCREEN_EDGE_PAN_GESTURE_RECOGNIZER_UICONTROLLER_BLOCK_ASSOCIATE_KEY);
    if (t) {
        if (NSThread.isMainThread) t(self,sender);
        else {
            __weak typeof(self) weak_self = self;
            dispatch_sync(dispatch_get_main_queue(), ^{
                t(weak_self,sender);
            });
        }
    }
}

@end

@implementation UIViewController (MQExtension_Gesture_Actions)

- (instancetype) mq_modal_pop_gesture : (void(^)(__kindof UIViewController *sender ,
                                              __kindof UIScreenEdgePanGestureRecognizer *edgePanGR)) block_edge_pan_gr {
    objc_setAssociatedObject(self,
                             MQ_UI_SCREEN_EDGE_PAN_GESTURE_RECOGNIZER_UICONTROLLER_BLOCK_ASSOCIATE_KEY,
                             block_edge_pan_gr,
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
    if (self.screen_edge_pan_gr) {
        [self.screen_edge_pan_gr removeTarget:self action:@selector(mq_screen_edge_pan_gesture_action:)];
        [self.view removeGestureRecognizer:self.screen_edge_pan_gr];
        self.screen_edge_pan_gr = nil;
    }
    else {
        UIScreenEdgePanGestureRecognizer *gr = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(mq_screen_edge_pan_gesture_action:)];
        gr.edges = UIRectEdgeLeft;
        self.screen_edge_pan_gr = gr;
    }
    [self.view addGestureRecognizer:self.screen_edge_pan_gr];
    return self;
}

@end
