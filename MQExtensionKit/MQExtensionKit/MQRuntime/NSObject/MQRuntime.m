//
//  MQRuntime.m
//  MQExtensionKit
//
//  Created by Elwinfrederick on 15/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "MQRuntime.h"
#import <objc/runtime.h>
#import <pthread.h>

dispatch_queue_t mq_main_queue(void) {
    return dispatch_get_main_queue();
}
BOOL mq_is_main_queue(void) {
    return NSThread.isMainThread;
}

void mq_swizz_method(SEL sel_original , SEL sel_target , Class cls) {
    Method om = class_getInstanceMethod(cls, sel_original);
    Method tm = class_getInstanceMethod(cls, sel_target);
    if (class_addMethod(cls,sel_original,method_getImplementation(tm),method_getTypeEncoding(tm))) {
        class_replaceMethod(cls,sel_target,method_getImplementation(om),method_getTypeEncoding(om));
    }
    else method_exchangeImplementations(om, tm);
}

dispatch_source_t mq_dispatch_timer(NSTimeInterval interval ,
                                    BOOL (^mq_action_block)(void) ,
                                    void (^mq_cancel_block)(void)) {
    if (!mq_action_block) return NULL;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), interval * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        if (mq_action_block()) dispatch_source_cancel(timer);
    });
    dispatch_source_set_cancel_handler(timer, ^{
        if (mq_cancel_block) mq_cancel_block();
    });
    dispatch_resume(timer);
    return timer;
}

dispatch_time_t mq_dispatch_after(double f_seconds ,
                                  void (^mq_action_block)(void)) {
    if (!mq_action_block) return 0;
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(f_seconds * NSEC_PER_SEC));
    dispatch_after(time, dispatch_get_main_queue(), ^{
        if (mq_action_block) mq_action_block();
    });
    return time;
}

void mq_dispatch_async_m(void (^mq_action_block)(void)) {
    mq_dispatch_async(dispatch_get_main_queue(), mq_action_block);
}
void mq_dispatch_sync_m(void (^mq_action_block)(void)) {
    mq_dispatch_sync(dispatch_get_main_queue(), mq_action_block);
}
void mq_dispatch_async(dispatch_queue_t queue , void (^mq_action_block)(void)) {
    if (!queue) return ;
    dispatch_async(queue ? queue : mq_main_queue(), mq_action_block);
}
void mq_dispatch_sync(dispatch_queue_t queue , void (^mq_action_block)(void)) {
    if (pthread_main_np() != 0) {
        if (mq_action_block) mq_action_block();
    }
    else dispatch_sync(queue ? queue : mq_main_queue(), mq_action_block);
}

void mq_dispatch_barrier_async(dispatch_queue_t queue , void (^mq_action_block)(void)){
    dispatch_barrier_async(queue ? queue : mq_main_queue(), mq_action_block);
}

void mq_dispatch_apply_for(size_t count , dispatch_queue_t queue , void (^mq_time_block)(size_t t)) {
    dispatch_apply(count, queue ? queue : mq_main_queue(), mq_time_block);
}
void mq_dispatch_set_associate(id object , const void * key , id value , MQAssociationPolicy policy) {
    objc_setAssociatedObject(object, key, value, (objc_AssociationPolicy)policy);
}

id mq_dispatch_get_associate(id object ,
                             const void * key) {
    return objc_getAssociatedObject(object, key);
}
void mq_dispatch_get_associate_b(id object ,
                                 const void * key ,
                                 void (^bValue)(id value)) {
    if (bValue) bValue(mq_dispatch_get_associate(object, key));
}

#pragma mark - ----- 
@import UIKit;

dispatch_queue_t mq_dispatch_create_serial(const char * label , BOOL is_serial) {
    if (@available(iOS 10.0, *)) {
        return dispatch_queue_create(label, is_serial ? NULL : DISPATCH_QUEUE_CONCURRENT_WITH_AUTORELEASE_POOL);
    } else return dispatch_queue_create(label, is_serial ? NULL : DISPATCH_QUEUE_CONCURRENT);
}
dispatch_queue_t mq_dispatch_global(MQQueueQOS qos) {
    /// for unsigned long flags , what's DOCs told that , it use for reserves for future needs .
    /// thus , for now , it's always be 0 .
    
    unsigned int qos_t = 0x00; // equals nil / NIL / NULL
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
    switch (qos) {
        case MQQueue_Default:{
            qos_t = DISPATCH_QUEUE_PRIORITY_DEFAULT;
        }break;
        case MQQueue_High:{
            qos_t = DISPATCH_QUEUE_PRIORITY_HIGH;
        }break;
        case MQQueue_Low:{
            qos_t = DISPATCH_QUEUE_PRIORITY_LOW;
        }break;
        case MQQueue_Background:{
            qos_t = DISPATCH_QUEUE_PRIORITY_BACKGROUND;
        }break;
            
        default:{
            qos_t = DISPATCH_QUEUE_PRIORITY_DEFAULT;
        }break;
    }
#else
    switch (qos) {
        case MQQueue_Default:{
            qos_t = QOS_CLASS_DEFAULT;
        }break;
        case MQQueue_User_interaction:{
            qos_t = QOS_CLASS_USER_INTERACTIVE;
        }break;
        case MQQueue_User_Initiated:{
            qos_t = QOS_CLASS_USER_INITIATED;
        }break;
        case MQQueue_Utility:{
            qos_t = QOS_CLASS_UTILITY;
        }break;
        case MQQueue_Background:{
            qos_t = QOS_CLASS_BACKGROUND;
        }break;
        case MQQueue_Unspecified:{
            qos_t = QOS_CLASS_UNSPECIFIED;
        }break;
            
        default:{
            qos_t = QOS_CLASS_DEFAULT;
        }break;
    }
#endif
    return dispatch_get_global_queue(qos_t, 0) ;
}

dispatch_group_t mq_group_init(void) {
    return dispatch_group_create();
}

#pragma mark - ----- LOCK
dispatch_semaphore_t mq_semaphore_init(long value) {
    return dispatch_semaphore_create(value);
}
dispatch_semaphore_t mq_semaphore_init_t(void) {
    return mq_semaphore_init(1);
}
long mq_semaphore_lock(dispatch_semaphore_t lock) {
    return dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
}
long mq_semaphore_unlock(dispatch_semaphore_t lock) {
    return dispatch_semaphore_signal(lock);
}

#pragma mark - -----

void mq_get_ivar(Class cls ,
                 void (^mq_finish_block)(NSDictionary <NSString * , NSString *> *dictionary)) {
    unsigned int iVars = 0;
    Ivar *ivarList = class_copyIvarList(cls, &iVars);
    
    NSMutableDictionary <NSString * , NSString *> * dictionary = [NSMutableDictionary dictionary];
    for (unsigned int i = 0 ; i < iVars; i ++) {
        // get type and property names
        NSString *sMember = [NSString stringWithUTF8String:ivar_getName(ivarList[i])]; // output with _ , eg:_cc
        if ([sMember hasPrefix:@"_"]) {
            sMember = [sMember substringFromIndex:1];
        }
        // get ignores
        if ([cls respondsToSelector:NSSelectorFromString(@"mq_ignores")]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            NSArray *a = [cls performSelector:NSSelectorFromString(@"mq_ignores")];
#pragma clang diagnostic pop
            if ([a containsObject:sMember]) continue;
        }
        
        NSString *sMemberType = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivarList[i])]; // output @"NSString"
        sMemberType = [sMemberType stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"@\""]]; // compress
        [dictionary setValue:sMemberType // types can be found multi times , therefore , make it values .
                      forKey:sMember];
    }
    if (mq_finish_block) mq_finish_block(dictionary);
}

BOOL mq_dynamic_add_method(Class cls ,
                           NSString * sName ,
                           SEL sel_supply ,
                           void (^mq_fail_block)(void)) {
    BOOL b = class_addMethod(cls,
                             NSSelectorFromString(sName),
                             class_getMethodImplementation(cls, sel_supply),
                             "s@:@");
    if (!b) {
        if (mq_fail_block) mq_fail_block();
    }
    return b;
}
