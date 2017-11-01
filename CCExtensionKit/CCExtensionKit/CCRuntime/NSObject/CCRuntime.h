//
//  CCRuntime.h
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 15/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(unsigned long , CCAssociationPolicy) {
    CCAssociationPolicy_assign = 0,
    CCAssociationPolicy_retain_nonatomic = 1,
    CCAssociationPolicy_copy_nonatomic = 3,
    CCAssociationPolicy_retain = 01401,
    CCAssociationPolicy_copy = 01403
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

CCQueue CC_MAIN_QUEUE();

@interface CCRuntime : NSObject

/// non-absolute singleton
+ (instancetype) runtime ;

/// original selector , target selector
- (instancetype) ccSwizz : (SEL) selOriginal
                  target : (SEL) selTarget ;
/// interval time , timer action , return yes to stop , cancel action (cancel timer to trigger it);
- (instancetype) ccTimer : (NSTimeInterval) intereval
                  action : (BOOL (^)(void)) action
                  cancel : (void (^)(void)) cancel ;
/// interval time , actions
- (instancetype) ccAfter : (double) seconds
                  action : (void (^)(void)) action ;
/// async to main
- (instancetype) ccAsyncM : (void(^)(void)) action ;
/// sync to main . warning : do NOT deploy it in MAIN QUEUE , other wise will cause lock done .
- (instancetype) ccSyncM : (void(^)(void)) action ;
/// async to specific queue
- (instancetype) ccAsync : (CCQueue) queue
                  action : (void (^)(void)) action ;
/// sync to specific queue , warning : do NOT deploy it in MAIN QUEUE , other wise will cause lock done .
- (instancetype) ccSync : (CCQueue) queue
                 action : (void (^)(void)) action ;
/// equals to dispatch_barrier_async
- (instancetype) ccBarrierAsync : (CCQueue) queue
                         action : (void(^)(void)) action ;
/// equals to dispatch_apply
- (instancetype) ccApplyFor : (CCCount) count
                      queue : (CCQueue) queue
                       time : (void (^)(CCCount t)) time ;
/// equals to objc_setAssociatedObject
- (instancetype) ccSetAssociate : (id) object
                            key : (const void *) key
                          value : (id) value
                         policy : (CCAssociationPolicy) policy;
/// equals to objc_getAssociatedObject
- (id) ccGetAssociate : (id) object
                  key : (const void *) key ;
- (instancetype) ccGetAssociate : (id) object
                            key : (const void *) key
                          value : (void (^)(id t)) value ;

@end

#pragma mark - -----

@interface CCRuntime (CCExtension_Queue)

+ (CCQueue) ccCreate : (const char *) label
             serilal : (BOOL) isSerial ;
+ (CCQueue) ccGlobal : (CCQueueQOS) qos ;

@end

#pragma mark - -----

@protocol CCRunTimeGroupProtocol <NSObject>

@property (nonatomic , strong) CCGroup group;
@property (nonatomic , strong) CCQueue queue;

@end

@interface CCRuntime (CCExtension_Group) < CCRunTimeGroupProtocol >

CCGroup CC_GROUP_INIT();

/// return a new object of CCRuntime , not the shared instance .
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
- (instancetype) ccGetIVar : (Class) cls
                    finish : (void (^)(NSDictionary <NSString * , NSString *> *dictionary)) finish ;
/// add a method with one argument .
- (instancetype) ccAddMethod : (Class) cls
                        name : (NSString *) sName
                   impSupply : (SEL) supply ;

@end
