//
//  YMCommonTools.h
//  ym_sell_ios
//
//  Created by 冯明庆 on 2017/3/29.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIViewController ;

@interface YMCommonTools : NSObject

+ (BOOL) ymHasAccessToAlbum ;

+ (void) ymGuideToCameraSettings ;

+ (BOOL) ymHasAccessToCamera ;

/// dispatch_source_t Timer . 不会被阻断 . 需要在页面 dismiss 时候取消计时 .
+ (instancetype) ymTimerWithInterval : (NSTimeInterval) interval
                     withTimerAction : (BOOL (^)()) blockTimerAction
                    withCancelAction : (dispatch_block_t) blockCancel ;
- (void) ymCancelTimer ;

@end
