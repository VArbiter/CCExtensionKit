//
//  NSNotificationCenter+MQExtension.m
//  MQExtensionKit
//
//  Created by 冯明庆 on 23/11/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "NSNotificationCenter+MQExtension.h"
#import <objc/runtime.h>

static NSMutableDictionary * __dictionary = nil;

@implementation NSNotificationCenter (MQExtension)

+ (instancetype) mq_common {
    if (!__dictionary) __dictionary = [NSMutableDictionary dictionary];
    return NSNotificationCenter.defaultCenter;
}

+ (instancetype) mq_post : (NSNotificationName) s_notification {
    id t = self.mq_common;
    [t postNotificationName:s_notification object:nil userInfo:nil];
    return t;
}

+ (instancetype) mq_post_t : (NSNotification *) notification {
    id t = self.mq_common;
    [t postNotification:notification];
    return t;
}

+ (instancetype) mq_async_post_on_queue : (dispatch_queue_t) queue
                       notification : (NSNotificationName) s_nofification {
    id t = self.mq_common;
    dispatch_async(queue, ^{
        [t postNotificationName:s_nofification object:nil userInfo:nil];
    });
    return t;
}

+ (instancetype) mq_async_observer_target : (id) target
                                    queue : (dispatch_queue_t) queue
                                      sel : (SEL) selector
                             notification : (NSNotificationName) s_notification_name
                                      obj : (id) object {
    id t = self.mq_common;
    void (^bAdding)(void) = ^ {
        [t addObserver:target selector:selector name:s_notification_name object:object];
    };
    dispatch_async(queue, ^{
        if (bAdding) bAdding();
    });
    return t;
}

@end

#pragma mark - -----

const char * MQ_NSNOTIFICATION_EXECUTE_ASSOCITE_KEY = "MQ_NSNOTIFICATION_ASSOCITE_KEY";

@implementation NSNotification (MQExtension_Notification)

- (void)setBlock_execute:(void (^)(__kindof NSNotification *))block_execute {
    if (block_execute)
    objc_setAssociatedObject(self, MQ_NSNOTIFICATION_EXECUTE_ASSOCITE_KEY, block_execute, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void (^)(__kindof NSNotification *))block_execute {
    return objc_getAssociatedObject(self, MQ_NSNOTIFICATION_EXECUTE_ASSOCITE_KEY);
}

@end

void MQ_SEND_NOTIFICATION_USING_DEFAULT(void (^block_notification)(NSNotificationCenter * sender)) {
    if (!block_notification) return ;
    NSNotificationCenter *t_notification = [NSNotificationCenter defaultCenter];
    block_notification(t_notification);
}
