//
//  CCRuntime.h
//  CCExtensionKit
//
//  Created by Elwinfrederick on 15/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

typedef NS_ENUM(unsigned long , CCAssociationPolicy) {
    CCAssociationPolicy_assign = OBJC_ASSOCIATION_ASSIGN,
    CCAssociationPolicy_retain_nonatomic = OBJC_ASSOCIATION_RETAIN_NONATOMIC,
    CCAssociationPolicy_copy_nonatomic = OBJC_ASSOCIATION_COPY_NONATOMIC,
    CCAssociationPolicy_retain = OBJC_ASSOCIATION_RETAIN,
    CCAssociationPolicy_copy = OBJC_ASSOCIATION_COPY
};

typedef NS_ENUM(unsigned int , CCQueueQOS) {
    /// default , not for programmer . use it when you have to reset a serial tasks .
    // 默认 , 不是针对开发者来说 , 当重置队列任务时使用
    CCQueue_Default = 0 ,
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    /// user intercation , will finish as soon as possiable , DO NOT use it for large tasks !
    // 用户操作 , 将尽快完成 , 不要用它做大任务
    CCQueue_User_interaction ,
    /// what's user expacted , DO NOT use it for large tasks !
    // 用户期望 , 不要用它做大任务
    CCQueue_User_Initiated ,
    /// recommended , (also availiable for large tasks)
    // 推荐 , 但也不要用它做大任务
    CCQueue_Utility ,
    /// background tasks .
    // 后台任务
    CCQueue_Background  ,
    /// unspecified , wait unit the system to specific one .
    // 未指定 , 系统将会在完成之前指定的之后再做
    CCQueue_Unspecified
#else
    CCQueue_High = 1,
    CCQueue_Low = 2,
    CCQueue_Background
#endif
};

dispatch_queue_t CC_MAIN_QUEUE(void);

/// class original selector , target selector // 原来的方法 , 目标方法
void CC_SWIZZ_METHOD(SEL sel_original ,
                     SEL sel_target ,
                     Class cls) ;

/// interval time , timer action , return yes to stop , cancel action (cancel timer to trigger it); // 时间 , 动作 , 返回 YES 来停止 , 取消时触发
dispatch_source_t CC_DISPATCH_TIMER(NSTimeInterval interval ,
                                    BOOL (^cc_action_block)(void) ,
                                    void (^cc_cancel_block)(void)) ;
/// interval time , actions // 时间 , 动作
dispatch_time_t CC_DISPATCH_AFTER(double f_seconds ,
                         void (^cc_action_block)(void)) ;
/// async to main , 异步到主线
void CC_DISPATCH_ASYNC_M(void (^cc_action_block)(void)) ;
/// sync to main . warning : do NOT invoke it in MAIN QUEUE , other wise will cause lock done . // 同步到主线 , 警告 : 在主线中使用 , 会引起死锁
void CC_DISPATCH_SYNC_M(void (^cc_action_block)(void)) ;
/// async to specific queue // 异步到指定线程
void CC_DISPATCH_ASYNC(dispatch_queue_t queue ,
                       void (^cc_action_block)(void)) ;
/// sync to specific queue , warning : do NOT invoke it in MAIN QUEUE , other wise will cause lock done . // 同步到指定线程 , 警告 : 在主线中使用回调至主线 , 会引起死锁
void CC_DISPATCH_SYNC(dispatch_queue_t queue ,
                      void (^cc_action_block)(void)) ;
/// equals to dispatch_barrier_async // 等同于 dispatch_barrier_async
void CC_DISPATCH_BARRIER_ASYNC(dispatch_queue_t queue ,
                               void (^cc_action_block)(void)) ;
/// equals to dispatch_apply // 等同于 dispatch_apply
void CC_DISPATCH_APPLY_FOR(size_t count ,
                           dispatch_queue_t queue ,
                           void (^cc_time_block)(size_t t)) ;

/// equals to objc_setAssociatedObject // 等同于 objc_setAssociatedObject
void CC_DISPATCH_SET_ASSOCIATE(id object ,
                               const void * key ,
                               id value ,
                               CCAssociationPolicy policy) ;
/// equals to objc_getAssociatedObject // 等同于 objc_getAssociatedObject
id CC_DISPATCH_GET_ASSOCIATE(id object ,
                             const void * key) ;
void CC_DISPATCH_GET_ASSOCIATE_B(id object ,
                                 const void * key ,
                                 void (^bValue)(id value)) ;

#pragma mark - ----- Queue

dispatch_queue_t CC_DISPATCH_CREATE_SERIAL(const char * label , BOOL is_serial) ;
dispatch_queue_t CC_DISPATCH_GLOBAL(CCQueueQOS qos) ;

dispatch_group_t CC_GROUP_INIT(void);

#pragma mark - ----- Class

@protocol CCExtensionClassProtocol <NSObject>

/// for some properties that don't want to be found . // 针对一些不想被找到的属性
+ (NSArray <NSString *> *) cc_ignores ;

@end

/// class that want to be found , <types , properties> // 针对查找的类
void CC_GET_IVAR(Class cls ,
                 void (^cc_finish_block)(NSDictionary <NSString * , NSString *> *dictionary)) ;
/// add a method with one argument . // 添加一个有参数的方法
BOOL CC_DYNAMIC_ADD_METHOD(Class cls ,
                           NSString * sName ,
                           SEL sel_supply ,
                           void (^cc_fail_block)(void)) ;
