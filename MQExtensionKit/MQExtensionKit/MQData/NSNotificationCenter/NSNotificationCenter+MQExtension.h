//
//  NSNotificationCenter+MQExtension.h
//  MQExtensionKit
//
//  Created by 冯明庆 on 23/11/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNotificationCenter (MQExtension)

/// euqals NSNotificationCenter.defaultCenter // 和 NSNotificationCenter.defaultCenter 等价
+ (instancetype) mq_common ;
/// an easy way to post a notification object : nil , userInfo : nil // 一个简便的发送通知的方式 object : nil , userInfo : nil
+ (instancetype) mq_post : (NSNotificationName) s_notification ;
+ (instancetype) mq_post_t : (NSNotification *) notification ;

/// note : when post using method below , // 如果使用下面这种发送方式
/// note : the receiver will do the operations on the thread the poster in . // 接收方会在指定线程内做操作
+ (instancetype) mq_async_post_on_queue : (dispatch_queue_t) queue
                           notification : (NSNotificationName) sNofification ;

/// note : if queue == main queue , // 如果线程是主线程
/// note : once receive the notification , observer will invoke it immediately on main queue . // 一旦接受者接收到了通知 , 观察者会立即在主线程执行
/// note : recommended to use it for large process tasks . // 推荐使用场景为资源消耗量大的任务
/// note : if on sub thread , using some actions that might operate the UI , be sure to get it on main queue . // 如果是子线 , 请在 UI 操作时 , 回调至主线 .
+ (instancetype) mq_async_observer_target : (id) target
                                    queue : (dispatch_queue_t) queue
                                      sel : (SEL) selector
                             notification : (NSNotificationName) s_notification_name
                                      obj : (id) object ;

@end

#pragma mark - -----

@interface NSNotification (MQExtension_Notification)

/// note : need invoke && execute . // 需要实现这个 block
/// note : if muti receiver execute the block , // 如果接收方有多个
/// note : it will run muti times just as the receiver executed times . // 那么这个 block 会执行多次 (和 接受者执行次数相同)
@property (nonatomic , copy) void (^block_execute)(__kindof NSNotification *sender);

@end

void MQ_SEND_NOTIFICATION_USING_DEFAULT(void (^block_notification)(NSNotificationCenter * sender)) ;
