//
//  UIViewController+YMExtension.h
//  ym_sell_ios
//
//  Created by 冯明庆 on 2017/4/5.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImagePickerController+YMExtension.h"

@interface UIViewController (YMExtension)

- (UIAlertController *) ymAlertWithMessage : (NSString *) stringMessage ;

- (UIAlertController *) ymAlertWithMessage : (NSString *) stringMessage
                                 withDelay : (CGFloat) floatDelay ;

- (UIAlertController *) ymAlertWithTitle : (NSString *) stringTitle
                             withMessage : (NSString *) stringMessage ;

- (UIAlertController *) ymAlertWithTitle : (NSString *) stringTitle
                             withMessage : (NSString *) stringMessage
                          withCompletion : (dispatch_block_t) block ;

- (UIAlertController *) ymAlertWithTitle : (NSString *) stringTitle
                             withMessage : (NSString *) stringMessage
                               withDelay : (CGFloat) floatDelay ;

- (UIAlertController *) ymAlertWithTitle : (NSString *) stringTitle
                             withMessage : (NSString *) stringMessage
                               withDelay : (CGFloat) floatDelay
                       withConfirmAction : (dispatch_block_t) blockConfirm
                        withCancelAction : (dispatch_block_t) blockCancel
                          withCompletion : (dispatch_block_t) blockCompletion ;

- (UIAlertController *) ymAlertWithTitle : (NSString *) stringTitle
                             withMessage : (NSString *) stringMessage
                        withConfirmTitle : (NSString *) stringConfirmTitle
                         withCancelTitle : (NSString *) stringCancelTitle
                               withDelay : (CGFloat) floatDelay
                       withConfirmAction : (dispatch_block_t) blockConfirm
                        withCancelAction : (dispatch_block_t) blockCancel
                          withCompletion : (dispatch_block_t) blockCompletion ;

- (UIAlertController *) ymAlertActionSheet : (NSString *) stringTitleCancel
                        withDestructButton : (NSString *) stringTitleDestruct
                          withOtherButtons : (NSArray *) arrayButtonTitles
                            withClickIndex : (void(^)(NSInteger integerIndex)) blockClickIndex;

- (UIAlertController *) ymAlertActionSheet : (NSString *) stringTitle
                               withMessage : (NSString *) stringMessage
                          withCancelButton : (NSString *) stringTitleCancel
                        withDestructButton : (NSString *) stringTitleDestruct
                          withOtherButtons : (NSArray *) arrayButtonTitles
                            withClickIndex : (void(^)(NSInteger integerIndex)) blockClickIndex ;

+ (id) ymGetCurrentViewController ; // for Navigation
+ (id) ymGetCurrentModalController ; // for Modal

- (void) ymPushViewController : (UIViewController *) controller
                 withAnimated : (BOOL) isAnimated ; // default Hids Bottombar

- (void) ymModalController : (UIViewController *) controller;
- (void) ymModalController : (UIViewController *) controller
              withAnimated : (BOOL) isAnimated
              withComplete : (dispatch_block_t) block ; // 透明背景 modal (同时控制器背景色也需要为透明)

- (void) ymAddViewFromController : (UIViewController *) controller
                  withIsAnimated : (BOOL) isAnimated ;

- (UIImagePickerController *) ymImagePickerPresentType : (YMImagePickerPresentType) type
                                          withComplete : (BlockCompleteHandler) blockComplete
                                            withCancel : (BlockCancelPick) blockCancel
                                             withError : (BlockSaveError) blockError
                                   withPresentComplete : (dispatch_block_t) blockPresentComplete ;

@end

#pragma mark - -----------------------------------------------------------------

@class UIAlertActionModel ;

@interface UIAlertAction (YMExtension)

@property (nonatomic , strong) UIAlertActionModel *modelAction ;

@end

#pragma mark - -----------------------------------------------------------------

@interface UIAlertActionModel : NSObject

@property (nonatomic , strong) NSString *stringTitle ;
@property (nonatomic , assign) NSInteger integerIndex ;

@end
