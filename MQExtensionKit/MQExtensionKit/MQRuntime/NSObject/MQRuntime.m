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

dispatch_queue_t MQ_MAIN_QUEUE(void) {
    return dispatch_get_main_queue();
}

void MQ_SWIZZ_METHOD(SEL sel_original , SEL sel_target , Class cls) {
    Method om = class_getInstanceMethod(cls, sel_original);
    Method tm = class_getInstanceMethod(cls, sel_target);
    if (class_addMethod(cls,sel_original,method_getImplementation(tm),method_getTypeEncoding(tm))) {
        class_replaceMethod(cls,sel_target,method_getImplementation(om),method_getTypeEncoding(om));
    }
    else method_exchangeImplementations(om, tm);
}

dispatch_source_t MQ_DISPATCH_TIMER(NSTimeInterval interval ,
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

dispatch_time_t MQ_DISPATCH_AFTER(double f_seconds ,
                                  void (^mq_action_block)(void)) {
    if (!mq_action_block) return 0;
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(f_seconds * NSEC_PER_SEC));
    dispatch_after(time, dispatch_get_main_queue(), ^{
        if (mq_action_block) mq_action_block();
    });
    return time;
}

void MQ_DISPATCH_ASYNC_M(void (^mq_action_block)(void)) {
    MQ_DISPATCH_ASYNC(dispatch_get_main_queue(), mq_action_block);
}
void MQ_DISPATCH_SYNC_M(void (^mq_action_block)(void)) {
    MQ_DISPATCH_SYNC(dispatch_get_main_queue(), mq_action_block);
}
void MQ_DISPATCH_ASYNC(dispatch_queue_t queue , void (^mq_action_block)(void)) {
    if (!queue) return ;
    dispatch_async(queue ? queue : MQ_MAIN_QUEUE(), mq_action_block);
}
void MQ_DISPATCH_SYNC(dispatch_queue_t queue , void (^mq_action_block)(void)) {
    if (pthread_main_np() != 0) {
        if (mq_action_block) mq_action_block();
    }
    else dispatch_sync(queue ? queue : MQ_MAIN_QUEUE(), mq_action_block);
}

void MQ_DISPATCH_BARRIER_ASYNC(dispatch_queue_t queue , void (^mq_action_block)(void)){
    dispatch_barrier_async(queue ? queue : MQ_MAIN_QUEUE(), mq_action_block);
}

void MQ_DISPATCH_APPLY_FOR(size_t count , dispatch_queue_t queue , void (^mq_time_block)(size_t t)) {
    dispatch_apply(count, queue ? queue : MQ_MAIN_QUEUE(), mq_time_block);
}
void MQ_DISPATCH_SET_ASSOCIATE(id object , const void * key , id value , MQAssociationPolicy policy) {
    objc_setAssociatedObject(object, key, value, (objc_AssociationPolicy)policy);
}

id MQ_DISPATCH_GET_ASSOCIATE(id object ,
                             const void * key) {
    return objc_getAssociatedObject(object, key);
}
void MQ_DISPATCH_GET_ASSOCIATE_B(id object ,
                                 const void * key ,
                                 void (^bValue)(id value)) {
    if (bValue) bValue(MQ_DISPATCH_GET_ASSOCIATE(object, key));
}

#pragma mark - ----- 
@import UIKit;

dispatch_queue_t MQ_DISPATCH_CREATE_SERIAL(const char * label , BOOL is_serial) {
    if (UIDevice.currentDevice.systemVersion.floatValue >= 10.0) {
        return dispatch_queue_create(label, is_serial ? NULL : DISPATCH_QUEUE_CONCURRENT_WITH_AUTORELEASE_POOL);
    } else return dispatch_queue_create(label, is_serial ? NULL : DISPATCH_QUEUE_CONCURRENT);
}
dispatch_queue_t MQ_DISPATCH_GLOBAL(MQQueueQOS qos) {
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

dispatch_group_t MQ_GROUP_INIT(void) {
    return dispatch_group_create();
}

#pragma mark - -----

void MQ_GET_IVAR(Class cls ,
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

BOOL MQ_DYNAMIC_ADD_METHOD(Class cls ,
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
