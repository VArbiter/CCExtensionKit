//
//  NSLock+CCExtension.h
//  CCLocalLibrary
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

+ (instancetype) cc_commmon ;

/// wrapper for "tryLock" && "unlock" . // 针对 "tryLock" && "unlock" 的包裹
- (BOOL) cc_lock : (void (^)(void (^cc_complete_block)(CCUnlockType type))) cc_lock_operate_block;
/// wrapper for "lockBeforeDate:" && "unlock" . // 针对 "lockBeforeDate:" && "unlock" 的包裹
- (BOOL) cc_locked_before : (NSDate *) date
                operation : (void (^)(void (^cc_complete_block)(CCUnlockType type))) cc_lock_operate_block;

@end

@interface NSRecursiveLock (CCExtension)

+ (instancetype) cc_commmon ;

/// wrapper for "tryLock" && "unlock" . // 针对 "tryLock" && "unlock" 的包裹
- (BOOL) cc_lock : (void (^)(void (^cc_complete_block)(CCUnlockType type))) cc_lock_operate_block;
/// wrapper for "lockBeforeDate:" && "unlock" . // 针对 "lockBeforeDate:" && "unlock" 的包裹
- (BOOL) cc_locked_before : (NSDate *) date
                operation : (void (^)(void (^cc_complete_block)(CCUnlockType type))) cc_lock_operate_block;

@end

@interface NSConditionLock (CCExtension)

+ (instancetype) cc_common : (NSInteger) i_condition ;

/// wrapper for "tryLockWhenCondition:" && "unlockWithCondition:" .
// 针对 "tryLockWhenCondition:" && "unlockWithCondition:"  的包裹
- (BOOL) cc_lock : (NSInteger) i_condition
       operation : (void (^)(void (^cc_complete_block)(CCUnlockType type))) cc_lock_operate_block;

/// wrapper for "lockWhenCondition:beforeDate:" && "unlockWithCondition:" .
// 针对 "lockWhenCondition:beforeDate:" && "unlockWithCondition:" 的包裹
- (BOOL) cc_lock : (NSInteger) i_condition
          before : (NSDate *) date
       operation : (void (^)(void (^cc_complete_block)(CCUnlockType type))) cc_lock_operate_block;

@end

@interface NSCondition (CCExtension)

/// stored all conditions that created by "cc_common"
@property (nonatomic , class , strong , readonly) NSMutableArray <__kindof NSCondition *> *array_all_conditions ;

+ (instancetype) cc_common ;

/// set a tag to condition . (repeatable) // 给 condition 打标签 (可重复)
@property (nonatomic , assign) NSInteger i_tag ;

/// get all the conditions with the same tag in "array_all_conditions" .
// 获得所有在 "array_all_conditions" 储存的具有相同标签的 condition
+ (NSSet <__kindof NSCondition *> *) cc_search_condition_with_tag : (NSInteger) i_tag ;
/// get all the conditions with the same name in "array_all_conditions" .
// 获得所有在 "array_all_conditions" 储存的具有相同名称的 condition
+ (NSSet <__kindof NSCondition *> *) cc_search_condition_with_name : (NSString *) s_name ;

/// release a condition . // 销毁一个 condition 
void cc_condition_release(__kindof NSCondition *) ;

@end
