//
//  NSLock+CCExtension.m
//  CCLocalLibrary
//
//  Created by ElwinFrederick on 2018/7/9.
//  Copyright © 2018 冯明庆. All rights reserved.
//

#import "NSLock+CCExtension.h"

#import <objc/runtime.h>

@implementation NSLock (CCExtension)

+ (instancetype) cc_commmon {
    return [[self alloc] init];
}

- (BOOL) cc_lock : (void (^)(void (^cc_complete_block)(CCUnlockType type))) cc_lock_operate_block; {
    BOOL is_locked = [self tryLock];
    __block BOOL is_excuted = false;
    if (is_locked) {
        if (cc_lock_operate_block) {
            cc_lock_operate_block(^(CCUnlockType type){
                if (type == CCUnlockType_Auto) {
                    [self unlock];
                }
                is_excuted = YES;
            });
        }
        if (!is_excuted) [self unlock];
    }
    return is_locked;
}

- (BOOL) cc_locked_before : (NSDate *) date
                operation : (void (^)(void (^cc_complete_block)(CCUnlockType type))) cc_lock_operate_block;{
    if (!date) return false;
    BOOL is_locked = [self lockBeforeDate:date];
    __block BOOL is_excuted = false;
    if (is_locked) {
        if (cc_lock_operate_block) {
            cc_lock_operate_block(^(CCUnlockType type){
                if (type == CCUnlockType_Auto) {
                    [self unlock];
                }
                is_excuted = YES;
            });
        }
        if (!is_excuted) [self unlock];
    }
    return is_locked;
}

@end

@implementation NSRecursiveLock (CCExtension)

+ (instancetype) cc_commmon {
    return [[self alloc] init];
}

- (BOOL) cc_lock : (void (^)(void (^cc_complete_block)(CCUnlockType type))) cc_lock_operate_block; {
    BOOL is_locked = [self tryLock];
    __block BOOL is_excuted = false;
    if (is_locked) {
        if (cc_lock_operate_block) {
            cc_lock_operate_block(^(CCUnlockType type){
                if (type == CCUnlockType_Auto) {
                    [self unlock];
                }
                is_excuted = YES;
            });
        }
        if (!is_excuted) [self unlock];
    }
    return is_locked;
}

- (BOOL) cc_locked_before : (NSDate *) date
                operation : (void (^)(void (^cc_complete_block)(CCUnlockType type))) cc_lock_operate_block;{
    if (!date) return false;
    BOOL is_locked = [self lockBeforeDate:date];
    __block BOOL is_excuted = false;
    if (is_locked) {
        if (cc_lock_operate_block) {
            cc_lock_operate_block(^(CCUnlockType type){
                if (type == CCUnlockType_Auto) {
                    [self unlock];
                }
                is_excuted = YES;
            });
        }
        if (!is_excuted) [self unlock];
    }
    return is_locked;
}

@end

@implementation NSConditionLock (CCExtension)

+ (instancetype) cc_common : (NSInteger) i_condition {
    return [[self alloc] initWithCondition:i_condition];
}

- (BOOL) cc_lock : (NSInteger) i_condition
       operation : (void (^)(void (^cc_complete_block)(CCUnlockType type))) cc_lock_operate_block {
    BOOL is_locked = [self tryLockWhenCondition:i_condition];
    __block BOOL is_excuted = false;
    if (is_locked) {
        if (cc_lock_operate_block) {
            cc_lock_operate_block(^(CCUnlockType type){
                if (type == CCUnlockType_Auto) {
                    [self unlockWithCondition:i_condition];
                }
                is_excuted = YES;
            });
        }
        if (!is_excuted) [self unlockWithCondition:i_condition];
    }
    return is_locked;
}

- (BOOL) cc_lock : (NSInteger) i_condition
          before : (NSDate *) date
       operation : (void (^)(void (^cc_complete_block)(CCUnlockType type))) cc_lock_operate_block {
    if (!date) return false;
    
    BOOL is_locked = [self lockWhenCondition:i_condition
                                  beforeDate:date];
    __block BOOL is_excuted = false;
    if (is_locked) {
        if (cc_lock_operate_block) {
            cc_lock_operate_block(^(CCUnlockType type){
                if (type == CCUnlockType_Auto) {
                    [self unlockWithCondition:i_condition];
                }
                is_excuted = YES;
            });
        }
        if (!is_excuted) [self unlockWithCondition:i_condition];
    }
    return is_locked;
}

@end

@implementation NSCondition (CCExtension)

static NSMutableArray * __array_all_conditions = nil;
+ (NSMutableArray<NSCondition *> *)array_all_conditions {
    if (__array_all_conditions) return __array_all_conditions;
    __array_all_conditions = [NSMutableArray array];
    return __array_all_conditions;
}

+ (instancetype) cc_common {
    id t = [[self alloc] init];
    if (t) [NSCondition.array_all_conditions addObject:t];
    return t;
}

- (void)setI_tag:(NSInteger)i_tag {
    objc_setAssociatedObject(self, @selector(i_tag), @(i_tag), OBJC_ASSOCIATION_ASSIGN);
}
- (NSInteger)i_tag {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

+ (NSSet <__kindof NSCondition *> *) cc_search_condition_with_tag : (NSInteger) i_tag {
    
    NSMutableSet *set = [NSMutableSet set];
    [self.array_all_conditions enumerateObjectsUsingBlock:^(NSCondition * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.i_tag == i_tag) {
            if (obj) [set addObject:obj];
        }
    }];
    return set;
}
+ (NSSet <__kindof NSCondition *> *) cc_search_condition_with_name : (NSString *) s_name {
    
    if (!s_name || s_name.length) return [NSSet set];
    
    NSMutableSet *set = [NSMutableSet set];
    [self.array_all_conditions enumerateObjectsUsingBlock:^(NSCondition * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.name isEqualToString:s_name]) {
            if (obj) [set addObject:obj];
        }
    }];
    return set;
}

void cc_condition_release(__kindof NSCondition * condition) {
    if (!condition) return ;
    [NSCondition.array_all_conditions removeObject:condition];
    condition = nil;
}

@end
