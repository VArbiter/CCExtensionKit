//
//  MQRuntime.h
//  MQExtensionKit
//
//  Created by Elwinfrederick on 15/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

typedef NS_ENUM(unsigned long , MQAssociationPolicy) {
    MQAssociationPolicy_assign = OBJC_ASSOCIATION_ASSIGN,
    MQAssociationPolicy_retain_nonatomic = OBJC_ASSOCIATION_RETAIN_NONATOMIC,
    MQAssociationPolicy_copy_nonatomic = OBJC_ASSOCIATION_COPY_NONATOMIC,
    MQAssociationPolicy_retain = OBJC_ASSOCIATION_RETAIN,
    MQAssociationPolicy_copy = OBJC_ASSOCIATION_COPY
};

typedef NS_ENUM(unsigned int , MQQueueQOS) {
    /// default , not for programmer . use it when you have to reset a serial tasks .
    // 默认 , 不是针对开发者来说 , 当重置队列任务时使用
    MQQueue_Default = 0 ,
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    /// user intercation , will finish as soon as possiable , DO NOT use it for large tasks !
    // 用户操作 , 将尽快完成 , 不要用它做大任务
    MQQueue_User_interaction ,
    /// what's user expacted , DO NOT use it for large tasks !
    // 用户期望 , 不要用它做大任务
    MQQueue_User_Initiated ,
    /// recommended , (also availiable for large tasks)
    // 推荐 , 但也不要用它做大任务
    MQQueue_Utility ,
    /// background tasks .
    // 后台任务
    MQQueue_Background  ,
    /// unspecified , wait unit the system to specific one .
    // 未指定 , 系统将会在完成之前指定的之后再做
    MQQueue_Unspecified
#else
    MQQueue_High = 1,
    MQQueue_Low = 2,
    MQQueue_Background
#endif
};

dispatch_queue_t mq_main_queue(void);

/// notify you whether this operation was excuted on main thread . // 通知你这个操作是否是在主线程执行
/// returns if this operation was excuted on main thread . // 返回这个任务是否是在主线程执行
BOOL mq_is_main_queue(void);

/// class original selector , target selector // 原来的方法 , 目标方法
void mq_swizz_method(SEL sel_original ,
                     SEL sel_target ,
                     Class cls) ;

/// interval time , timer action , return yes to stop , cancel action (cancel timer to trigger it); // 时间 , 动作 , 返回 YES 来停止 , 取消时触发
dispatch_source_t mq_dispatch_timer(NSTimeInterval interval ,
                                    BOOL (^mq_action_block)(void) ,
                                    void (^mq_cancel_block)(void)) ;
/// interval time , actions // 时间 , 动作
dispatch_time_t mq_dispatch_after(double f_seconds ,
                         void (^mq_action_block)(void)) ;
/// async to main , 异步到主线
void mq_dispatch_async_m(void (^mq_action_block)(void)) ;
/// sync to main . warning : do NOT invoke it in MAIN QUEUE , other wise will cause lock done . // 同步到主线 , 警告 : 在主线中使用 , 会引起死锁
void mq_dispatch_sync_m(void (^mq_action_block)(void)) ;
/// async to specific queue // 异步到指定线程
void mq_dispatch_async(dispatch_queue_t queue ,
                       void (^mq_action_block)(void)) ;
/// sync to specific queue , warning : do NOT invoke it in MAIN QUEUE , other wise will cause lock done . // 同步到指定线程 , 警告 : 在主线中使用回调至主线 , 会引起死锁
void mq_dispatch_sync(dispatch_queue_t queue ,
                      void (^mq_action_block)(void)) ;
/// equals to dispatch_barrier_async // 等同于 dispatch_barrier_async
void mq_dispatch_barrier_async(dispatch_queue_t queue ,
                               void (^mq_action_block)(void)) ;
/// equals to dispatch_apply // 等同于 dispatch_apply
void mq_dispatch_apply_for(size_t count ,
                           dispatch_queue_t queue ,
                           void (^mq_time_block)(size_t t)) ;

/// equals to objc_setAssociatedObject // 等同于 objc_setAssociatedObject
void mq_dispatch_set_associate(id object ,
                               const void * key ,
                               id value ,
                               MQAssociationPolicy policy) ;
/// equals to objc_getAssociatedObject // 等同于 objc_getAssociatedObject
id mq_dispatch_get_associate(id object ,
                             const void * key) ;
void mq_dispatch_get_associate_b(id object ,
                                 const void * key ,
                                 void (^bValue)(id value)) ;

#pragma mark - ----- Queue

dispatch_queue_t mq_dispatch_create_serial(const char * label , BOOL is_serial) ;
dispatch_queue_t mq_dispatch_global(MQQueueQOS qos) ;

dispatch_group_t mq_group_init(void);

#pragma mark - ----- LOCK
dispatch_semaphore_t mq_semaphore_init(long value) ;
dispatch_semaphore_t mq_semaphore_init_t(void) ;
long mq_semaphore_lock(dispatch_semaphore_t lock);
long mq_semaphore_unlock(dispatch_semaphore_t lock);

#pragma mark - ----- Class

@protocol MQExtensionClassProtocol <NSObject>

/// for some properties that don't want to be found . // 针对一些不想被找到的属性
+ (NSArray <NSString *> *) mq_ignores ;

@end

/// class that want to be found , <types , properties> // 针对查找的类
void mq_get_ivar(Class cls ,
                 void (^mq_finish_block)(NSDictionary <NSString * , NSString *> *dictionary)) ;
/// add a method with one argument . // 添加一个有参数的方法
BOOL mq_dynamic_add_method(Class cls ,
                           NSString * sName ,
                           SEL sel_supply ,
                           void (^mq_fail_block)(void)) ;
