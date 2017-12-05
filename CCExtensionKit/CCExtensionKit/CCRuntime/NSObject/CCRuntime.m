//
//  CCRuntime.m
//  CCLocalLibrary
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

@interface CCRuntime ()

@end

@implementation CCRuntime

+ (instancetype) runtime {
    return [[self alloc] init];
}

void CC_SWIZZ_METHOD(SEL selOriginal , SEL selTarget , Class cls) {
    Method om = class_getInstanceMethod(cls, selOriginal);
    Method tm = class_getInstanceMethod(cls, selTarget);
    if (class_addMethod(cls,selOriginal,method_getImplementation(tm),method_getTypeEncoding(tm))) {
        class_replaceMethod(cls,selTarget,method_getImplementation(om),method_getTypeEncoding(om));
    }
    else method_exchangeImplementations(om, tm);
}

dispatch_source_t CC_DISPATCH_TIMER(NSTimeInterval interval ,
                                    BOOL (^bAction)(void) ,
                                    void (^bCancel)(void)) {
    if (!bAction) return NULL;
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), interval * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        if (bAction()) dispatch_source_cancel(timer);
    });
    dispatch_source_set_cancel_handler(timer, ^{
        dispatch_group_leave(group);
        if (bCancel) bCancel();
    });
    dispatch_resume(timer);
    return timer;
}

dispatch_time_t CC_DISPATCH_AFTER(double fSeconds ,
                                  void (^bAction)(void)) {
    if (!bAction) return 0;
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(fSeconds * NSEC_PER_SEC));
    dispatch_after(time, dispatch_get_main_queue(), ^{
        if (bAction) bAction();
    });
    return time;
}

void CC_DISPATCH_ASYNC_M(void (^bAction)(void)) {
    CC_DISPATCH_ASYNC(dispatch_get_main_queue(), bAction);
}
void CC_DISPATCH_SYNC_M(void (^bAction)(void)) {
    CC_DISPATCH_SYNC(dispatch_get_main_queue(), bAction);
}
void CC_DISPATCH_ASYNC(CCQueue queue , void (^bAction)(void)) {
    if (!queue) return ;
    dispatch_async(queue ? queue : CC_MAIN_QUEUE(), bAction);
}
void CC_DISPATCH_SYNC(CCQueue queue , void (^bAction)(void)) {
    if (pthread_main_np() != 0) {
        if (bAction) bAction();
    }
    else dispatch_sync(queue ? queue : CC_MAIN_QUEUE(), bAction);
}

void CC_DISPATCH_BARRIER_ASYNC(CCQueue queue , void (^bAction)(void)){
    dispatch_barrier_async(queue ? queue : CC_MAIN_QUEUE(), bAction);
}

void CC_DISPATCH_APPLY_FOR(CCCount count , CCQueue queue , void (^bTime)(CCCount t)) {
    dispatch_apply(count, queue ? queue : CC_MAIN_QUEUE(), bTime);
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

@end

#pragma mark - ----- 
@import UIKit;

@implementation CCRuntime (CCExtension_Queue)

CCQueue CC_DISPATCH_CREATE_SERIAL(const char * label , BOOL isSerial) {
    if (UIDevice.currentDevice.systemVersion.floatValue >= 10.0) {
        return dispatch_queue_create(label, isSerial ? NULL : DISPATCH_QUEUE_CONCURRENT_WITH_AUTORELEASE_POOL);
    } else return dispatch_queue_create(label, isSerial ? NULL : DISPATCH_QUEUE_CONCURRENT);
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

@end

#pragma mark - -----

@implementation CCRuntime (CCExtension_Group)

- (void)setGroup:(CCGroup)group {
    objc_setAssociatedObject(self, "_CC_RUNTIME_ASSOCIATE_GROUP_ACTION_GROUP_", group, OBJC_ASSOCIATION_ASSIGN);
}
- (CCGroup)group {
    return objc_getAssociatedObject(self, "_CC_RUNTIME_ASSOCIATE_GROUP_ACTION_GROUP_");
}
- (void)setQueue:(CCQueue)queue {
    objc_setAssociatedObject(self, "_CC_RUNTIME_ASSOCIATE_GROUP_ACTION_QUEUE_", queue, OBJC_ASSOCIATION_ASSIGN);
}
- (CCQueue)queue {
    return objc_getAssociatedObject(self, "_CC_RUNTIME_ASSOCIATE_GROUP_ACTION_QUEUE_");
}

CCGroup CC_GROUP_INIT(void) {
    return dispatch_group_create();
}

- (instancetype) ccGroup : (CCGroup) group
                   queue : (CCQueue) queue {
    self.group = group;
    self.queue = queue;
    return self;
}

- (instancetype) ccGroupAction : (void (^)(void)) action {
    dispatch_group_async(self.group, self.queue, action);
    return self;
}

- (instancetype) ccNotify : (CCQueue) queue
                   finish : (void(^)(void)) finish {
    dispatch_group_notify(self.group, queue, finish);
    return self;
}

- (instancetype) ccEnter {
    dispatch_group_enter(self.group);
    return self;
}

- (instancetype) ccLeave {
    dispatch_group_leave(self.group);
    return self;
}

- (instancetype) ccWait : (CCTime) time {
    dispatch_group_wait(self.group, time);
    return self;
}

@end

#pragma mark - -----

@implementation CCRuntime (CCExtension_Class)

void CC_GET_IVAR(Class cls ,
                 void (^bFinish)(NSDictionary <NSString * , NSString *> *dictionary)) {
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
        if ([cls respondsToSelector:NSSelectorFromString(@"CCIgnores")]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            NSArray *a = [cls performSelector:NSSelectorFromString(@"CCIgnores")];
#pragma clang diagnostic pop
            if ([a containsObject:sMember]) continue;
        }
        
        NSString *sMemberType = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivarList[i])]; // output @"NSString"
        sMemberType = [sMemberType stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"@\""]]; // compress
        [dictionary setValue:sMemberType // types can be found multi times , therefore , make it values .
                      forKey:sMember];
    }
    if (bFinish) bFinish(dictionary);
}

BOOL CC_DYNAMIC_ADD_METHOD(Class cls ,
                           NSString * sName ,
                           SEL selSupply ,
                           void (^bFail)(void)) {
    BOOL b = class_addMethod(cls,
                             NSSelectorFromString(sName),
                             class_getMethodImplementation(cls, selSupply),
                             "s@:@");
    if (!b) {
        if (bFail) bFail();
    }
    return b;
}

@end
