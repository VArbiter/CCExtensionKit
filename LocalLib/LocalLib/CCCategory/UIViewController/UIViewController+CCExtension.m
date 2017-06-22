//
//  UIViewController+CCExtension.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/5.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UIViewController+CCExtension.h"
#import <objc/runtime.h>
#import "CCCommonDefine.h"

#if _CC_IS_SIMULATOR_
    #import "MBProgressHUD+CCExtension.h"
#endif

@implementation UIViewController (CCExtension)

- (UIAlertController *) ccAlertWithMessage : (NSString *) stringMessage {
    return [self ccAlertWithTitle:nil
                      withMessage:stringMessage];
}

- (UIAlertController *) ccAlertWithMessage : (NSString *) stringMessage
                                 withDelay : (CGFloat) floatDelay {
    return [self ccAlertWithTitle:nil
                      withMessage:stringMessage
                        withDelay:0.0f];
}

- (UIAlertController *) ccAlertWithTitle : (NSString *) stringTitle
                             withMessage : (NSString *) stringMessage{
    return [self ccAlertWithTitle:stringTitle
                      withMessage:stringMessage
                        withDelay:0.0f];
}

- (UIAlertController *) ccAlertWithTitle : (NSString *) stringTitle
                             withMessage : (NSString *) stringMessage
                          withCompletion : (dispatch_block_t) block {
    return [self ccAlertWithTitle:stringTitle
                      withMessage:stringMessage
                        withDelay:.0f
                withConfirmAction:nil
                 withCancelAction:nil
                   withCompletion:block];
}

- (UIAlertController *) ccAlertWithTitle : (NSString *) stringTitle
                             withMessage : (NSString *) stringMessage
                               withDelay : (CGFloat) floatDelay {
    return [self ccAlertWithTitle:stringTitle
                      withMessage:stringMessage
                        withDelay:floatDelay
                withConfirmAction:nil
                 withCancelAction:nil
                   withCompletion:nil];
}

- (UIAlertController *) ccAlertWithTitle : (NSString *) stringTitle
                             withMessage : (NSString *) stringMessage
                               withDelay : (CGFloat) floatDelay
                       withConfirmAction : (dispatch_block_t) blockConfirm
                        withCancelAction : (dispatch_block_t) blockCancel
                          withCompletion : (dispatch_block_t) blockCompletion {
    /*
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:stringTitle
                                                                    message:stringMessage
                                                             preferredStyle:UIAlertControllerStyleAlert];
    if (blockConfirm) {
        UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:ccLocalize(@"_CC_CONFIRM_", "确认")
                                                                style:UIAlertActionStyleDestructive
                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                                  _CC_Safe_UI_Block_(blockConfirm, ^{
                                                                      blockConfirm();
                                                                  });
                                                              }];
        [alertC addAction:actionConfirm];
    }
    if (blockCancel) {
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:ccLocalize(@"_CC_CANCEL_", "取消")
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 _CC_Safe_UI_Block_(blockCancel, ^{
                                                                     blockCancel();
                                                                 });
                                                             }];
        [alertC addAction:actionCancel];
    }
    [self presentViewController:alertC animated:YES completion:^{
        _CC_Safe_UI_Block_(blockCompletion, ^{
            blockCompletion();
        });
    }];
    if (!blockConfirm && !blockCancel) {
        if (floatDelay <= 0) {
            floatDelay = _CC_ALERT_DISMISS_INTERVAL_;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(floatDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alertC dismissViewControllerAnimated:YES
                                       completion:nil];
        });
    }
    
    return alertC;
     */
    return [self ccAlertWithTitle:stringTitle
                      withMessage:stringMessage
                 withConfirmTitle:ccLocalize(@"_CC_CONFIRM_", "确认")
                  withCancelTitle:ccLocalize(@"_CC_CANCEL_", "取消")
                        withDelay:floatDelay
                withConfirmAction:blockConfirm
                 withCancelAction:blockCancel
                   withCompletion:blockCompletion];
}

- (UIAlertController *) ccAlertWithTitle : (NSString *) stringTitle
                             withMessage : (NSString *) stringMessage
                        withConfirmTitle : (NSString *) stringConfirmTitle
                         withCancelTitle : (NSString *) stringCancelTitle
                               withDelay : (CGFloat) floatDelay
                       withConfirmAction : (dispatch_block_t) blockConfirm
                        withCancelAction : (dispatch_block_t) blockCancel
                          withCompletion : (dispatch_block_t) blockCompletion{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:stringTitle
                                                                    message:stringMessage
                                                             preferredStyle:UIAlertControllerStyleAlert];
    if (blockConfirm) {
        UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:stringConfirmTitle
                                                                style:UIAlertActionStyleDestructive
                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                                  _CC_Safe_UI_Block_(blockConfirm, ^{
                                                                      blockConfirm();
                                                                  });
                                                              }];
        [alertC addAction:actionConfirm];
    }
    if (blockCancel) {
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:stringCancelTitle
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 _CC_Safe_UI_Block_(blockCancel, ^{
                                                                     blockCancel();
                                                                 });
                                                             }];
        [alertC addAction:actionCancel];
    }
    [self presentViewController:alertC animated:YES completion:^{
        _CC_Safe_UI_Block_(blockCompletion, ^{
            blockCompletion();
        });
    }];
    if (!blockConfirm && !blockCancel) {
        if (floatDelay <= 0) {
            floatDelay = _CC_ALERT_DISMISS_INTERVAL_;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(floatDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alertC dismissViewControllerAnimated:YES
                                       completion:nil];
        });
    }
    
    return alertC;
}

- (UIAlertController *) ccAlertActionSheet : (NSString *) stringTitleCancel
                        withDestructButton : (NSString *) stringTitleDestruct
                            withClickIndex : (void(^)(NSInteger integerIndex)) blockClickIndex {
    return [self ccAlertActionSheet:stringTitleCancel
                 withDestructButton:stringTitleDestruct
                   withOtherButtons:nil
                     withClickIndex:blockClickIndex];
}

- (UIAlertController *) ccAlertActionSheet : (NSString *) stringTitleCancel
                        withDestructButton : (NSString *) stringTitleDestruct
                          withOtherButtons : (NSArray *) arrayButtonTitles
                            withClickIndex : (void(^)(NSInteger integerIndex)) blockClickIndex {
    return [self ccAlertActionSheet:nil
                        withMessage:nil
                   withCancelButton:stringTitleCancel
                 withDestructButton:stringTitleDestruct
                   withOtherButtons:arrayButtonTitles
                     withClickIndex:blockClickIndex];
}

- (UIAlertController *) ccAlertActionSheet : (NSString *) stringTitle
                               withMessage : (NSString *) stringMessage
                          withCancelButton : (NSString *) stringTitleCancel
                        withDestructButton : (NSString *) stringTitleDestruct
                          withOtherButtons : (NSArray *) arrayButtonTitles
                            withClickIndex : (void(^)(NSInteger integerIndex)) blockClickIndex {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:stringTitle
                                                                        message:stringMessage
                                                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    NSInteger integerIndex = 0;
    if ([stringTitleCancel isKindOfClass:[NSString class]]) {
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:stringTitleCancel
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * _Nonnull action) {
            if (blockClickIndex)
                blockClickIndex(0);
        }];
        [controller addAction:actionCancel];
        ++ integerIndex;
    }
    if ([stringTitleDestruct isKindOfClass:[NSString class]]) {
        UIAlertAction *actionDestruct = [UIAlertAction actionWithTitle:stringTitleDestruct
                                                                 style:UIAlertActionStyleDestructive
                                                               handler:^(UIAlertAction * _Nonnull action) {
            if (blockClickIndex)
                blockClickIndex(1);
        }];
        [controller addAction:actionDestruct];
        ++ integerIndex;
    }
    
    for (NSString *tempTitle in arrayButtonTitles) {
        if (![tempTitle isKindOfClass:[NSString class]]) continue ;
        UIAlertActionModel *model = [[UIAlertActionModel alloc] init];
        model.stringTitle = tempTitle;
        model.integerIndex = ++ integerIndex;
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:tempTitle
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
            if (blockClickIndex)
                blockClickIndex(action.modelAction.integerIndex);
        }];
        action.modelAction = model;
        [controller addAction:action];
    }
    [self presentViewController:controller
                       animated:YES
                     completion:nil];
    
    return controller;
}

+ (id) ccGetCurrentViewController {
    id controller = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *arrayWindows = [[UIApplication sharedApplication] windows];
        for (UIWindow *tempWindow in arrayWindows) {
            if (tempWindow.windowLevel == UIWindowLevelNormal) {
                window = tempWindow;
                break;
            }
        }
    }
    UIView *viewFront = [[window subviews] firstObject];
    controller = [viewFront nextResponder];
    if ([controller isKindOfClass:[UIViewController class]]) {
        return controller;
    } else {
        return window.rootViewController;
    }
}

+ (id) ccGetCurrentModalController {
    id controller = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([controller isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigation = (UINavigationController *) controller;
        return navigation.visibleViewController;
    }
    return controller;
}

- (void) ccPushViewController : (UIViewController *) controller
                 withAnimated : (BOOL) isAnimated {
    if (self.navigationController) {
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller
                                             animated:isAnimated];
    }
}

- (void) ccModalController : (UIViewController *) controller {
    [self ccModalController:controller
               withAnimated:YES
               withComplete:nil];
}
- (void) ccModalController : (UIViewController *) controller
              withAnimated : (BOOL) isAnimated
              withComplete : (dispatch_block_t) block {
    controller.providesPresentationContextTransitionStyle = YES;
    controller.definesPresentationContext = YES;
    [controller setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self presentViewController:controller animated:isAnimated completion:^{
        if (block) {
            block();
        }
    }];
}

- (void) ccAddViewFromController : (NSObject *) controllerT
                  withIsAnimated : (BOOL) isAnimated {
    if (![controllerT isKindOfClass:[UIViewController class]]) return;
    Class clazz = [controllerT class];
    for (id item in [UIApplication sharedApplication].delegate.window.subviews) {
        if ([item isKindOfClass:clazz]) return;
    }
    
    UIViewController *controller = (UIViewController *) controllerT;
    if (!controller) return ;
    if (isAnimated) {
        controller.view.alpha = .01f;
        [[UIApplication sharedApplication].delegate.window addSubview:controller.view];
        [UIView animateWithDuration:_CC_ANIMATION_COMMON_DURATION_ animations:^{
            controller.view.alpha = 1.f;
        }];
    }
    else [[UIApplication sharedApplication].delegate.window addSubview:controller.view];
    [self addChildViewController:controller];
}

- (UIImagePickerController *) ccImagePickerPresentType : (CCImagePickerPresentType) type
                                          withComplete : (BlockCompleteHandler) blockComplete
                                            withCancel : (BlockCancelPick) blockCancel
                                             withError : (BlockSaveError) blockError
                                   withPresentComplete : (dispatch_block_t) blockPresentComplete{
    
#if _CC_IS_SIMULATOR_
    if (type == CCImagePickerPresentTypeCamera) {
        [MBProgressHUD ccShowMessage:ccLocalize(@"_CC_CURRENT_DEVICE_NOT_SUPPORT_CAMERA_", "当前设备不支持相机")];
        return nil;
    }
#endif
    __block UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker ccImagePickerWithType:type withCompleteHandler:^CCImageSaveType(UIImage *imageOrigin,
                                                                                 UIImage *imageEdited,
                                                                                 CGRect rectCrop,
                                                                                 NSArray<NSNumber *> *arrayTypes) {
        [imagePicker dismissViewControllerAnimated:YES
                                        completion:nil];
        if (blockComplete) {
            return blockComplete(imageOrigin , imageEdited , rectCrop , arrayTypes);
        }
        else return CCImageSaveTypeNone;
    } withCancel:^{
        [imagePicker dismissViewControllerAnimated:YES completion:^{
            _CC_Safe_UI_Block_(blockCancel, ^{
                blockCancel();
            });
        }];
    } withSaveError:^(NSError *error) {
        [imagePicker dismissViewControllerAnimated:YES completion:^{
            _CC_Safe_UI_Block_(blockError, ^{
                blockError(error);
            });
        }];
    }];
    [self presentViewController:imagePicker animated:YES completion:^{
        _CC_Safe_UI_Block_(blockPresentComplete, ^{
            blockPresentComplete();
        });
    }];
    return imagePicker;
}

@end

#pragma mark - -----------------------------------------------------------------

@implementation UIAlertAction (CCExtension)

- (void)setModelAction:(UIAlertActionModel *)modelAction {
    objc_setAssociatedObject(self, @selector(modelAction), modelAction, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIAlertActionModel *)modelAction {
    return objc_getAssociatedObject(self, _cmd);
}

@end

#pragma mark - -----------------------------------------------------------------

@implementation UIAlertActionModel

@end
