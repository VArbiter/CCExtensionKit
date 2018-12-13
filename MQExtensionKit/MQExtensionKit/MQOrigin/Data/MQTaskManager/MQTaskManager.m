//
//  MQTaskManager.m
//  MQExtensionKit
//
//  Created by ElwinFrederick on 2018/6/25.
//  Copyright © 2018 冯明庆. All rights reserved.
//

#import "MQTaskManager.h"

@interface MQTaskManager ()

@property (nonatomic , strong , readwrite) NSMutableArray <MQTaskObject *> *array_tasks ;
@property (nonatomic , readwrite) dispatch_queue_t queue_current ;

@property (nonatomic , assign) BOOL is_running ;

- (void) mq_sorted_added : (id) t ;

@end

@implementation MQTaskManager

- (instancetype) init_with_async_thread : (dispatch_queue_t) queue {
    if ((self = [super init])) {
        self.queue_current = queue;
        self.is_running = false;
    }
    return self;
}

- (void) mq_add_tasks : (NSArray < __kindof MQTaskObject *> *) objects
        remain_status : (BOOL) is_remain {
    if (objects && objects.count) {
        
        if (is_remain) {
            if (self.is_running) {
                [self mq_pause];
                [self mq_sorted_added:objects];
                [self mq_resume];
            }
            else {
                [self mq_sorted_added:objects];
            }
        }
        else {
            if (self.is_running) {
                [self mq_pause];
                [self mq_sorted_added:objects];
            }
            else {
                [self mq_sorted_added:objects];
                [self mq_resume];
            }
        }
        
    }
}
- (void) mq_add_task : (__kindof MQTaskObject *) object
       remain_status : (BOOL) is_remain {
    if (object && [object isKindOfClass:[MQTaskObject class]]) {
        if (is_remain) {
            if (self.is_running) {
                [self mq_pause];
                [self mq_sorted_added:object];
                [self mq_resume];
            }
            else {
                [self mq_sorted_added:object];
            }
        }
        else {
            if (self.is_running) {
                [self mq_pause];
                [self mq_sorted_added:object];
            }
            else {
                [self mq_sorted_added:object];
                [self mq_resume];
            }
        }
    }
}

- (void) mq_start {
    [self mq_resume];
}
- (void) mq_pause {
    self.is_running = false;
}
- (void) mq_resume {
    self.is_running = YES;
    
    __weak typeof(self) weak_self = self;
    void (^mq_excute)(void) = ^{
        __strong typeof(weak_self) strong_self = weak_self;
        if (strong_self.delegate_t
            && [strong_self.delegate_t respondsToSelector:@selector(mq_task_manager:excute_current_task:)]) {
            [strong_self.delegate_t mq_task_manager:weak_self
                          excute_current_task:^(BOOL is_error_occured, BOOL is_continue) {
                
                if (is_error_occured) {
                    [strong_self mq_pause];
                }
                else if (is_continue && strong_self.is_running) {
                    if (strong_self.array_tasks.count > 0) {
                        [strong_self.array_tasks removeObjectAtIndex:0];
                        if (strong_self.array_tasks.count > 0) [strong_self mq_resume];
                    }
                }
                
            }];
        }
    };
    
    if (self.queue_current != NULL) {
        dispatch_async(self.queue_current, ^{
            if (mq_excute) mq_excute();
        });
    }
    else {
        if (mq_excute) mq_excute();
    }
}
- (void) mq_finish {
    self.is_running = false;
    [self.array_tasks removeAllObjects];
}

#pragma mark - -----
- (void) mq_sorted_added : (id) t {
    if ([t isKindOfClass:[NSArray class]]) {
        [self.array_tasks addObjectsFromArray:t];
    }
    if ([t isKindOfClass:[MQTaskObject class]]) {
        [self.array_tasks addObject:t];
    }
    
    [self.array_tasks sortUsingComparator:^NSComparisonResult(MQTaskObject * obj1, MQTaskObject * obj2) {
        return obj1.i_task_position > obj2.i_task_position ; // ascending
    }];
}

- (NSMutableArray<MQTaskObject *> *)array_tasks {
    if (_array_tasks) return _array_tasks;
    NSMutableArray *t = [NSMutableArray array];
    _array_tasks = t;
    return _array_tasks;
}

@end

#pragma mark - -----

@implementation MQTaskObject

- (instancetype)init_id : (NSString *) s_task_id
               position : (NSUInteger) i_task_position
                 object : (id) object  {
    if (!s_task_id || !s_task_id.length || !object) return nil;
    if ((self = [super init])) {
        self.s_task_id = s_task_id;
        self.i_task_position = i_task_position;
        self.object_t = object;
    }
    return self;
}

@end
