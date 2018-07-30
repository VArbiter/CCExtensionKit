//
//  NSLock+MQExtension.h
//  MQExtensionKit
//
//  Created by ElwinFrederick on 2018/7/9.
//  Copyright © 2018 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger , CCUnlockType) {
    CCUnlockType_Ignore = 0, // default , do nothing . // 默认 , 什么也不做
    CCUnlockType_Auto // auto unlock when invoke complete block . // 调用 完成 block 自动解锁 ;
};

@interface NSLock (CCExtension)

+ (instancetype) mq_commmon ;

/// wrapper for "tryLock" && "unlock" . // 针对 "tryLock" && "unlock" 的包裹
- (BOOL) mq_lock : (void (^)(void (^mq_complete_block)(CCUnlockType type))) mq_lock_operate_block;
/// wrapper for "lockBeforeDate:" && "unlock" . // 针对 "lockBeforeDate:" && "unlock" 的包裹
- (BOOL) mq_locked_before : (NSDate *) date
                operation : (void (^)(void (^mq_complete_block)(CCUnlockType type))) mq_lock_operate_block;

@end

@interface NSRecursiveLock (CCExtension)

+ (instancetype) mq_commmon ;

/// wrapper for "tryLock" && "unlock" . // 针对 "tryLock" && "unlock" 的包裹
- (BOOL) mq_lock : (void (^)(void (^mq_complete_block)(CCUnlockType type))) mq_lock_operate_block;
/// wrapper for "lockBeforeDate:" && "unlock" . // 针对 "lockBeforeDate:" && "unlock" 的包裹
- (BOOL) mq_locked_before : (NSDate *) date
                operation : (void (^)(void (^mq_complete_block)(CCUnlockType type))) mq_lock_operate_block;

@end

@interface NSConditionLock (CCExtension)

+ (instancetype) mq_common : (NSInteger) i_condition ;

/// wrapper for "tryLockWhenCondition:" && "unlockWithCondition:" .
// 针对 "tryLockWhenCondition:" && "unlockWithCondition:"  的包裹
- (BOOL) mq_lock : (NSInteger) i_condition
       operation : (void (^)(void (^mq_complete_block)(CCUnlockType type))) mq_lock_operate_block;

/// wrapper for "lockWhenCondition:beforeDate:" && "unlockWithCondition:" .
// 针对 "lockWhenCondition:beforeDate:" && "unlockWithCondition:" 的包裹
- (BOOL) mq_lock : (NSInteger) i_condition
          before : (NSDate *) date
       operation : (void (^)(void (^mq_complete_block)(CCUnlockType type))) mq_lock_operate_block;

@end

/// NSCondition was more like the relative with producter && consumer .
// NSCondition 更多的是针对 类似生产者和消费者的问题
/// dispatch_semaphore_t was more like the full parking lot facing a new come .
// dispatch_semaphore_t 更多的是针对满停车场面对新来的车的时候 .

@interface NSCondition (CCExtension)

/// stored all conditions that created by "mq_common"
@property (nonatomic , class , strong , readonly) NSMutableArray <__kindof NSCondition *> *array_all_conditions ;

+ (instancetype) mq_common ;

/// set a tag to condition . (repeatable) // 给 condition 打标签 (可重复)
@property (nonatomic , assign) NSInteger i_tag ;

/// get all the conditions with the same tag in "array_all_conditions" .
// 获得所有在 "array_all_conditions" 储存的具有相同标签的 condition
+ (NSSet <__kindof NSCondition *> *) mq_search_condition_with_tag : (NSInteger) i_tag ;
/// get all the conditions with the same name in "array_all_conditions" .
// 获得所有在 "array_all_conditions" 储存的具有相同名称的 condition
+ (NSSet <__kindof NSCondition *> *) mq_search_condition_with_name : (NSString *) s_name ;

/// release a condition . // 销毁一个 condition 
void mq_condition_release(__kindof NSCondition *) ;

@end
