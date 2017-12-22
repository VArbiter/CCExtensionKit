//
//  CCRuntime.h
//  CCLocalLibrary
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
    CCQueueQOS_Default = 0 ,
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    /// user intercation , will finish as soon as possiable , DO NOT use it for large tasks !
    // 用户操作 , 将尽快完成 , 不要用它做大任务
    CCQueueQOS_User_interaction ,
    /// what's user expacted , DO NOT use it for large tasks !
    // 用户期望 , 不要用它做大任务
    CCQueueQOS_User_Initiated ,
    /// recommended , (also availiable for large tasks)
    // 推荐 , 但也不要用它做大任务
    CCQueueQOS_Utility ,
    /// background tasks .
    // 后台任务
    CCQueueQOS_Background  ,
    /// unspecified , wait unit the system to specific one .
    // 未指定 , 系统将会在完成之前指定的之后再做
    CCQueueQOS_Unspecified
#else
    CCQueueQOS_High = 1,
    CCQueueQOS_Low = 2,
    CCQueueQOS_Background
#endif
};

typedef dispatch_queue_t CCQueue;
typedef dispatch_group_t CCGroup;
typedef dispatch_source_t CCSource;
typedef dispatch_time_t CCTime;
typedef size_t CCCount;

CCQueue CC_MAIN_QUEUE(void);

@interface CCRuntime : NSObject

/// constructor // 构造器
+ (instancetype) runtime ;

/// class original selector , target selector // 原来的方法 , 目标方法
void CC_SWIZZ_METHOD(SEL selOriginal ,
                     SEL selTarget ,
                     Class cls) ;

/// interval time , timer action , return yes to stop , cancel action (cancel timer to trigger it); // 时间 , 动作 , 返回 YES 来停止 , 取消时触发
dispatch_source_t CC_DISPATCH_TIMER(NSTimeInterval interval ,
                                    BOOL (^bAction)(void) ,
                                    void (^bCancel)(void)) ;
/// interval time , actions // 时间 , 动作
dispatch_time_t CC_DISPATCH_AFTER(double fSeconds ,
                                  void (^bAction)(void)) ;
/// async to main , 异步到主线
void CC_DISPATCH_ASYNC_M(void (^bAction)(void)) ;
/// sync to main . warning : do NOT deploy it in MAIN QUEUE , other wise will cause lock done . // 同步到主线 , 警告 : 在主线中使用 , 会引起死锁
void CC_DISPATCH_SYNC_M(void (^bAction)(void)) ;
/// async to specific queue // 异步到指定线程
void CC_DISPATCH_ASYNC(CCQueue queue ,
                       void (^bAction)(void)) ;
/// sync to specific queue , warning : do NOT deploy it in MAIN QUEUE , other wise will cause lock done . // 同步到指定线程 , 警告 : 在主线中使用回调至主线 , 会引起死锁
void CC_DISPATCH_SYNC(CCQueue queue ,
                      void (^bAction)(void)) ;
/// equals to dispatch_barrier_async // 等同于 dispatch_barrier_async
void CC_DISPATCH_BARRIER_ASYNC(CCQueue queue ,
                               void (^bAction)(void)) ;
/// equals to dispatch_apply // 等同于 dispatch_apply
void CC_DISPATCH_APPLY_FOR(CCCount count ,
                           CCQueue queue ,
                           void (^bTime)(CCCount t)) ;

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

@end

#pragma mark - -----

@interface CCRuntime (CCExtension_Queue)

CCQueue CC_DISPATCH_CREATE_SERIAL(const char * label , BOOL isSerial) ;
CCQueue CC_DISPATCH_GLOBAL(CCQueueQOS qos) ;

@end

#pragma mark - -----

@interface CCRuntime (CCExtension_Group)

CCGroup CC_GROUP_INIT(void);

@property (nonatomic) CCGroup group;
@property (nonatomic) CCQueue queue;

- (instancetype) ccGroup : (CCGroup) group
                   queue : (CCQueue) queue ;
/// actions for group , can deploy it for muti times // group 的动作 , 可以多次添加
- (instancetype) ccGroupAction : (void (^)(CCRuntime * sender)) action ;
/// when all group actions finished // 当组中所有任务完成时调用
- (instancetype) ccNotify : (CCQueue) queue
                   finish : (void(^)(CCRuntime * sender)) finish ;

/// enter and leave mast use it with a pair // 进入和离开必须成对调用
/// enter a group // 进入组
- (instancetype) ccEnter;
/// leave a group // 离开组
- (instancetype) ccLeave;
/// do someting after delay . // 在延迟后做操作
- (instancetype) ccWait : (CCTime) time ;

@end

#pragma mark - -----

@protocol CCExtensionClassProtocol <NSObject>

/// for some properties that don't want be found . // 针对一些不想被找到的属性
+ (NSArray <NSString *> *) CCIgnores ;

@end

@interface CCRuntime (CCExtension_Class) 

/// class that want to be found , <types , properties> // 针对查找的类
void CC_GET_IVAR(Class cls ,
                 void (^bFinish)(NSDictionary <NSString * , NSString *> *dictionary)) ;
/// add a method with one argument . // 添加一个有参数的方法
BOOL CC_DYNAMIC_ADD_METHOD(Class cls ,
                           NSString * sName ,
                           SEL selSupply ,
                           void (^bFail)(void)) ;

@end
