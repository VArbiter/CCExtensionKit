//
//  NSNotificationCenter+CCExtension.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 23/11/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "NSNotificationCenter+CCExtension.h"
#import <objc/runtime.h>

static NSMutableDictionary * __dictionary = nil;

@implementation NSNotificationCenter (CCExtension)

+ (instancetype) common {
    if (!__dictionary) __dictionary = [NSMutableDictionary dictionary];
    return NSNotificationCenter.defaultCenter;
}

+ (instancetype) cc_post : (NSNotificationName) sNotification {
    id t = self.common;
    [t postNotificationName:sNotification object:nil userInfo:nil];
    return t;
}

+ (instancetype) cc_post_t : (NSNotification *) notification {
    id t = self.common;
    [t postNotification:notification];
    return t;
}

+ (instancetype) cc_async_post_on_queue : (dispatch_queue_t) queue
                       notification : (NSNotificationName) sNofification {
    id t = self.common;
    dispatch_async(queue, ^{
        [t postNotificationName:sNofification object:nil userInfo:nil];
    });
    return t;
}

+ (instancetype) cc_async_observer_target : (id) target
                                    queue : (dispatch_queue_t) queue
                                      sel : (SEL) selector
                             notification : (NSNotificationName) sNotificationName
                                      obj : (id) object {
    id t = self.common;
    void (^bAdding)(void) = ^ {
        [t addObserver:target selector:selector name:sNotificationName object:object];
    };
    dispatch_async(queue, ^{
        if (bAdding) bAdding();
    });
    return t;
}

@end

#pragma mark - -----

const char * _CC_NSNOTIFICATION_EXECUTE_ASSOCITE_KEY_ = "CC_NSNOTIFICATION_ASSOCITE_KEY";

@implementation NSNotification (CCExtension_Notification)

- (void)setBlock_execute:(void (^)(__kindof NSNotification *))block_execute {
    if (block_execute)
    objc_setAssociatedObject(self, _CC_NSNOTIFICATION_EXECUTE_ASSOCITE_KEY_, block_execute, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void (^)(__kindof NSNotification *))block_execute {
    return objc_getAssociatedObject(self, _CC_NSNOTIFICATION_EXECUTE_ASSOCITE_KEY_);
}

@end

void CC_SEND_NOTIFICATION_USING_DEFAULT(void (^block_notification)(NSNotificationCenter * sender)) {
    if (!block_notification) return ;
    NSNotificationCenter *t_notification = [NSNotificationCenter defaultCenter];
    block_notification(t_notification);
}
