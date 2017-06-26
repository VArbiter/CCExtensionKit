//
//  UIAlertController+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 26/06/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (CCExtension)

- (UIAlertController *) ccAlert : (NSString *) stringMessage ;

- (UIAlertController *) ccAlert : (NSString *) stringTitle
                        message : (NSString *) stringMessage ;

- (UIAlertController *) ccAlert : (NSString *) stringTitle
                        message : (NSString *) stringMessage
                        confirm : (dispatch_block_t) blockConfirm
                         cancel : (dispatch_block_t) blockCancel ;

- (UIAlertController *) ccAlert : (NSString *) stringTitle
                        message : (NSString *) stringMessage
                   titleConfirm : (NSString *) stringConfirmTitle
                    titleCancel : (NSString *) stringCancelTitle
                        confirm : (dispatch_block_t) blockConfirm
                         cancel : (dispatch_block_t) blockCancel;

- (UIAlertController *) ccAlertSheet : (NSString *) stringTitleCancel
                            destruct : (NSString *) stringTitleDestruct
                              others : (NSArray *) arrayButtonTitles
                               click : (void(^)(NSInteger integerIndex)) blockClickIndex;

- (UIAlertController *) ccAlertSheet : (NSString *) stringTitle
                             message : (NSString *) stringMessage
                              cancel : (NSString *) stringTitleCancel
                            destruct : (NSString *) stringTitleDestruct
                              others : (NSArray *) arrayButtonTitles
                               click : (void(^)(NSInteger integerIndex)) blockClickIndex ;

@end

#pragma mark - -----------------------------------------------------------------

@class CCAlertActionModel ;

@interface UIAlertAction (CCExtension)

@property (nonatomic , strong) CCAlertActionModel *modelAction ;

@end

#pragma mark - -----------------------------------------------------------------

@interface CCAlertActionModel : NSObject

@property (nonatomic , strong) NSString *stringTitle ;
@property (nonatomic , assign) NSInteger integerIndex ;

@end
