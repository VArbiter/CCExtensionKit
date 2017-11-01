//
//  UIViewController+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/5.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (CCExtension) < UIViewControllerTransitioningDelegate >

/// remove all animated for pushing && presenting .
- (instancetype) ccDisableAnimated ;
- (instancetype) ccEnableAnimated ;

/// first detect if nagvigation pop back enable ,
/// then detect if dismiss enable .
/// respose the first findout .

- (void) ccGoBack ;
- (void) ccDismiss ;
- (void) ccDismiss : (CGFloat) fDelay ;
- (void) ccDismiss : (CGFloat) fDelay
          complete : (void(^)(void)) complete ;

- (void) ccPop ;
- (void) ccPopTo : (__kindof UIViewController *) controller ;
- (void) ccPopToRoot ;

/// default enable animated && Hide bottom bar
- (instancetype) ccPush : (__kindof UIViewController *) controller ;
- (instancetype) ccPush : (__kindof UIViewController *) controller
             hideBottom : (BOOL) isHide ;

- (instancetype) ccPresent : (__kindof UIViewController *) controller ;
- (instancetype) ccPresent : (__kindof UIViewController *) controller
                  complete : (void (^)(void)) complete ;
/// clear color == backgroundColor
- (instancetype) ccPresentClear : (__kindof UIViewController *) controller
                       complete : (void (^)(void)) complete;

/// deafult enable animated , fade in , fade out .
- (instancetype) ccAddViewFrom : (__kindof UIViewController *) controller
                      duration : (CGFloat) fAnimationDuration ;

/// note : [UIApplication sharedApplication].delegate.window is the super view
+ (void) ccCoverViewWith : (__kindof UIViewController *) controller
                animated : (BOOL) isAminated
                duration : (CGFloat) fAnimationDuration ;

/// current controller that shows on screen . (only the main window)
+ (__kindof UIViewController *) ccCurrent ;
+ (__kindof UIViewController *) ccRootViewController ;
+ (__kindof UINavigationController *) ccCurrentNavigationController;
+ (__kindof UIViewController *) ccCurrentFrom : (UIViewController *) controller ;

/// when have muti windows .
+ (__kindof UIViewController *) ccWindowedCurrentController ;

/// make present modeled push / dismiss modeled pop
/// only works in present .
/// note : deply it in the controller is about to presented . not the presenting one .
- (instancetype) ccEnablePushingPopingStyleWhenPresentOrDismiss ;

@end

#pragma mark - -----

@interface CCAnimatedTransitionPresent : NSObject < UIViewControllerAnimatedTransitioning >

@property (nonatomic , assign) NSTimeInterval intervalDuration ;
@property (nonatomic , copy) NSString * sAnimationType; // default kCATransitionFromRight

@end

#pragma mark - -----

@interface CCAnimatedTransitionDismiss : NSObject < UIViewControllerAnimatedTransitioning >

@property (nonatomic , assign) NSTimeInterval intervalDuration ;
@property (nonatomic , assign , getter=isDirectionRight) BOOL directionRight; // default YES

@end
