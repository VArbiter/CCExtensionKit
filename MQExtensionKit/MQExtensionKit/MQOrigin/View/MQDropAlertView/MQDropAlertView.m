//
//  MQDropAlertView.m
//  MQExtensionKit
//
//  Created by 冯明庆 on 04/12/2017.
//  Copyright © 2017 elwin_frederick. All rights reserved.
//

#import "MQDropAlertView.h"

#import "UIView+MQExtension.h"
#import "UIColor+MQExtension.h"
#import "MQCommon.h"

CGFloat MQ_DROP_ANIMATION_DURATION = .4f;
CGFloat MQ_SNAP_DAMPING_DURATION = .85f;

@interface MQDropAlertView () < UIDynamicAnimatorDelegate >

@property (nonatomic , strong , readwrite) UIDynamicAnimator *animator ;
@property (nonatomic , strong , readwrite) UIView *view_custom ;
@property (nonatomic , assign , readwrite) UIView *view_on ;
@property (nonatomic , strong , readwrite) CALayer *layer_anim ;

@end

@implementation MQDropAlertView

- (instancetype) initWithView : (__kindof UIView *) view {
    return [self initWithView:view
                       showOn:UIApplication.sharedApplication.delegate.window];
}

- (instancetype) initWithView : (__kindof UIView *) view
                       showOn : (__kindof UIView *) view_on {
    if (!view || !view_on) return nil;
    if ((self = [super initWithFrame:view_on.bounds])) {
        self.enable_off_edge_pop = false;
        self.view_custom = view;
        self.view_on = view_on;
        self.layer.backgroundColor = [UIColor.blackColor mq_alpha:.2f].CGColor;
        [self mq_add:[[self.view_custom mq_bottom:self.mq_top] mq_center_x:self.mq_in_center_x]];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.is_enable_off_edge_pop) return ;
    UITouch *touch = touches.anyObject;
    CGPoint p = [touch locationInView:self];
    if (!CGRectContainsPoint(self.view_custom.frame , p)) {
        [self mq_dismiss];
    }
}

- (void) mq_show {
    [self mq_show:MQDropAnimate_Smooth];
}

- (void) mq_show : (MQDropAnimate) animate {
    [self.view_on addSubview:self];
    
    if (self.block_action_start) self.block_action_start(self);
    
    switch (animate) {
        case MQDropAnimate_None:{
            self.view_custom.center = self.mq_in_center;
            if (self.block_action_start_did_end) self.block_action_start_did_end(self);
        }break;
        case MQDropAnimate_Smooth:{
            MQ_WEAK_SELF;
            void (^block_center)(void) = ^ {
                [UIView animateWithDuration:.2f animations:^{
                    weak_self.view_custom.center = weak_self.mq_in_center;
                    if (weak_self.block_action_start_did_end) weak_self.block_action_start_did_end(weak_self);
                }];
            };
            
            [UIView animateWithDuration:MQ_DROP_ANIMATION_DURATION animations:^{
                weak_self.alpha = 1.0f;
                weak_self.view_custom.center = (CGPoint){weak_self.mq_in_center_x , weak_self.mq_in_center_y + MQScaleH(80.f)};
            } completion:^(BOOL finished) {
                if (block_center) block_center();
            }];
        }break;
        case MQDropAnimate_Snap:{
            MQ_WEAK_SELF;
            [UIView animateWithDuration:MQ_DROP_ANIMATION_DURATION animations:^{
                weak_self.alpha = 1.0f;
            } completion:^(BOOL finished) {
                if (weak_self.block_action_start_did_end) weak_self.block_action_start_did_end(weak_self);
            }];
            
            UISnapBehavior *snap_behaviour = [[UISnapBehavior alloc] initWithItem:self.view_custom
                                                                     snapToPoint:self.view_on.mq_in_center];
            snap_behaviour.damping = MQ_SNAP_DAMPING_DURATION;
            [self.animator addBehavior:snap_behaviour];
        }break;
            
        default:{
            self.view_custom.center = self.mq_in_center;
        }break;
    }
}

- (void) mq_dismiss {
    [self mq_dismiss:MQDropAnimate_Snap];
}
- (void) mq_dismiss : (MQDropAnimate) animate {
    
    MQ_WEAK_SELF;
    void (^block_dismiss)(void) = ^ {
        [UIView animateWithDuration:MQ_DROP_ANIMATION_DURATION animations:^{
            weak_self.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [weak_self removeFromSuperview];
            if (weak_self.block_action_did_end) weak_self.block_action_did_end(weak_self);
        }];
    };
    
    void (^block_add_gravity)(void) = ^ {
        UIGravityBehavior *gravity_behaviour = [[UIGravityBehavior alloc] initWithItems:@[weak_self.view_custom]];
        gravity_behaviour.gravityDirection = CGVectorMake(0.0f, 10.0f);
        [weak_self.animator addBehavior:gravity_behaviour];
    };
    
    switch (animate) {
        case MQDropAnimate_None:{
            if (block_dismiss) block_dismiss();
        }break;
        case MQDropAnimate_Smooth:{
            [self.animator removeAllBehaviors];
            if (block_add_gravity) block_add_gravity();
            if (block_dismiss) block_dismiss();
        }break;
        case MQDropAnimate_Snap:{
            [self.animator removeAllBehaviors];
            if (block_add_gravity) block_add_gravity();
            UIDynamicItemBehavior *item_behaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[self.view_custom]];
            [item_behaviour addAngularVelocity:(- M_PI_2)
                                      forItem:self.view_custom];
            [self.animator addBehavior:item_behaviour];
            if (block_dismiss) block_dismiss();
        }break;
            
        default:{
            if (block_dismiss) block_dismiss();
        }break;
    }
}

- (void) mq_set_shadow : (UIColor *) color
                 alpha : (CGFloat) f_alpha {
    if (color
        && [color isKindOfClass:UIColor.class]
        && f_alpha >= 0
        && f_alpha <= 1) {
        self.layer.backgroundColor = [color mq_alpha:f_alpha].CGColor;
    }
}

- (UIDynamicAnimator *)animator {
    if (_animator) return _animator;
    UIDynamicAnimator *a = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    a.delegate = self;
    _animator = a;
    return _animator;
}

#pragma mark - -----
- (void)dynamicAnimatorWillResume:(UIDynamicAnimator *)animator {
    if (self.block_action_resume) self.block_action_resume(self);
}
- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator {
    if (self.block_action_paused) self.block_action_paused(self);
}

MQ_DETECT_DEALLOC

@end
