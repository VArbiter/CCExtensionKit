//
//  NSTimer+MQExtension.h
//  MQExtensionKit
//
//  Created by Elwinfrederick on 06/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (MQExtension)

/// timer
+ (instancetype) mq_timer : (NSTimeInterval) interval
                  action : (void (^)(NSTimer *sender)) action ;

+ (instancetype) mq_timer : (NSTimeInterval) interval
                   repeat : (BOOL) is_repeat
                   action : (void (^)(NSTimer *sender)) action ;

+ (instancetype) mq_timer : (NSTimeInterval) interval
                 userInfo : (id) user_info
                   repeat : (BOOL) is_repeat
                   action : (void (^)(NSTimer *sender)) action ;

/// scheduled
+ (instancetype) mq_scheduled : (NSTimeInterval) interval
                       action : (void (^)(NSTimer *sender)) action ;

+ (instancetype) mq_scheduled : (NSTimeInterval) interval
                       repeat : (BOOL) is_repeat
                       action : (void (^)(NSTimer *sender)) action ;

+ (instancetype) mq_scheduled : (NSTimeInterval) interval
                     userInfo : (id) user_info
                       repeat : (BOOL) is_repeat
                       action : (void (^)(NSTimer *sender)) action ;

/// invalidate && set entity to nil. // 取消定时和销毁
void MQ_TIMER_DESTORY(NSTimer *timer);

// for additional actions // 额外功能
- (instancetype) mq_fire ; // == fire

// has to be a valid timer . // 必须是有效的 timer
- (instancetype) mq_pause ;
- (instancetype) mq_continue ;
- (instancetype) mq_immediate ;

- (instancetype) mq_stop ; // == invalidate

@end
