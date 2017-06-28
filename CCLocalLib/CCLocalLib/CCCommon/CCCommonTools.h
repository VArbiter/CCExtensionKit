//
//  CCCommonTools.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/3/29.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCCommonTools : NSObject

+ (BOOL) ccHasAccessToAlbum ;

+ (void) ccGuideToCameraSettings ;

+ (BOOL) ccHasAccessToCamera ;

/// dispatch_source_t Timer . 不会被阻断 . 需要在页面 dismiss 时候取消计时 .
+ (instancetype) ccTimerWithInterval : (NSTimeInterval) interval
                     withTimerAction : (BOOL (^)()) blockTimerAction
                    withCancelAction : (dispatch_block_t) blockCancel ;
- (void) ccCancelTimer ;

#pragma mark -- Functions 

BOOL CC_Available(double version);

void CC_Safe_Operation(id blockNil ,
                       dispatch_block_t block) ;
void CC_Safe_UI_Operation(id blockNil ,
                          dispatch_block_t block) ;
void CC_Main_Queue_Operation(dispatch_block_t block) ;
void CC_Debug_Operation(dispatch_block_t block) ;

UIColor * ccHexColor(int intValue ,
                     float floatAlpha) ;

UIColor *ccRGBColor(float floatR ,
                    float floatG ,
                    float floatB);
UIColor *ccRGBAColor(float floatR ,
                     float floatG ,
                     float floatB ,
                     float floatA);

NSURL * ccURL (NSString * stringURL ,
               BOOL isLocalFile) ;

NSURLRequest * ccRequest(NSString * stringURL) ;

NSMutableURLRequest * ccMRequest(NSString * stringURL) ;

UIImage *ccImageCache(NSString *stringName);

UIImage *ccImage(NSString *stringName ,
                 BOOL isCacheInMemory);

NSString * ccLocalize(NSString * stringLocalKey , ...); // Default Main

NSString * ccBundleLocalize(NSString * stringLocalKey , NSBundle * bundle , ... ); // Default @"LocalizableMain.strings"

/// 末尾需要添加 nil , C function 无法使用 NS_REQUIRES_NIL_TERMINATION , 不能使用集合类 .
NSString * ccObjMerge(id obj , ... ) ;

@end
