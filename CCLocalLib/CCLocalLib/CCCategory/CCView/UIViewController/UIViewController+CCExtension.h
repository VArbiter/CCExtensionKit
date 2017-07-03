//
//  UIViewController+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/5.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImagePickerController+CCExtension.h"

@interface UIViewController (CCExtension)

+ (void) ccDismiss : (id) controller
             delay : (CGFloat) floatDelay ;
+ (void) ccDismiss : (id) controller
             delay : (CGFloat) floatDelay
          complete : (dispatch_block_t) block ;

+ (id) ccGetCurrentController ; 

- (void) ccPush : (UIViewController *) controller ;
- (void) ccPush : (UIViewController *) controller
       animated : (BOOL) isAnimated ; // default Hids Bottombar

- (void) ccModal : (UIViewController *) controller;
- (void) ccModal : (UIViewController *) controller
        animated : (BOOL) isAnimated
        complete : (dispatch_block_t) block ; // 透明背景 modal (同时控制器背景色也需要为透明)

- (void) ccAddView : (UIViewController *) controller
          animated : (BOOL) isAnimated ;

- (UIImagePickerController *) ccImagePicker : (CCImagePickerPresentType) type
                                   complete : (BlockCompleteHandler) blockComplete ;
- (UIImagePickerController *) ccImagePicker : (CCImagePickerPresentType) type
                                   complete : (BlockCompleteHandler) blockComplete
                                     cancel : (BlockCancelPick) blockCancel
                                      error : (BlockSaveError) blockError ;

@end

#pragma mark - -----------------------------------------------------------------

@class UIAlertActionModel ;

@interface UIAlertAction (CCModel)

@property (nonatomic , strong) UIAlertActionModel *modelAction ;

@end

#pragma mark - -----------------------------------------------------------------

@interface UIAlertActionModel : NSObject

@property (nonatomic , strong) NSString *stringTitle ;
@property (nonatomic , assign) NSInteger integerIndex ;

@end
