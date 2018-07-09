//
//  CCRuntime.m
//  CCExtensionKit
//
//  Created by Elwinfrederick on 15/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "CCRuntime.h"
#import <objc/runtime.h>
#import <pthread.h>

CCQueue CC_MAIN_QUEUE(void) {
    return dispatch_get_main_queue();
}

void CC_SWIZZ_METHOD(SEL sel_original , SEL sel_target , Class cls) {
    Method om = class_getInstanceMethod(cls, sel_original);
    Method tm = class_getInstanceMethod(cls, sel_target);
    if (class_addMethod(cls,sel_original,method_getImplementation(tm),method_getTypeEncoding(tm))) {
        class_replaceMethod(cls,sel_target,method_getImplementation(om),method_getTypeEncoding(om));
    }
    else method_exchangeImplementations(om, tm);
}

dispatch_source_t CC_DISPATCH_TIMER(NSTimeInterval interval ,
                                    BOOL (^cc_action_block)(void) ,
                                    void (^cc_cancel_block)(void)) {
    if (!cc_action_block) return NULL;
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), interval * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        if (cc_action_block()) dispatch_source_cancel(timer);
    });
    dispatch_source_set_cancel_handler(timer, ^{
        dispatch_group_leave(group);
        if (cc_cancel_block) cc_cancel_block();
    });
    dispatch_resume(timer);
    return timer;
}

dispatch_time_t CC_DISPATCH_AFTER(double f_seconds ,
                                  void (^cc_action_block)(void)) {
    if (!cc_action_block) return 0;
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(f_seconds * NSEC_PER_SEC));
    dispatch_after(time, dispatch_get_main_queue(), ^{
        if (cc_action_block) cc_action_block();
    });
    return time;
}

void CC_DISPATCH_ASYNC_M(void (^cc_action_block)(void)) {
    CC_DISPATCH_ASYNC(dispatch_get_main_queue(), cc_action_block);
}
void CC_DISPATCH_SYNC_M(void (^cc_action_block)(void)) {
    CC_DISPATCH_SYNC(dispatch_get_main_queue(), cc_action_block);
}
void CC_DISPATCH_ASYNC(CCQueue queue , void (^cc_action_block)(void)) {
    if (!queue) return ;
    dispatch_async(queue ? queue : CC_MAIN_QUEUE(), cc_action_block);
}
void CC_DISPATCH_SYNC(CCQueue queue , void (^cc_action_block)(void)) {
    if (pthread_main_np() != 0) {
        if (cc_action_block) cc_action_block();
    }
    else dispatch_sync(queue ? queue : CC_MAIN_QUEUE(), cc_action_block);
}

void CC_DISPATCH_BARRIER_ASYNC(CCQueue queue , void (^cc_action_block)(void)){
    dispatch_barrier_async(queue ? queue : CC_MAIN_QUEUE(), cc_action_block);
}

void CC_DISPATCH_APPLY_FOR(CCCount count , CCQueue queue , void (^cc_time_block)(CCCount t)) {
    dispatch_apply(count, queue ? queue : CC_MAIN_QUEUE(), cc_time_block);
}
void CC_DISPATCH_SET_ASSOCIATE(id object , const void * key , id value , CCAssociationPolicy policy) {
    objc_setAssociatedObject(object, key, value, (objc_AssociationPolicy)policy);
}

id CC_DISPATCH_GET_ASSOCIATE(id object ,
                             const void * key) {
    return objc_getAssociatedObject(object, key);
}
void CC_DISPATCH_GET_ASSOCIATE_B(id object ,
                                 const void * key ,
                                 void (^bValue)(id value)) {
    if (bValue) bValue(CC_DISPATCH_GET_ASSOCIATE(object, key));
}

#pragma mark - ----- 
@import UIKit;

@implementation CCRuntime (CCExtension_Queue)

CCQueue CC_DISPATCH_CREATE_SERIAL(const char * label , BOOL is_serial) {
    if (UIDevice.currentDevice.systemVersion.floatValue >= 10.0) {
        return dispatch_queue_create(label, is_serial ? NULL : DISPATCH_QUEUE_CONCURRENT_WITH_AUTORELEASE_POOL);
    } else return dispatch_queue_create(label, is_serial ? NULL : DISPATCH_QUEUE_CONCURRENT);
}
CCQueue CC_DISPATCH_GLOBAL(CCQueueQOS qos) {
    /// for unsigned long flags , what's DOCs told that , it use for reserves for future needs .
    /// thus , for now , it's always be 0 .
    
    unsigned int qos_t = 0x00; // equals nil / NIL / NULL
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
    switch (qos) {
        case CCQueueQOS_Default:{
            qos_t = DISPATCH_QUEUE_PRIORITY_DEFAULT;
        }break;
        case CCQueueQOS_High:{
            qos_t = DISPATCH_QUEUE_PRIORITY_HIGH;
        }break;
        case CCQueueQOS_Low:{
            qos_t = DISPATCH_QUEUE_PRIORITY_LOW;
        }break;
        case CCQueueQOS_Background:{
            qos_t = DISPATCH_QUEUE_PRIORITY_BACKGROUND;
        }break;
            
        default:{
            qos_t = DISPATCH_QUEUE_PRIORITY_DEFAULT;
        }break;
    }
#else
    switch (qos) {
        case CCQueueQOS_Default:{
            qos_t = QOS_CLASS_DEFAULT;
        }break;
        case CCQueueQOS_User_interaction:{
            qos_t = QOS_CLASS_USER_INTERACTIVE;
        }break;
        case CCQueueQOS_User_Initiated:{
            qos_t = QOS_CLASS_USER_INITIATED;
        }break;
        case CCQueueQOS_Utility:{
            qos_t = QOS_CLASS_UTILITY;
        }break;
        case CCQueueQOS_Background:{
            qos_t = QOS_CLASS_BACKGROUND;
        }break;
        case CCQueueQOS_Unspecified:{
            qos_t = QOS_CLASS_UNSPECIFIED;
        }break;
            
        default:{
            qos_t = QOS_CLASS_DEFAULT;
        }break;
    }
#endif
    return dispatch_get_global_queue(qos_t, 0) ;
}

CCGroup CC_GROUP_INIT(void) {
    return dispatch_group_create();
}

@end

#pragma mark - -----

@interface CCRuntime ()

@end

@implementation CCRuntime

+ (instancetype) runtime {
    return [[self alloc] init];
}

@end

@implementation CCRuntime_Group

- (instancetype) cc_group : (CCGroup) group
                    queue : (CCQueue) queue {
    self.group = group;
    self.queue = queue;
    return self;
}

- (instancetype) cc_group_action : (void (^)(CCRuntime * sender)) action {
    dispatch_group_async(self.group, self.queue, ^{
        if (action) action(self);
    });
    return self;
}

- (instancetype) cc_notify : (CCQueue) queue
                    finish : (void(^)(CCRuntime * sender)) finish {
    dispatch_group_notify(self.group, queue, ^{
        if (finish) finish(self);
    });
    return self;
}

- (instancetype) cc_enter {
    dispatch_group_enter(self.group);
    return self;
}

- (instancetype) cc_leave {
    dispatch_group_leave(self.group);
    return self;
}

- (instancetype) cc_wait : (CCTime) time {
    dispatch_group_wait(self.group, time);
    return self;
}

@end

#pragma mark - -----

void CC_GET_IVAR(Class cls ,
                 void (^cc_finish_block)(NSDictionary <NSString * , NSString *> *dictionary)) {
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
        if ([cls respondsToSelector:NSSelectorFromString(@"cc_ignores")]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            NSArray *a = [cls performSelector:NSSelectorFromString(@"cc_ignores")];
#pragma clang diagnostic pop
            if ([a containsObject:sMember]) continue;
        }
        
        NSString *sMemberType = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivarList[i])]; // output @"NSString"
        sMemberType = [sMemberType stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"@\""]]; // compress
        [dictionary setValue:sMemberType // types can be found multi times , therefore , make it values .
                      forKey:sMember];
    }
    if (cc_finish_block) cc_finish_block(dictionary);
}

BOOL CC_DYNAMIC_ADD_METHOD(Class cls ,
                           NSString * sName ,
                           SEL sel_supply ,
                           void (^cc_fail_block)(void)) {
    BOOL b = class_addMethod(cls,
                             NSSelectorFromString(sName),
                             class_getMethodImplementation(cls, sel_supply),
                             "s@:@");
    if (!b) {
        if (cc_fail_block) cc_fail_block();
    }
    return b;
}
