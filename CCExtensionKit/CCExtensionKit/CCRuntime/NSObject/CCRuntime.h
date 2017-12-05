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
    CCQueueQOS_Default = 0 , // default , not for programmer . use it when you have to reset a serial tasks .
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    CCQueueQOS_User_interaction , // user intercation , will finish as soon as possiable , DO NOT use it for large tasks !
    CCQueueQOS_User_Initiated , // what's user expacted , DO NOT use it for large tasks !
    CCQueueQOS_Utility , // recommended , (also availiable for large tasks)
    CCQueueQOS_Background  , // background tasks .
    CCQueueQOS_Unspecified  // unspecified , wait unit the system to specific one .
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

/// constructor
+ (instancetype) runtime ;

/// class original selector , target selector
void CC_SWIZZ_METHOD(SEL selOriginal ,
                     SEL selTarget ,
                     Class cls) ;

/// interval time , timer action , return yes to stop , cancel action (cancel timer to trigger it);
dispatch_source_t CC_DISPATCH_TIMER(NSTimeInterval interval ,
                                    BOOL (^bAction)(void) ,
                                    void (^bCancel)(void)) ;
/// interval time , actions
dispatch_time_t CC_DISPATCH_AFTER(double fSeconds ,
                                  void (^bAction)(void)) ;
/// async to main
void CC_DISPATCH_ASYNC_M(void (^bAction)(void)) ;
/// sync to main . warning : do NOT deploy it in MAIN QUEUE , other wise will cause lock done .
void CC_DISPATCH_SYNC_M(void (^bAction)(void)) ;
/// async to specific queue
void CC_DISPATCH_ASYNC(CCQueue queue ,
                       void (^bAction)(void)) ;
/// sync to specific queue , warning : do NOT deploy it in MAIN QUEUE , other wise will cause lock done .
void CC_DISPATCH_SYNC(CCQueue queue ,
                      void (^bAction)(void)) ;
/// equals to dispatch_barrier_async
void CC_DISPATCH_BARRIER_ASYNC(CCQueue queue ,
                               void (^bAction)(void)) ;
/// equals to dispatch_apply
void CC_DISPATCH_APPLY_FOR(CCCount count ,
                           CCQueue queue ,
                           void (^bTime)(CCCount t)) ;

/// equals to objc_setAssociatedObject
void CC_DISPATCH_SET_ASSOCIATE(id object ,
                               const void * key ,
                               id value ,
                               CCAssociationPolicy policy) ;
/// equals to objc_getAssociatedObject
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
/// actions for group , can deploy it for muti times
- (instancetype) ccGroupAction : (void (^)(void)) action ;
/// when all group actions finished
- (instancetype) ccNotify : (CCQueue) queue
                   finish : (void(^)(void)) finish ;

/// enter and leave mast use it with a pair
/// enter a group
- (instancetype) ccEnter;
/// leave a group
- (instancetype) ccLeave;
/// do someting after delay .
- (instancetype) ccWait : (CCTime) time ;

@end

#pragma mark - -----

@protocol CCExtensionClassProtocol <NSObject>

/// for some properties that don't want be found .
+ (NSArray <NSString *> *) CCIgnores ;

@end

@interface CCRuntime (CCExtension_Class) 

/// class that want to be found , <types , properties>
void CC_GET_IVAR(Class cls ,
                 void (^bFinish)(NSDictionary <NSString * , NSString *> *dictionary)) ;
/// add a method with one argument .
BOOL CC_DYNAMIC_ADD_METHOD(Class cls ,
                           NSString * sName ,
                           SEL selSupply ,
                           void (^bFail)(void)) ;

@end
