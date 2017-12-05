//
//  CCDropAlertContentView.m
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

@end

@implementation CCDropAlertView

- (instancetype) initWithView : (__kindof UIView *) view {
    if (!view) return nil;
    if ((self = [super initWithFrame:UIApplication.sharedApplication.delegate.window.frame])) {
        self.viewCustom = view;
        self.layer.backgroundColor = [UIColor.blackColor ccAlpha:.2f].CGColor;
        [self ccAdd:[[self.viewCustom ccBottom:self.top] ccCenterX:self.inCenterX]];
    }
    return self;
}

- (void) ccShow {
    UIWindow *window = UIApplication.sharedApplication.delegate.window;
    [window addSubview:self];
    
    if (self.bActionStart) self.bActionStart(self);
    CC_WEAK_SELF;
    [UIView animateWithDuration:CC_DROP_ANIMATION_DURATION animations:^{
        pSelf.alpha = 1.0f;
    }];
    
    UISnapBehavior *snapBehaviour = [[UISnapBehavior alloc] initWithItem:self.viewCustom
                                                             snapToPoint:window.inCenter];
    snapBehaviour.damping = CC_SNAP_DAMPING_DURATION;
    [self.animator addBehavior:snapBehaviour];
}

- (void) ccDismiss {
    [self.animator removeAllBehaviors];
    
    UIGravityBehavior *gravityBehaviour = [[UIGravityBehavior alloc] initWithItems:@[self.viewCustom]];
    gravityBehaviour.gravityDirection = CGVectorMake(0.0f, 10.0f);
    [self.animator addBehavior:gravityBehaviour];
    
    UIDynamicItemBehavior *itemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[self.viewCustom]];
    [itemBehaviour addAngularVelocity:(- M_PI_2)
                              forItem:self.viewCustom];
    [self.animator addBehavior:itemBehaviour];
    
    CC_WEAK_SELF;
    UIWindow *window = UIApplication.sharedApplication.delegate.window;
    [UIView animateWithDuration:CC_DROP_ANIMATION_DURATION animations:^{
        pSelf.alpha = 0.0f;
        window.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
        [window tintColorDidChange];
    } completion:^(BOOL finished) {
        [pSelf removeFromSuperview];
        if (pSelf.bActionDidEnd) pSelf.bActionDidEnd(pSelf);
    }];
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
    if (self.bActionResume) self.bActionResume(self);
}
- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator {
    if (self.bActionPaused) self.bActionPaused(self);
}

_CC_DETECT_DEALLOC_

@end
