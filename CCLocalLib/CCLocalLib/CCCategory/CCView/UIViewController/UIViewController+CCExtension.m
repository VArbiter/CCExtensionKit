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
#import "CCCommonTools.h"

#if _CC_IS_SIMULATOR_
    #import "MBProgressHUD+CCExtension.h"
#endif

@implementation UIViewController (CCExtension)

+ (void) ccDismiss : (id) controller
             delay : (CGFloat) floatDelay {
    [self ccDismiss:controller
              delay:floatDelay
           complete:nil];
}
+ (void) ccDismiss : (id) controller
             delay : (CGFloat) floatDelay
          complete : (dispatch_block_t) block {
    if (!controller || ![controller isKindOfClass:UIViewController.class]) {
        return ;
    }
    
    UIViewController *controllerT = (UIViewController *) controller;
    if (controllerT.presentingViewController) {
        [controllerT dismissViewControllerAnimated:YES
                                        completion:block];
    }
}

+ (id) ccGetCurrentController {
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
- (void) ccPush : (UIViewController *) controller {
    [self ccPush:controller animated:YES];
}
- (void) ccPush : (UIViewController *) controller
       animated : (BOOL) isAnimated  {
    if (self.navigationController) {
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller
                                             animated:isAnimated];
    }
}

- (void) ccModal : (UIViewController *) controller {
    [self ccModal:controller
         animated:YES
         complete:nil];
}
- (void) ccModal : (UIViewController *) controller
        animated : (BOOL) isAnimated
        complete : (dispatch_block_t) block {
    controller.providesPresentationContextTransitionStyle = YES;
    controller.definesPresentationContext = YES;
    [controller setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self presentViewController:controller animated:isAnimated completion:^{
        if (block) {
            block();
        }
    }];
}

- (void) ccAddView : (NSObject *) controllerT
          animated : (BOOL) isAnimated {
    if (![controllerT isKindOfClass:[UIViewController class]]) return;
    UIViewController *controller = (UIViewController *) controllerT;
    for (id item in [UIApplication sharedApplication].delegate.window.subviews) {
        if (item == controller.view) return;
    }
    
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

- (UIImagePickerController *) ccImagePicker : (CCImagePickerPresentType) type
                                   complete : (BlockCompleteHandler) blockComplete {
    return [self ccImagePicker:type
                      complete:blockComplete
                        cancel:nil
                         error:nil];
}
- (UIImagePickerController *) ccImagePicker : (CCImagePickerPresentType) type
                                   complete : (BlockCompleteHandler) blockComplete
                                     cancel : (BlockCancelPick) blockCancel
                                      error : (BlockSaveError) blockError {
    
#if _CC_IS_SIMULATOR_
    if (type == CCImagePickerPresentTypeCamera) {
        [MBProgressHUD ccShowMessage:ccLocalize(@"_CC_CURRENT_DEVICE_NOT_SUPPORT_CAMERA_", "当前设备不支持相机")];
        return nil;
    }
#endif
    __block UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker ccImagePicker:type complete:^CCImageSaveType(UIImage *imageOrigin, UIImage *imageEdited, CGRect rectCrop, NSArray<NSNumber *> *arrayTypes) {
        [imagePicker dismissViewControllerAnimated:YES
                                        completion:nil];
        if (blockComplete) {
            return blockComplete(imageOrigin , imageEdited , rectCrop , arrayTypes);
        }
        else return CCImageSaveTypeNone;
    } cancel:^{
        [imagePicker dismissViewControllerAnimated:YES completion:^{
            CC_Safe_UI_Operation(blockCancel, ^{
                blockCancel();
            });
        }];
    } error:^(NSError *error) {
        [imagePicker dismissViewControllerAnimated:YES completion:^{
            CC_Safe_UI_Operation(blockError, ^{
                blockError(error);
            });
        }];
    }];
    
    return imagePicker;
}

@end

#pragma mark - -----------------------------------------------------------------

@implementation UIAlertAction (CCModel)

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
