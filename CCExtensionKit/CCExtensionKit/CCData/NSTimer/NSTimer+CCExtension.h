//
//  NSTimer+CCExtension.h
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 06/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (CCExtension)

/// timer
+ (instancetype) ccTimer : (NSTimeInterval) interval
                  action : (void (^)(NSTimer *sender)) action ;

+ (instancetype) ccTimer : (NSTimeInterval) interval
                  repeat : (BOOL) isRepeat
                  action : (void (^)(NSTimer *sender)) action ;

+ (instancetype) ccTimer : (NSTimeInterval) interval
                userInfo : (id) userInfo
                  repeat : (BOOL) isRepeat
                  action : (void (^)(NSTimer *sender)) action ;

/// scheduled
+ (instancetype) ccScheduled : (NSTimeInterval) interval
                      action : (void (^)(NSTimer *sender)) action ;

+ (instancetype) ccScheduled : (NSTimeInterval) interval
                      repeat : (BOOL) isRepeat
                      action : (void (^)(NSTimer *sender)) action ;

+ (instancetype) ccScheduled : (NSTimeInterval) interval
                    userInfo : (id) userInfo
                      repeat : (BOOL) isRepeat
                      action : (void (^)(NSTimer *sender)) action ;

/// invalidate && set entity to nil. // 取消定时和销毁
void CC_TIMER_DESTORY(NSTimer *timer);

// for additional actions // 额外功能
- (instancetype) ccFire ; // == fire
- (instancetype) ccPause ; // has to be a valid timer . // 必须是有效的 timer
- (instancetype) ccResume ; // has to be a valid timer . // 必须是有效的 timer
- (instancetype) ccStop ; // == invalidate

@end
