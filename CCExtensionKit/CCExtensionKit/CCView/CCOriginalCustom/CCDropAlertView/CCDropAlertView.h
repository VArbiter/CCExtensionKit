//
//  CCDropAlertContentView.h
//  CCQueueDropAlertController_Example
//
//  Created by 冯明庆 on 04/12/2017.
//  Copyright © 2017 elwin_frederick. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT CGFloat CC_DROP_ANIMATION_DURATION ;
FOUNDATION_EXPORT CGFloat CC_SNAP_DAMPING_DURATION ;

NS_ASSUME_NONNULL_BEGIN

/// this class makes the custom view drop in , drop out .

@interface CCDropAlertView : UIView

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (instancetype) initWithView : (__kindof UIView *) view ;

@property (nonatomic , strong , readonly) UIDynamicAnimator *animator ;
@property (nonatomic , strong , readonly) UIView *viewCustom ;

/// animation will be started
@property (nonatomic , copy) void (^bActionStart)(CCDropAlertView *sender) ;
/// animation already ended
@property (nonatomic , copy) void (^bActionDidEnd)(CCDropAlertView *sender) ;
/// animation was paused
@property (nonatomic , copy) void (^bActionPaused)(CCDropAlertView *sender) ;
/// animation will be resumed 
@property (nonatomic , copy) void (^bActionResume)(CCDropAlertView *sender) ;

- (void) ccShow ;
- (void) ccDismiss ;

@end

NS_ASSUME_NONNULL_END
