//
//  UIAlertController+CCExtension.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 26/06/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "UIAlertController+CCExtension.h"

#import "CCCommonTools.h"
#import <objc/runtime.h>

@implementation UIAlertController (CCExtension)

- (UIAlertController *) ccAlert : (NSString *) stringMessage {
    return [self ccAlert:nil
                 message:stringMessage];
}

- (UIAlertController *) ccAlert : (NSString *) stringTitle
                        message : (NSString *) stringMessage {
    return [self ccAlert:stringTitle
                 message:stringMessage
                 confirm:nil
                  cancel:nil];
}

- (UIAlertController *) ccAlert : (NSString *) stringTitle
                        message : (NSString *) stringMessage
                        confirm : (dispatch_block_t) blockConfirm
                         cancel : (dispatch_block_t) blockCancel {
    return [self ccAlert:stringTitle
                 message:stringMessage
            titleConfirm:ccLocalize(@"_CC_CONFIRM_", "确认")
             titleCancel:ccLocalize(@"_CC_CANCEL_", "取消")
                 confirm:blockConfirm
                  cancel:blockConfirm];
}

- (UIAlertController *) ccAlert : (NSString *) stringTitle
                        message : (NSString *) stringMessage
                   titleConfirm : (NSString *) stringConfirmTitle
                    titleCancel : (NSString *) stringCancelTitle
                        confirm : (dispatch_block_t) blockConfirm
                         cancel : (dispatch_block_t) blockCancel {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:stringTitle
                                                                    message:stringMessage
                                                             preferredStyle:UIAlertControllerStyleAlert];
    if (blockConfirm) {
        UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:stringConfirmTitle
                                                                style:UIAlertActionStyleDestructive
                                                              handler:^(UIAlertAction * _Nonnull action) {
              CC_Safe_UI_Operation(blockConfirm, ^{
                  blockConfirm();
              });
          }];
        [alertC addAction:actionConfirm];
    }
    if (blockCancel) {
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:stringCancelTitle
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * _Nonnull action) {
             CC_Safe_UI_Operation(blockCancel, ^{
                 blockCancel();
             });
         }];
        [alertC addAction:actionCancel];
    }
    return alertC;
}

- (UIAlertController *) ccAlertSheet : (NSString *) stringTitleCancel
                            destruct : (NSString *) stringTitleDestruct
                              others : (NSArray *) arrayButtonTitles
                               click : (void(^)(NSInteger integerIndex)) blockClickIndex {
    return [self ccAlertSheet:nil
                      message:nil
                       cancel:stringTitleCancel
                     destruct:stringTitleDestruct
                       others:arrayButtonTitles
                        click:blockClickIndex];
}

- (UIAlertController *) ccAlertSheet : (NSString *) stringTitle
                             message : (NSString *) stringMessage
                              cancel : (NSString *) stringTitleCancel
                            destruct : (NSString *) stringTitleDestruct
                              others : (NSArray *) arrayButtonTitles
                               click : (void(^)(NSInteger integerIndex)) blockClickIndex {
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
        CCAlertActionModel *model = [[CCAlertActionModel alloc] init];
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
    
    return controller;
}


@end

#pragma mark - -----------------------------------------------------------------

@implementation UIAlertAction (CCExtension)

- (void)setModelAction:(CCAlertActionModel *)modelAction {
    objc_setAssociatedObject(self, @selector(modelAction), modelAction, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CCAlertActionModel *)modelAction {
    return objc_getAssociatedObject(self, _cmd);
}

@end

#pragma mark - -----------------------------------------------------------------

@implementation CCAlertActionModel

@end
