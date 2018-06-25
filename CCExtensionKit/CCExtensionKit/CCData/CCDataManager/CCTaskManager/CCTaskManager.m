//
//  CCTaskManager.m
//  CCLocalLibrary
//
//  Created by ElwinFrederick on 2018/6/25.
//  Copyright © 2018 冯明庆. All rights reserved.
//

#import "CCTaskManager.h"

@interface CCTaskManager ()

@property (nonatomic , strong , readwrite) NSMutableArray <CCTaskObject *> *array_tasks ;
@property (nonatomic , readwrite) dispatch_queue_t queue_current ;

@property (nonatomic , assign) BOOL is_running ;

- (void) cc_sorted_added : (id) t ;

@end

@implementation CCTaskManager

- (instancetype) init_with_async_thread : (dispatch_queue_t) queue {
    if ((self = [super init])) {
        self.queue_current = queue;
        self.is_running = false;
    }
    return self;
}

- (void) cc_add_tasks : (NSArray < __kindof CCTaskObject *> *) objects
        remain_status : (BOOL) is_remain {
    if (objects && objects.count) {
        
        if (is_remain) {
            if (self.is_running) {
                [self cc_pause];
                [self cc_sorted_added:objects];
                [self cc_resume];
            }
            else {
                [self cc_sorted_added:objects];
            }
        }
        else {
            if (self.is_running) {
                [self cc_pause];
                [self cc_sorted_added:objects];
            }
            else {
                [self cc_sorted_added:objects];
                [self cc_resume];
            }
        }
        
    }
}
- (void) cc_add_task : (__kindof CCTaskObject *) object
       remain_status : (BOOL) is_remain {
    if (object && [object isKindOfClass:[CCTaskObject class]]) {
        if (is_remain) {
            if (self.is_running) {
                [self cc_pause];
                [self cc_sorted_added:object];
                [self cc_resume];
            }
            else {
                [self cc_sorted_added:object];
            }
        }
        else {
            if (self.is_running) {
                [self cc_pause];
                [self cc_sorted_added:object];
            }
            else {
                [self cc_sorted_added:object];
                [self cc_resume];
            }
        }
    }
}

- (void) cc_start {
    [self cc_resume];
}
- (void) cc_pause {
    self.is_running = false;
}
- (void) cc_resume {
    self.is_running = YES;
    
    __weak typeof(self) pSelf = self;
    void (^cc_excute)(void) = ^{
        if (pSelf.delegate_t
            && [pSelf.delegate_t respondsToSelector:@selector(cc_task_manager:excute_current_task:)]) {
            [pSelf.delegate_t cc_task_manager:pSelf
                          excute_current_task:^(BOOL is_error_occured, BOOL is_continue) {
                
                if (is_error_occured) {
                    [pSelf cc_pause];
                }
                else if (is_continue) {
                    if (pSelf.array_tasks.count > 0) {
                        [pSelf.array_tasks removeObjectAtIndex:0];
                        if (pSelf.array_tasks.count > 0) [pSelf cc_resume];
                    }
                }
                
            }];
        }
    };
    
    if (self.queue_current != NULL) {
        dispatch_async(self.queue_current, ^{
            if (cc_excute) cc_excute();
        });
    }
    else {
        if (cc_excute) cc_excute();
    }
}
- (void) cc_finish {
    self.is_running = false;
    [self.array_tasks removeAllObjects];
}

#pragma mark - -----
- (void) cc_sorted_added : (id) t {
    if ([t isKindOfClass:[NSArray class]]) {
        [self.array_tasks addObjectsFromArray:t];
    }
    if ([t isKindOfClass:[CCTaskObject class]]) {
        [self.array_tasks addObject:t];
    }
    
    [self.array_tasks sortUsingComparator:^NSComparisonResult(CCTaskObject * obj1, CCTaskObject * obj2) {
        return obj1.i_task_position > obj2.i_task_position ; // ascending
    }];
}

- (NSMutableArray<CCTaskObject *> *)array_tasks {
    if (_array_tasks) return _array_tasks;
    NSMutableArray *t = [NSMutableArray array];
    _array_tasks = t;
    return _array_tasks;
}

@end

#pragma mark - -----

@implementation CCTaskObject

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
