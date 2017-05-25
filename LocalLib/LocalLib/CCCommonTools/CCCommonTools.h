//
//  CCCommonTools.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/3/29.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIViewController ;

@interface CCCommonTools : NSObject

+ (BOOL) ccHasAccessToAlbum ;

+ (void) ccGuideToCameraSettings ;

+ (BOOL) ccHasAccessToCamera ;

/// dispatch_source_t Timer . 不会被阻断 . 需要在页面 dismiss 时候取消计时 .
+ (instancetype) ccTimerWithInterval : (NSTimeInterval) interval
                     withTimerAction : (BOOL (^)()) blockTimerAction
                    withCancelAction : (dispatch_block_t) blockCancel ;
- (void) ccCancelTimer ;

@end
