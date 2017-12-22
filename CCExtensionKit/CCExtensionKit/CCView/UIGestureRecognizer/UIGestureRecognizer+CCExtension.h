//
//  UIGestureRecognizer+CCExtension.h
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 06/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIGestureRecognizer (CCExtension)

+ (instancetype) common ;

- (instancetype) ccAction : (void(^)( __kindof UIGestureRecognizer *gr)) action ;
- (instancetype) ccTarget : (id) target
                   action : (void(^)( __kindof UIGestureRecognizer *gr)) action ;

@end

#pragma mark - -----

@interface UITapGestureRecognizer (CCExtension)

/// default 1 tap // 默认点击 1 次
- (instancetype) ccTap : (void(^)(UITapGestureRecognizer *tapGR)) action ;
- (instancetype) ccTap : (NSInteger) iCount
                action : (void(^)(UITapGestureRecognizer *tapGR)) action ;

@end

#pragma mark - -----

@interface UILongPressGestureRecognizer (CCExtension)

/// default .5f seconds // 默认 0.5 秒
- (instancetype) ccPress : (void(^)(UILongPressGestureRecognizer *pressGR)) action ;
- (instancetype) ccPress : (CGFloat) fSeconds
                  action : (void(^)(UILongPressGestureRecognizer *pressGR)) action ;

@end

#pragma mark - -----

@interface UIView (CCExtension_Gesture_Actions)

/// for gesture actions // 添加手势动作
- (instancetype) ccGesture : (__kindof UIGestureRecognizer *) gesture ;
- (instancetype) ccTap : (void(^)( __kindof UIView *v , __kindof UITapGestureRecognizer *gr)) action ;
- (instancetype) ccTap : (NSInteger) iCount
                action : (void(^)( __kindof UIView *v , __kindof UITapGestureRecognizer *gr)) action ;
- (instancetype) ccPress : (void(^)(__kindof UIView *v , __kindof UILongPressGestureRecognizer *gr)) action ;
- (instancetype) ccPress : (CGFloat) fSeconds
                  action : (void(^)(__kindof UIView *v , __kindof UILongPressGestureRecognizer *gr)) action ;

@end

#pragma mark - -----

@interface UIViewController (CCExtension_Gesture_Actions)

/// make modaled controller can trigger pop action like UINavigationController. // 使得 模态出的控制器可以像导航控制器那样 pop
/// highly recommend use it with [instance ccEnablePushingPopingStyleWhenPresentOrDismiss] . // 建议和 "[instance ccEnablePushingPopingStyleWhenPresentOrDismiss]" 一起使用
- (instancetype) ccModalPopGesture : (void(^)(__kindof UIViewController *sender ,
                                              __kindof UIScreenEdgePanGestureRecognizer *edgePanGR)) bEdgePanGR ;

@end
