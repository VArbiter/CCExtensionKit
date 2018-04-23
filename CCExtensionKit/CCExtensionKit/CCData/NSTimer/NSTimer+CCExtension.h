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
+ (instancetype) cc_timer : (NSTimeInterval) interval
                  action : (void (^)(NSTimer *sender)) action ;

+ (instancetype) cc_timer : (NSTimeInterval) interval
                   repeat : (BOOL) isRepeat
                   action : (void (^)(NSTimer *sender)) action ;

+ (instancetype) cc_timer : (NSTimeInterval) interval
                 userInfo : (id) userInfo
                   repeat : (BOOL) isRepeat
                   action : (void (^)(NSTimer *sender)) action ;

/// scheduled
+ (instancetype) cc_scheduled : (NSTimeInterval) interval
                       action : (void (^)(NSTimer *sender)) action ;

+ (instancetype) cc_scheduled : (NSTimeInterval) interval
                       repeat : (BOOL) isRepeat
                       action : (void (^)(NSTimer *sender)) action ;

+ (instancetype) cc_scheduled : (NSTimeInterval) interval
                     userInfo : (id) userInfo
                       repeat : (BOOL) isRepeat
                       action : (void (^)(NSTimer *sender)) action ;

/// invalidate && set entity to nil. // 取消定时和销毁
void CC_TIMER_DESTORY(NSTimer *timer);

// for additional actions // 额外功能
- (instancetype) cc_fire ; // == fire
- (instancetype) cc_pause ; // has to be a valid timer . // 必须是有效的 timer
- (instancetype) cc_resume ; // has to be a valid timer . // 必须是有效的 timer
- (instancetype) cc_stop ; // == invalidate

@end
