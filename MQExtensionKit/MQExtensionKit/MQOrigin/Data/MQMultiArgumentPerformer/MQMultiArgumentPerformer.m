//
//  MQMultiArgumentPerformer.m
//  MQExtension_Example
//
//  Created by ElwinFrederick on 2018/8/2.
//  Copyright © 2018 ElwinFrederick. All rights reserved.
//

#import "MQMultiArgumentPerformer.h"

@interface MQMultiArgumentPerformer ()

@property (nonatomic , strong , readwrite) NSPointerArray *array_pointer ;
@property (nonatomic , strong) NSInvocation *invocation ;

@end

@implementation MQMultiArgumentPerformer

- (instancetype) init_object : (id) obj
                      method : (SEL) selector {
    if ((self = [super init])) {
        if (obj) {
            NSMethodSignature *singture = [[obj class] instanceMethodSignatureForSelector:selector];
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:singture];
            [invocation setTarget:obj];
            [invocation setSelector:selector];
            self.invocation = invocation;
        }
    }
    return self;
}

- (instancetype) init_class : (Class) clz
                     method : (SEL) selector {
    if ((self = [super init])) {
        if (clz) {
            NSMethodSignature *singture = [clz methodSignatureForSelector:selector];
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:singture];
            [invocation setTarget:clz];
            [invocation setSelector:selector];
            self.invocation = invocation;
        }
    }
    return self;
}

- (void) mq_add_argument : (void *) argument {
    [self.array_pointer addPointer:argument];
}

- (MQMultiArgumentPerformer *(^)(void *))mq_add {
    __weak typeof(self) weak_self = self;
    return ^MQMultiArgumentPerformer *(void * p) {
        __strong typeof(self) strong_self = weak_self;
        [strong_self mq_add_argument:p];
        return strong_self;
    };
}

- (void) mq_clear_NULLs {
    [_array_pointer compact];
}

- (void) mq_excute : (BOOL) is_need_nulls {
    if (!is_need_nulls) { [self mq_clear_NULLs]; }
    NSUInteger i_count = self.array_pointer.count;
    for (NSUInteger i = 0; i < i_count; i++) {
        void * temp = [self.array_pointer pointerAtIndex:i];
        
        // 0 is target , 1 is _cmd itself .
        // 0 是执行的 目标 , 1 是方法本身 .
        [self.invocation setArgument:temp atIndex:i + 2];
    }
    
    // retain all arguments . prevent it dealloc too early .
    // 对所有 参数 进行 retain , 防止被过早释放 .
    [self.invocation retainArguments];
    [self.invocation invoke];
}

- (NSPointerArray *)array_pointer {
    if (_array_pointer) return _array_pointer;
    NSPointerArray *t = [[NSPointerArray alloc] initWithOptions:NSPointerFunctionsWeakMemory];
    _array_pointer = t;
    return _array_pointer;}

@end
