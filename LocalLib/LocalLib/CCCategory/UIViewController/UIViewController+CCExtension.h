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

- (UIAlertController *) ccAlertWithMessage : (NSString *) stringMessage ;

- (UIAlertController *) ccAlertWithMessage : (NSString *) stringMessage
                                 withDelay : (CGFloat) floatDelay ;

- (UIAlertController *) ccAlertWithTitle : (NSString *) stringTitle
                             withMessage : (NSString *) stringMessage ;

- (UIAlertController *) ccAlertWithTitle : (NSString *) stringTitle
                             withMessage : (NSString *) stringMessage
                          withCompletion : (dispatch_block_t) block ;

- (UIAlertController *) ccAlertWithTitle : (NSString *) stringTitle
                             withMessage : (NSString *) stringMessage
                               withDelay : (CGFloat) floatDelay ;

- (UIAlertController *) ccAlertWithTitle : (NSString *) stringTitle
                             withMessage : (NSString *) stringMessage
                               withDelay : (CGFloat) floatDelay
                       withConfirmAction : (dispatch_block_t) blockConfirm
                        withCancelAction : (dispatch_block_t) blockCancel
                          withCompletion : (dispatch_block_t) blockCompletion ;

- (UIAlertController *) ccAlertWithTitle : (NSString *) stringTitle
                             withMessage : (NSString *) stringMessage
                        withConfirmTitle : (NSString *) stringConfirmTitle
                         withCancelTitle : (NSString *) stringCancelTitle
                               withDelay : (CGFloat) floatDelay
                       withConfirmAction : (dispatch_block_t) blockConfirm
                        withCancelAction : (dispatch_block_t) blockCancel
                          withCompletion : (dispatch_block_t) blockCompletion ;

- (UIAlertController *) ccAlertActionSheet : (NSString *) stringTitleCancel
                        withDestructButton : (NSString *) stringTitleDestruct
                          withOtherButtons : (NSArray *) arrayButtonTitles
                            withClickIndex : (void(^)(NSInteger integerIndex)) blockClickIndex;

- (UIAlertController *) ccAlertActionSheet : (NSString *) stringTitle
                               withMessage : (NSString *) stringMessage
                          withCancelButton : (NSString *) stringTitleCancel
                        withDestructButton : (NSString *) stringTitleDestruct
                          withOtherButtons : (NSArray *) arrayButtonTitles
                            withClickIndex : (void(^)(NSInteger integerIndex)) blockClickIndex ;

+ (id) ccGetCurrentViewController ; // for Navigation
+ (id) ccGetCurrentModalController ; // for Modal

- (void) ccPushViewController : (UIViewController *) controller
                 withAnimated : (BOOL) isAnimated ; // default Hids Bottombar

- (void) ccModalController : (UIViewController *) controller;
- (void) ccModalController : (UIViewController *) controller
              withAnimated : (BOOL) isAnimated
              withComplete : (dispatch_block_t) block ; // 透明背景 modal (同时控制器背景色也需要为透明)

- (void) ccAddViewFromController : (UIViewController *) controller
                  withIsAnimated : (BOOL) isAnimated ;

- (UIImagePickerController *) ccImagePickerPresentType : (CCImagePickerPresentType) type
                                          withComplete : (BlockCompleteHandler) blockComplete
                                            withCancel : (BlockCancelPick) blockCancel
                                             withError : (BlockSaveError) blockError
                                   withPresentComplete : (dispatch_block_t) blockPresentComplete ;

@end

#pragma mark - -----------------------------------------------------------------

@class UIAlertActionModel ;

@interface UIAlertAction (CCExtension)

@property (nonatomic , strong) UIAlertActionModel *modelAction ;

@end

#pragma mark - -----------------------------------------------------------------

@interface UIAlertActionModel : NSObject

@property (nonatomic , strong) NSString *stringTitle ;
@property (nonatomic , assign) NSInteger integerIndex ;

@end
