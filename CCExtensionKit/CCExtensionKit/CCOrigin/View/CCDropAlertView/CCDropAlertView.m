//
//  CCDropAlertView.m
//  CCQueueDropAlertController_Example
//
//  Created by 冯明庆 on 04/12/2017.
//  Copyright © 2017 elwin_frederick. All rights reserved.
//

#import "CCDropAlertView.h"

#import "UIView+CCExtension.h"
#import "UIColor+CCExtension.h"
#import "CCCommon.h"

CGFloat CC_DROP_ANIMATION_DURATION = .4f;
CGFloat CC_SNAP_DAMPING_DURATION = .85f;

@interface CCDropAlertView () < UIDynamicAnimatorDelegate >

@property (nonatomic , strong , readwrite) UIDynamicAnimator *animator ;
@property (nonatomic , strong , readwrite) UIView *viewCustom ;
@property (nonatomic , assign , readwrite) UIView *viewOn ;
@property (nonatomic , strong , readwrite) CALayer *layerAnim ;

@end

@implementation CCDropAlertView

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
        self.layer.backgroundColor = [UIColor.blackColor cc_alpha:.2f].CGColor;
        [self cc_add:[[self.viewCustom cc_bottom:self.top] cc_center_x:self.inCenterX]];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.isEnableOffEdgePop) return ;
    UITouch *touch = touches.anyObject;
    CGPoint p = [touch locationInView:self];
    if (!CGRectContainsPoint(self.viewCustom.frame , p)) {
        [self cc_dismiss];
    }
}

- (void) cc_show {
    [self cc_show:CCDropAnimate_Smooth];
}

- (void) cc_show : (CCDropAnimate) animate {
    [self.viewOn addSubview:self];
    
    if (self.block_action_start) self.block_action_start(self);
    
    switch (animate) {
        case CCDropAnimate_None:{
            self.viewCustom.center = self.inCenter;
            if (self.block_action_start_did_end) self.block_action_start_did_end(self);
        }break;
        case CCDropAnimate_Smooth:{
            CC_WEAK_SELF;
            void (^bCenter)(void) = ^ {
                [UIView animateWithDuration:.2f animations:^{
                    weak_self.viewCustom.center = weak_self.inCenter;
                    if (weak_self.block_action_start_did_end) weak_self.block_action_start_did_end(weak_self);
                }];
            };
            
            [UIView animateWithDuration:CC_DROP_ANIMATION_DURATION animations:^{
                weak_self.alpha = 1.0f;
                weak_self.viewCustom.center = (CGPoint){weak_self.inCenterX , weak_self.inCenterY + CCScaleH(80.f)};
            } completion:^(BOOL finished) {
                if (bCenter) bCenter();
            }];
        }break;
        case CCDropAnimate_Snap:{
            CC_WEAK_SELF;
            [UIView animateWithDuration:CC_DROP_ANIMATION_DURATION animations:^{
                weak_self.alpha = 1.0f;
            } completion:^(BOOL finished) {
                if (weak_self.block_action_start_did_end) weak_self.block_action_start_did_end(weak_self);
            }];
            
            UISnapBehavior *snapBehaviour = [[UISnapBehavior alloc] initWithItem:self.viewCustom
                                                                     snapToPoint:self.viewOn.inCenter];
            snapBehaviour.damping = CC_SNAP_DAMPING_DURATION;
            [self.animator addBehavior:snapBehaviour];
        }break;
            
        default:{
            self.viewCustom.center = self.inCenter;
        }break;
    }
}

- (void) cc_dismiss {
    [self cc_dismiss:CCDropAnimate_Snap];
}
- (void) cc_dismiss : (CCDropAnimate) animate {
    
    CC_WEAK_SELF;
    void (^bDismiss)(void) = ^ {
        [UIView animateWithDuration:CC_DROP_ANIMATION_DURATION animations:^{
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
        case CCDropAnimate_None:{
            if (bDismiss) bDismiss();
        }break;
        case CCDropAnimate_Smooth:{
            [self.animator removeAllBehaviors];
            if (bAddGravity) bAddGravity();
            if (bDismiss) bDismiss();
        }break;
        case CCDropAnimate_Snap:{
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

- (void) cc_set_shadow : (UIColor *) color
                 alpha : (CGFloat) fAlpha {
    if (color
        && [color isKindOfClass:UIColor.class]
        && fAlpha >= 0
        && fAlpha <= 1) {
        self.layer.backgroundColor = [color cc_alpha:fAlpha].CGColor;
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

_CC_DETECT_DEALLOC_

@end
