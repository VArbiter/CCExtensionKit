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
@property (nonatomic , strong , readwrite) UIView *viewCustom ;
@property (nonatomic , assign , readwrite) UIView *viewOn ;
@property (nonatomic , strong , readwrite) CALayer *layerAnim ;

@end

@implementation MQDropAlertView

- (instancetype) initWithView : (__kindof UIView *) view {
    return [self initWithView:view
                       showOn:UIApplication.sharedApplication.delegate.window];
}

- (instancetype) initWithView : (__kindof UIView *) view
                       showOn : (__kindof UIView *) viewOn {
    if (!view || !viewOn) return nil;
    if ((self = [super initWithFrame:viewOn.bounds])) {
        self.enableOffEdgePop = false;
        self.viewCustom = view;
        self.viewOn = viewOn;
        self.layer.backgroundColor = [UIColor.blackColor mq_alpha:.2f].CGColor;
        [self mq_add:[[self.viewCustom mq_bottom:self.top] mq_center_x:self.in_center_x]];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.isEnableOffEdgePop) return ;
    UITouch *touch = touches.anyObject;
    CGPoint p = [touch locationInView:self];
    if (!CGRectContainsPoint(self.viewCustom.frame , p)) {
        [self mq_dismiss];
    }
}

- (void) mq_show {
    [self mq_show:MQDropAnimate_Smooth];
}

- (void) mq_show : (MQDropAnimate) animate {
    [self.viewOn addSubview:self];
    
    if (self.block_action_start) self.block_action_start(self);
    
    switch (animate) {
        case MQDropAnimate_None:{
            self.viewCustom.center = self.in_center;
            if (self.block_action_start_did_end) self.block_action_start_did_end(self);
        }break;
        case MQDropAnimate_Smooth:{
            MQ_WEAK_SELF;
            void (^bCenter)(void) = ^ {
                [UIView animateWithDuration:.2f animations:^{
                    weak_self.viewCustom.center = weak_self.in_center;
                    if (weak_self.block_action_start_did_end) weak_self.block_action_start_did_end(weak_self);
                }];
            };
            
            [UIView animateWithDuration:MQ_DROP_ANIMATION_DURATION animations:^{
                weak_self.alpha = 1.0f;
                weak_self.viewCustom.center = (CGPoint){weak_self.in_center_x , weak_self.in_center_y + MQScaleH(80.f)};
            } completion:^(BOOL finished) {
                if (bCenter) bCenter();
            }];
        }break;
        case MQDropAnimate_Snap:{
            MQ_WEAK_SELF;
            [UIView animateWithDuration:MQ_DROP_ANIMATION_DURATION animations:^{
                weak_self.alpha = 1.0f;
            } completion:^(BOOL finished) {
                if (weak_self.block_action_start_did_end) weak_self.block_action_start_did_end(weak_self);
            }];
            
            UISnapBehavior *snapBehaviour = [[UISnapBehavior alloc] initWithItem:self.viewCustom
                                                                     snapToPoint:self.viewOn.in_center];
            snapBehaviour.damping = MQ_SNAP_DAMPING_DURATION;
            [self.animator addBehavior:snapBehaviour];
        }break;
            
        default:{
            self.viewCustom.center = self.in_center;
        }break;
    }
}

- (void) mq_dismiss {
    [self mq_dismiss:MQDropAnimate_Snap];
}
- (void) mq_dismiss : (MQDropAnimate) animate {
    
    MQ_WEAK_SELF;
    void (^bDismiss)(void) = ^ {
        [UIView animateWithDuration:MQ_DROP_ANIMATION_DURATION animations:^{
            weak_self.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [weak_self removeFromSuperview];
            if (weak_self.block_action_did_end) weak_self.block_action_did_end(weak_self);
        }];
    };
    
    void (^bAddGravity)(void) = ^ {
        UIGravityBehavior *gravityBehaviour = [[UIGravityBehavior alloc] initWithItems:@[weak_self.viewCustom]];
        gravityBehaviour.gravityDirection = CGVectorMake(0.0f, 10.0f);
        [weak_self.animator addBehavior:gravityBehaviour];
    };
    
    switch (animate) {
        case MQDropAnimate_None:{
            if (bDismiss) bDismiss();
        }break;
        case MQDropAnimate_Smooth:{
            [self.animator removeAllBehaviors];
            if (bAddGravity) bAddGravity();
            if (bDismiss) bDismiss();
        }break;
        case MQDropAnimate_Snap:{
            [self.animator removeAllBehaviors];
            if (bAddGravity) bAddGravity();
            UIDynamicItemBehavior *itemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[self.viewCustom]];
            [itemBehaviour addAngularVelocity:(- M_PI_2)
                                      forItem:self.viewCustom];
            [self.animator addBehavior:itemBehaviour];
            if (bDismiss) bDismiss();
        }break;
            
        default:{
            if (bDismiss) bDismiss();
        }break;
    }
}

- (void) mq_set_shadow : (UIColor *) color
                 alpha : (CGFloat) fAlpha {
    if (color
        && [color isKindOfClass:UIColor.class]
        && fAlpha >= 0
        && fAlpha <= 1) {
        self.layer.backgroundColor = [color mq_alpha:fAlpha].CGColor;
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

_MQ_DETECT_DEALLOC_

@end
